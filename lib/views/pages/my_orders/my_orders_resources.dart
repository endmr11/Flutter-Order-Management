import 'package:flutter_order_management/views/pages/my_orders/bloc/my_orders_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketio;

mixin MyOrdersResources {
  MyOrdersBloc? myOrdersBloc;
  bool isLoading = false;
  socketio.Socket? socket;
}
