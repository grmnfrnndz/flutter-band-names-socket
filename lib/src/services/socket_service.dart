import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier {

  // cuidado al escribir el codigo - ver bien la sintaxys

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {

    this._socket = IO.io('http://192.168.1.13:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    
    // socket.connect();

    this._socket.onConnect((_) {
      print('Flutter conectado al servidor');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.onDisconnect((_) {
      print('Flutter desconectado del servidor');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });


  }




}

