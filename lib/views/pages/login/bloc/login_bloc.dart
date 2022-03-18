import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on(loginEventControl);
  }
  Future<void> loginEventControl(LoginEvent event, Emitter<LoginState> emit) async {
    if (event is LoginProcessStart) {
      emit(LoginProcessLoading());
      Future.delayed(const Duration(seconds: 2));
      emit(LoginProcessSuccesful());
    }
  }
}