part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [UniqueKey()];
}

class LoginProcessStart extends LoginEvent {
  final String email;
  final String password;

  const LoginProcessStart(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}
