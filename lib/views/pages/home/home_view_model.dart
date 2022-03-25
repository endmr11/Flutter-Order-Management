import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_order_management/core/services/global_blocs/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';
import 'package:flutter_order_management/views/pages/home/bloc/home_bloc.dart';
import 'package:flutter_order_management/views/pages/home/home.dart';

import 'home_resources.dart';

abstract class HomeViewModel extends State<Home> with HomeResources {
  @override
  void initState() {
    super.initState();
    homeBloc = HomeBloc();
    homeBloc?.add(HomeProcessStart());
    shoppingCartBloc = ShoppingCartBloc();
    logSession();
  }

  @override
  void dispose() {
    super.dispose();
    homeBloc?.close();
    shoppingCartBloc?.close();
  }

  void logSession() {
    log(LocaleDatabaseHelper.i.currentUserId.toString(), name: "USER ID: ");
    log(LocaleDatabaseHelper.i.currentUserType.toString(), name: "USER TYPE: ");
    log(LocaleDatabaseHelper.i.isLight.toString(), name: "IS LIGHT?: ");
    log(LocaleDatabaseHelper.i.isLoggedIn.toString(), name: "IS LOGGED IN?: ");
    log(LocaleDatabaseHelper.i.currentUserEmail.toString(), name: "USER MAIL: ");
    log(LocaleDatabaseHelper.i.currentUserName.toString(), name: "USER NAME: ");
    log(LocaleDatabaseHelper.i.currentUserSurname.toString(), name: "USER SURNAME: ");
    log(LocaleDatabaseHelper.i.currentUserToken.toString(), name: "USER TOKEN: ");
  }
}
