import 'dart:convert';
import 'dart:developer';

import 'package:flutter_order_management/core/env/env_config.dart';
import 'package:flutter_order_management/data/models/login_models/login_model.dart';
import 'package:flutter_order_management/data/models/login_models/login_request_model.dart';
import 'package:flutter_order_management/data/models/order_models/order_model.dart';
import 'package:flutter_order_management/data/models/order_models/order_request_model.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';
import 'package:flutter_order_management/data/models/refresh_token_models/refresh_token_model.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';
import 'package:http/http.dart' as http;

class APIService {
  Future<LoginResponseModel?> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(EnvConfig.apiURL + EnvConfig.loginEP);
    var response = await http.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));
    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:/login");
      return loginResponseModelFromJson(response.body);
    }
  }

  Future<ProductResponseModel?> getAllProducts() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${LocaleDatabaseHelper.i.currentUserToken}',
    };
    var url = Uri.parse(EnvConfig.apiURL + EnvConfig.allProductsEP);
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.allProductsEP}");
      return productResponseModelFromJson(response.body);
    }
    if (response.statusCode == 401) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.allProductsEP}", error: "TOKEN EXPIRED");
      _refreshToken();
    }
  }

  Future<OrderResponseModel?> getAllOrders() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${LocaleDatabaseHelper.i.currentUserToken}',
    };
    var url = Uri.parse(EnvConfig.apiURL + EnvConfig.allOrdersEP);
    var response = await http.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.allOrdersEP}");
      return orderResponseModelFromJson(response.body);
    }
    if (response.statusCode == 401) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.allOrdersEP}", error: "TOKEN EXPIRED");
      _refreshToken();
    }
  }

  Future<OrderResponseModel?> getMyOrders(String userId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${LocaleDatabaseHelper.i.currentUserToken}',
    };
    var url = Uri.parse(EnvConfig.apiURL + EnvConfig.myOrdersEP + userId);
    var response = await http.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.myOrdersEP}");
      return orderResponseModelFromJson(response.body);
    }
    if (response.statusCode == 401) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.myOrdersEP}", error: "TOKEN EXPIRED");
      _refreshToken();
    }
  }

  Future<OrderResponseModel?> setOrder(OrderRequestModel? model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${LocaleDatabaseHelper.i.currentUserToken}',
    };
    var url = Uri.parse(EnvConfig.apiURL + EnvConfig.orderCreateEP);
    var response = await http.post(url, headers: requestHeaders, body: jsonEncode(model));
    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.orderCreateEP}");
      return orderResponseModelFromJson(response.body);
    }
    if (response.statusCode == 401) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.orderCreateEP}", error: "TOKEN EXPIRED");
      _refreshToken();
    }
  }

  Future<OrderResponseModel?> updateOrder(OrderRequestModel? model, String orderId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${LocaleDatabaseHelper.i.currentUserToken}',
    };
    var url = Uri.parse(EnvConfig.apiURL + EnvConfig.orderUpdateEP + orderId);
    var response = await http.put(url, headers: requestHeaders, body: jsonEncode(model));
    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.orderUpdateEP + orderId}");
      return orderResponseModelFromJson(response.body);
    }
    if (response.statusCode == 401) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.orderUpdateEP + orderId}", error: "TOKEN EXPIRED");
      _refreshToken();
    }
  }

  Future<void> _refreshToken() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(EnvConfig.apiURL + EnvConfig.refreshTokenEP);
    var response = await http.post(url, headers: requestHeaders, body: jsonEncode({"email": LocaleDatabaseHelper.i.currentUserEmail}));
    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:/${EnvConfig.refreshTokenEP}");
      var newToken = refreshTokenModelFromJson(response.body).model?.first.token;
      LocaleDatabaseHelper.i.setCurrentUserToken(newToken);
    }
  }
}
