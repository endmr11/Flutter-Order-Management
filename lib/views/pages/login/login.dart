import 'package:flutter/material.dart';

import 'login_view.dart';

class Login extends StatefulWidget {
  static const String routeName = '/login'; 
  const Login({Key? key}) : super(key: key);

  @override
  LoginView createState() => LoginView();
}
