import 'package:socket_io_client/socket_io_client.dart' as socketio;

import 'bloc/order_management_bloc.dart';

mixin OrderManagementResources {
  OrderManagementBloc? orderManagementBloc;
  bool isLoading = false;
  socketio.Socket? socket;
}
