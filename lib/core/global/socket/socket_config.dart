import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as socketio;

import '../../../data/models/order_models/order_model.dart';
import '../../../data/sources/database/local_database_helper.dart';
import '../../../views/pages/my_orders/my_orders_bloc/my_orders_bloc.dart';
import '../../../views/pages/order_management/order_management_bloc/order_management_bloc.dart';

abstract class ISocketConfig {
  late final socketio.Socket _socket;
  ISocketConfig(socketio.Socket socket) {
    _socket = socket;
  }
  socketio.Socket getSocket();
  Future<void> initSocket(MyOrdersBloc myOrdersBloc, OrderManagementBloc orderManagementBloc);
  Future<void> closeSocket();
}

class SocketConfig extends ISocketConfig {
  SocketConfig(socketio.Socket socket) : super(socket);
  late final MyOrdersBloc _myOrdersBloc;
  late final OrderManagementBloc _orderManagementBloc;

  @override
  socketio.Socket getSocket() {
    return _socket;
  }

  @override
  Future<void> initSocket(MyOrdersBloc myOrdersBloc, OrderManagementBloc orderManagementBloc) async {
    try {
      _socket.onConnect((_) {
        log('onConnect', name: "onConnect");
        _socket.emit('isConnected', 'yes');
      });
      _socket.on('connectionStatus', (_) => log('Result => $_', name: "connectionStatus"));
      _myOrdersBloc = myOrdersBloc;
      _orderManagementBloc = orderManagementBloc;
      _socket.on('updateOrderResponse', (val) {
        Map<String, dynamic> jsonVal = val;
        OrderModel model = OrderModel.fromJson(jsonVal);
        log('Result => $model', name: "updateOrderResponse");
        if (model.userId == LocaleDatabaseHelper.i.currentUserId && _myOrdersBloc.isClosed) {
          _myOrdersBloc.add(MyOrdersProcessSocketUpdateEvent(model));
        }
      });
      _socket.on('createOrderResponse', (val) {
        Map<String, dynamic> jsonVal = val;
        OrderModel model = OrderModel.fromJson(jsonVal);
        log('Result => $model', name: "createOrderResponse");
        if (!_orderManagementBloc.isClosed) {
          _orderManagementBloc.add(OrderManagementSocketCreateEvent(model));
        }
      });
      _socket.on('updateOrderResponse', (val) {
        Map<String, dynamic> jsonVal = val;
        OrderModel model = OrderModel.fromJson(jsonVal);
        log('Result => $model', name: "updateOrderResponse");
        if (!_orderManagementBloc.isClosed) {
          _orderManagementBloc.add(OrderManagementSocketUpdateEvent(model));
        }
      });
      _socket.on('deleteOrderResponse', (val) => log('Result => $val', name: "deleteOrderResponse"));
    } catch (e) {
      log(e.toString(), error: "Socket Connection Error");
    }
  }

  @override
  Future<void> closeSocket() async {
    try {
      _socket.close();
    } catch (e) {
      log(e.toString(), error: "Socket Close Error");
    }
  }
}
