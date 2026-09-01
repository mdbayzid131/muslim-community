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
        Helpers.debug('Socket connect skipped: Bearer token is empty');
        _isConnecting = false;
        return;
      }

      final serverUrl = ApiConstants.serverUrl;
      final cleanToken = token.startsWith('Bearer ') ? token.substring(7) : token;
      final bearerToken = 'Bearer $cleanToken';

      Helpers.debug('Attempting to connect to socket at: $serverUrl');

      // Dispose any prior disconnected socket instance
      if (_socket != null) {
        try {
          _socket!.clearListeners();
          _socket!.disconnect();
          _socket!.dispose();
        } catch (_) {}
        _socket = null;
      }

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
            .setReconnectionAttempts(3)
            .setReconnectionDelay(5000)
            .build(),
      );

      final storedUserId = await StorageService.getString(StorageConstants.userId);

      _socket!.onConnect((_) {
        Helpers.debug('Socket connected with id: ${_socket?.id}');
        _isConnecting = false;

        // Automatically register user presence on socket
        if (storedUserId.isNotEmpty) {
          try {
            _socket?.emit('setup', storedUserId);
            _socket?.emit('addUser', storedUserId);
            _socket?.emit('join_user', storedUserId);
            _socket?.emit('user_connected', storedUserId);
          } catch (_) {}
        }

        if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
          _connectionCompleter!.complete();
        }
      });

      _socket!.onDisconnect((reason) {
        Helpers.debug('Socket disconnected: $reason');
        _isConnecting = false;
        if (reason == 'io server disconnect') {
          // Server rejected / closed connection. Don't spam immediate reconnect.
          _socket?.disconnect();
        }
      });

      _socket!.onConnectError((data) {
        Helpers.debug('Socket Connect Error: $data');
        _isConnecting = false;
        if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
          _connectionCompleter!.completeError(data);
        }
      });

      _socket!.onError((data) {
        Helpers.debug('Socket Error: $data');
        _isConnecting = false;
      });

      _socket!.connect();

      return await _connectionCompleter!.future;
    } catch (e) {
      _isConnecting = false;
      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.completeError(e);
      }
      Helpers.error('Socket initialization error: $e');
    }
  }

  void disconnect() {
    if (_socket != null) {
      try {
        _socket!.clearListeners();
        _socket!.disconnect();
        _socket!.dispose();
      } catch (e) {
        Helpers.debug('Error disconnecting socket: $e');
      }
      _socket = null;
      _isConnecting = false;
    }
  }

  void emit(String event, dynamic data) {
    if (isConnected) {
      try {
        _socket?.emit(event, data);
      } catch (e) {
        Helpers.debug('Error emitting event "$event": $e');
      }
    } else {
      Helpers.debug('Cannot emit event "$event". Socket not connected.');
    }
  }

  void on(String event, Function(dynamic) handler) {
    try {
      _socket?.on(event, handler);
    } catch (e) {
      Helpers.debug('Error listening to event "$event": $e');
    }
  }

  void off(String event) {
    try {
      _socket?.off(event);
    } catch (e) {
      Helpers.debug('Error removing listener for event "$event": $e');
    }
  }

  void clearListeners() {
    try {
      _socket?.clearListeners();
    } catch (e) {
      Helpers.debug('Error clearing listeners: $e');
    }
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
