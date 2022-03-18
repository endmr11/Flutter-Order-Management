import 'package:flutter/material.dart';

import 'bloc/login_bloc.dart';
import 'login.dart';
import 'login_resources.dart';


abstract class LoginViewModel extends State<Login> with LoginResources {
  LoginBloc? loginBloc;

  @override
  void initState() {
    super.initState();
    print(">>>>> INIT STATE WORKING");
    loginBloc = LoginBloc();
  }

  Future<void> fetchUser(String email, String password) async {
    print(">>>>> FETCHUSER FUNCTION WORKING");
    print(email + " " + password);
    //loginBloc?.add(LoginProcessStart());
  }

  @override
  void dispose() {
    super.dispose();
    loginBloc?.close();
  }
}