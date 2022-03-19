import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_order_management/data/models/login_models/login_model.dart';
import 'package:flutter_order_management/data/models/login_models/login_request_model.dart';
import 'package:flutter_order_management/data/sources/api/api_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on(loginEventControl);
  }
  Future<void> loginEventControl(LoginEvent event, Emitter<LoginState> emit) async {
    if (event is LoginProcessStart) {
      log("EMAIL: ${event.email} & PASSWORD: ${event.password}", name: "EVENT: LoginProcessStart");
      emit(LoginProcessLoading());
      LoginResponseModel? model = await APIService.login(LoginRequestModel(email: event.email, password: event.password));
      if (model != null) {
        emit(LoginProcessSuccesful());
      } else {
        emit(LoginProcessError());
      }
    }
  }
}
