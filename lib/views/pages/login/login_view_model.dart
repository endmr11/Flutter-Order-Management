import 'package:flutter/material.dart';
import 'package:flutter_order_management/data/sources/api/api_service.dart';

import 'login.dart';
import 'login_bloc/login_bloc.dart';
import 'login_resources.dart';

abstract class LoginViewModel extends State<Login> with LoginResources {
  LoginBloc? loginBloc;

  @override
  void initState() {
    loginBloc = LoginBloc(APIService());
    super.initState();
  }

  Future<void> login(String email, String password) async {
    loginBloc?.add(LoginProcessStart(email, password));
  }

  @override
  void dispose() {
    loginBloc?.close();
    super.dispose();
  }
}
