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

    final token = await StorageService.getString(StorageConstants.bearerToken);
    final serverUrl = ApiConstants.serverUrl;

    Helpers.debug('Attempting to connect to socket at: $serverUrl');

    _socket = io.io(
      serverUrl,
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .setAuth({'token': token})
          .setQuery({'token': token})
          .setExtraHeaders({'Authorization': 'Bearer $token', 'token': token})
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(2000)
          .build(),
    );

    _socket!.onConnect((_) {
      Helpers.debug('Socket connected with id: ${_socket!.id}');
      _isConnecting = false;
      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.complete();
      }
    });

    _socket!.onDisconnect((_) {
      Helpers.debug('Socket disconnected');
      _isConnecting = false;
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

    return _connectionCompleter!.future;
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.clearListeners();
      _socket!.disconnect();
      _socket = null;
      _isConnecting = false;
    }
  }

  void emit(String event, dynamic data) {
    if (isConnected) {
      _socket?.emit(event, data);
    } else {
      Helpers.debug('Cannot emit event "$event". Socket not connected.');
    }
  }

  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  void off(String event) {
    _socket?.off(event);
  }

  void clearListeners() {
    _socket?.clearListeners();
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
