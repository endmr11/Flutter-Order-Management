import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_order_management/data/models/base_models/base_response_model.dart';
import 'package:flutter_order_management/data/models/login_models/login_model.dart';
import 'package:flutter_order_management/data/models/login_models/login_request_model.dart';
import 'package:flutter_order_management/data/sources/api/api_service.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on(loginEventControl);
  }

  final apiService = APIService();

  Future<void> loginEventControl(LoginEvent event, Emitter<LoginState> emit) async {
    if (event is LoginProcessStart) {
      log("EMAIL: ${event.email} & PASSWORD: ${event.password}", name: "EVENT: LoginProcessStart");
      emit(LoginProcessLoading());
      BaseListResponse<LoginModel>? response = await apiService.login(LoginRequestModel(email: event.email, password: event.password));
      if (response != null) {
        setSession(response.model?.first);
        emit(LoginProcessSuccesful());
      } else {
        emit(LoginProcessError());
      }
    }
  }

  void setSession(LoginModel? data) {
    LocaleDatabaseHelper.i.setCurrentUserEmail(data?.email);
    LocaleDatabaseHelper.i.setCurrentUserType(data?.userType);
    LocaleDatabaseHelper.i.setCurrentUserId(data?.id);
    LocaleDatabaseHelper.i.setCurrentUserLoggedIn(true);
    LocaleDatabaseHelper.i.setCurrentUserName(data?.name);
    LocaleDatabaseHelper.i.setCurrentUserSurname(data?.surname);
    LocaleDatabaseHelper.i.setCurrentUserToken(data?.token);
  }
}
