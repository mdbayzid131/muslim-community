import 'dart:async';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/config/constants/storage_constants.dart';
import 'package:muslim_community/core/services/storage_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';

class SocketService extends GetxService {
  io.Socket? _socket;
  bool _isConnecting = false;
  Completer<void>? _connectionCompleter;

  // Registered event handlers mapped by event name
  final Map<String, List<Function(dynamic)>> _listenersMap = {};

  bool get isConnected => _socket != null && _socket!.connected;
  io.Socket? get socket => _socket;

  Future<void> connect() async {
    if (_socket != null && _socket!.connected) {
      return;
    }

    if (_isConnecting) {
      return _connectionCompleter?.future;
    }

    _isConnecting = true;
    _connectionCompleter = Completer<void>();

    try {
      final token = await StorageService.getString(StorageConstants.bearerToken);
      if (token.isEmpty) {
        Helpers.debug('🔌 [SOCKET] Connect skipped: Bearer token is empty');
        _isConnecting = false;
        return;
      }

      final serverUrl = ApiConstants.serverUrl;
      final cleanToken = token.startsWith('Bearer ') ? token.substring(7) : token;
      final bearerToken = 'Bearer $cleanToken';

      if (_socket == null) {
        Helpers.debug('🔌 [SOCKET CONNECTING] Creating socket connection to: $serverUrl');

        _socket = io.io(
          serverUrl,
          io.OptionBuilder()
              .setTransports(['websocket'])
              .setAuth({
                'token': cleanToken,
                'accessToken': cleanToken,
                'authorization': bearerToken,
                'Authorization': bearerToken,
              })
              .setQuery({
                'token': cleanToken,
              })
              .setExtraHeaders({
                'Authorization': bearerToken,
                'authorization': bearerToken,
                'token': cleanToken,
              })
              .disableAutoConnect()
              .enableReconnection()
              .setReconnectionAttempts(10)
              .setReconnectionDelay(3000)
              .build(),
        );

        _setupSocketInternalListeners();
      }

      if (!_socket!.connected) {
        _socket!.connect();
      }

      return await _connectionCompleter!.future;
    } catch (e) {
      _isConnecting = false;
      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.completeError(e);
      }
      Helpers.error('❌ [SOCKET INIT ERROR] $e');
    }
  }

  void _setupSocketInternalListeners() {
    if (_socket == null) return;

    _socket!.onConnect((_) async {
      Helpers.debug('✅ [SOCKET CONNECTED] Connected successfully! Socket ID: ${_socket?.id}');
      _isConnecting = false;

      final storedUserId = await StorageService.getString(StorageConstants.userId);
      if (storedUserId.isNotEmpty) {
        try {
          Helpers.debug('📤 [SOCKET EMIT] Setup user presence for: $storedUserId');
          _socket?.emit('setup', storedUserId);
          _socket?.emit('addUser', storedUserId);
          _socket?.emit('join_user', storedUserId);
          _socket?.emit('user_connected', storedUserId);
        } catch (_) {}
      }

      // Re-attach all listeners that were registered
      _reattachListeners();

      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.complete();
      }
    });

    _socket!.onDisconnect((reason) {
      Helpers.debug('❌ [SOCKET DISCONNECTED] Reason: $reason');
      _isConnecting = false;
    });

    _socket!.onConnectError((data) {
      Helpers.debug('⚠️ [SOCKET CONNECT ERROR] Error: $data');
      _isConnecting = false;
      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.completeError(data);
      }
    });

    _socket!.onError((data) {
      Helpers.debug('⚠️ [SOCKET ERROR] Error: $data');
      _isConnecting = false;
    });
  }

  void _reattachListeners() {
    if (_socket == null) return;
    _listenersMap.forEach((event, handlers) {
      _socket!.off(event);
      for (var handler in handlers) {
        _socket!.on(event, (data) {
          Helpers.debug('📥 [SOCKET RECEIVED] Event: "$event" | Payload: $data');
          handler(data);
        });
      }
    });
  }

  void disconnect() {
    if (_socket != null) {
      try {
        Helpers.debug('🔌 [SOCKET DISCONNECTING] Disconnecting socket...');
        _socket!.disconnect();
      } catch (e) {
        Helpers.debug('Error disconnecting socket: $e');
      }
      _isConnecting = false;
    }
  }

  void emit(String event, dynamic data) {
    if (isConnected) {
      try {
        Helpers.debug('📤 [SOCKET EMIT] Event: "$event" | Payload: $data');
        _socket?.emit(event, data);
      } catch (e) {
        Helpers.debug('❌ [SOCKET EMIT ERROR] Event "$event": $e');
      }
    } else {
      Helpers.debug('⚠️ [SOCKET EMIT PENDING] Socket not connected. Connecting & emitting "$event"...');
      connect().then((_) {
        try {
          Helpers.debug('📤 [SOCKET EMIT RETRY] Event: "$event" | Payload: $data');
          _socket?.emit(event, data);
        } catch (_) {}
      });
    }
  }

  void on(String event, Function(dynamic) handler) {
    _listenersMap.putIfAbsent(event, () => []).add(handler);
    Helpers.debug('👂 [SOCKET LISTEN] Subscribed to event: "$event"');

    if (_socket != null) {
      _socket!.on(event, (data) {
        Helpers.debug('📥 [SOCKET RECEIVED] Event: "$event" | Payload: $data');
        handler(data);
      });
    }
  }

  void off(String event) {
    _listenersMap.remove(event);
    _socket?.off(event);
    Helpers.debug('🔇 [SOCKET UNLISTEN] Unsubscribed event: "$event"');
  }

  void clearListeners() {
    _listenersMap.clear();
    _socket?.clearListeners();
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
