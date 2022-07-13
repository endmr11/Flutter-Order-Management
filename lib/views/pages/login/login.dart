import 'package:flutter/material.dart';

import '../../../core/global/global_blocs/main_bloc/main_bloc.dart';
import 'login_view.dart';

class Login extends StatefulWidget {
  final MainBloc? themeBloc;
  const Login({Key? key,this.themeBloc}) : super(key: key);

  @override
  LoginView createState() => LoginView();
}
