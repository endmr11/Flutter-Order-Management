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
    log(">>>>> INIT STATE WORKING");
    loginBloc = LoginBloc();
  }

  Future<void> fetchUser(String email, String password) async {
    log(">>>>> FETCHUSER FUNCTION WORKING");
    log(email + " " + password);
    loginBloc?.add(LoginProcessStart());
  }

  @override
  void dispose() {
    super.dispose();
    loginBloc?.close();
  }
}
