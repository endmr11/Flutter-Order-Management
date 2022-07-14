import 'dart:io';

class EnvConfig{
  static String apiURL = Platform.isIOS ? 'http://localhost:8080' : "http://10.0.2.2:8080";
  static String socketApiURL = Platform.isIOS ? 'http://localhost:8083' : "http://10.0.2.2:8083";
  static const String refreshTokenEP = "/refresh/token";
  static const String loginEP = "/login";
  static const String allProductsEP = "/products/all-products";
  static const String allOrdersEP = "/orders/all-orders";
  static const String myOrdersEP = "/orders/my-orders/";
  static const String orderCreateEP = "/orders/order-create";
  static const String orderUpdateEP = "/orders/order-update/";
}