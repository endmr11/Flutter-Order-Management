import 'dart:developer';
import 'dart:io';

import 'package:flutter_order_management/core/env/env_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketio;

class SocketConfig {
  SocketConfig._();
  static final SocketConfig _instance = SocketConfig._();
  static SocketConfig get i => _instance;
  static socketio.Socket socket = socketio.io(Platform.isWindows ? EnvConfig.windowsSocketURL : EnvConfig.socketURL, <String, dynamic>{
    'transports': ['websocket'],
  });

  Future<void> initSocket() async {
    try {
      socket.onConnect((_) {
        log('onConnect', name: "onConnect");
        socket.emit('isConnected', 'yes');
      });
      socket.on('connectionStatus', (_) => log('Result => $_', name: "connectionStatus"));
    } catch (e) {
      log(e.toString(), error: "Socket Connection Error");
    }
  }

  Future<void> closeSocket() async {
    try {
      socket.close();
    } catch (e) {
      log(e.toString(), error: "Socket Close Error");
    }
  }
}
