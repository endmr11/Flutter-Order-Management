import 'dart:developer';

import 'package:flutter/material.dart';

import 'bloc/login_bloc.dart';
import 'login.dart';
import 'login_resources.dart';

abstract class LoginViewModel extends State<Login> with LoginResources {
  LoginBloc? loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = LoginBloc();
  }

  Future<void> login(String email, String password) async {
    log(email + " " + password);
    loginBloc?.add(LoginProcessStart(email, password));
  }

  @override
  void dispose() {
    super.dispose();
    loginBloc?.close();
  }
}
