import 'package:flutter/material.dart';
import 'package:flutter_order_management/views/pages/home/home.dart';
import 'package:flutter_order_management/views/pages/login/login.dart';
import 'package:flutter_order_management/views/pages/my_orders/my_orders.dart';
import 'package:flutter_order_management/views/pages/order_management/order_management.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case MyOrders.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const MyOrders(),
      );
    case Login.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Login(),
      );
    case Home.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Home(),
      );
    case OrderManagement.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OrderManagement(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Ekran bulunmamaktadır!'),
          ),
        ),
      );
  }
}
