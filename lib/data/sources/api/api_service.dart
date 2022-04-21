import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_order_management/core/env/env_config.dart';
import 'package:flutter_order_management/data/models/base_models/base_response_model.dart';
import 'package:flutter_order_management/data/models/login_models/login_model.dart';
import 'package:flutter_order_management/data/models/login_models/login_request_model.dart';
import 'package:flutter_order_management/data/models/order_models/order_model.dart';
import 'package:flutter_order_management/data/models/order_models/order_request_model.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';
import 'package:flutter_order_management/data/models/refresh_token_models/refresh_token_model.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';
import 'package:http/http.dart' as http;

class APIService {
  Future<BaseListResponse<LoginModel>?> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(Platform.isWindows ? EnvConfig.windowsApiURL + EnvConfig.loginEP : EnvConfig.apiURL + EnvConfig.loginEP);
    var response = await http.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));
    final baseListResponse = BaseListResponse<LoginModel>.fromJson(json.decode(response.body), (data) => data.map((e) => LoginModel.fromJson(e)).toList());
    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:/login");
      return baseListResponse;
    }
    return null;
  }

  Future<BaseListResponse<ProductModel>?> getAllProducts() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${LocaleDatabaseHelper.i.currentUserToken}',
    };
    var url = Uri.parse(Platform.isWindows ? EnvConfig.windowsApiURL + EnvConfig.allProductsEP : EnvConfig.apiURL + EnvConfig.allProductsEP);
    var response = await http.get(url, headers: requestHeaders);
    final baseListResponse = BaseListResponse<ProductModel>.fromJson(json.decode(response.body), (data) => data.map((e) => ProductModel.fromJson(e)).toList());
    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.allProductsEP}");
      return baseListResponse;
    }
    if (response.statusCode == 401) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.allProductsEP}", error: "TOKEN EXPIRED");
      _refreshToken();
    }
    return null;
  }

  Future<BaseListResponse<OrderModel>?> getAllOrders() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${LocaleDatabaseHelper.i.currentUserToken}',
    };
    var url = Uri.parse(Platform.isWindows ? EnvConfig.windowsApiURL + EnvConfig.allOrdersEP : EnvConfig.apiURL + EnvConfig.allOrdersEP);
    var response = await http.get(url, headers: requestHeaders);
    final baseListResponse = BaseListResponse<OrderModel>.fromJson(json.decode(response.body), (data) => data.map((e) => OrderModel.fromJson(e)).toList());
    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.allOrdersEP}");
      return baseListResponse;
    }
    if (response.statusCode == 401) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.allOrdersEP}", error: "TOKEN EXPIRED");
      _refreshToken();
    }
    return null;
  }

  Future<BaseListResponse<OrderModel>?> getMyOrders(String userId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${LocaleDatabaseHelper.i.currentUserToken}',
    };
    var url = Uri.parse(Platform.isWindows ? EnvConfig.windowsApiURL + EnvConfig.myOrdersEP + userId : EnvConfig.apiURL + EnvConfig.myOrdersEP + userId);
    var response = await http.get(url, headers: requestHeaders);
    final baseListResponse = BaseListResponse<OrderModel>.fromJson(json.decode(response.body), (data) => data.map((e) => OrderModel.fromJson(e)).toList());
    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.myOrdersEP}");
      return baseListResponse;
    }
    if (response.statusCode == 401) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.myOrdersEP}", error: "TOKEN EXPIRED");
      _refreshToken();
    }
    return null;
  }

  Future<BaseListResponse<OrderModel>?> setOrder(OrderRequestModel? model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${LocaleDatabaseHelper.i.currentUserToken}',
    };
    var url = Uri.parse(Platform.isWindows ? EnvConfig.windowsApiURL + EnvConfig.orderCreateEP : EnvConfig.apiURL + EnvConfig.orderCreateEP);
    var response = await http.post(url, headers: requestHeaders, body: jsonEncode(model));
    final baseListResponse = BaseListResponse<OrderModel>.fromJson(json.decode(response.body), (data) => data.map((e) => OrderModel.fromJson(e)).toList());
    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.orderCreateEP}");
      return baseListResponse;
    }
    if (response.statusCode == 401) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.orderCreateEP}", error: "TOKEN EXPIRED");
      _refreshToken();
    }
    return null;
  }

  Future<BaseListResponse<OrderModel>?> updateOrder(OrderRequestModel? model, String orderId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${LocaleDatabaseHelper.i.currentUserToken}',
    };
    var url =
        Uri.parse(Platform.isWindows ? EnvConfig.windowsApiURL + EnvConfig.orderUpdateEP + orderId : EnvConfig.apiURL + EnvConfig.orderUpdateEP + orderId);
    var response = await http.put(url, headers: requestHeaders, body: jsonEncode(model));
    final baseListResponse = BaseListResponse<OrderModel>.fromJson(json.decode(response.body), (data) => data.map((e) => OrderModel.fromJson(e)).toList());
    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.orderUpdateEP + orderId}");
      return baseListResponse;
    }
    if (response.statusCode == 401) {
      log(response.statusCode.toString(), name: "API PATH:${EnvConfig.orderUpdateEP + orderId}", error: "TOKEN EXPIRED");
      _refreshToken();
    }
    return null;
  }

  Future<void> _refreshToken() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(Platform.isWindows ? EnvConfig.windowsApiURL + EnvConfig.refreshTokenEP : EnvConfig.apiURL + EnvConfig.refreshTokenEP);
    var response = await http.post(url, headers: requestHeaders, body: jsonEncode({"email": LocaleDatabaseHelper.i.currentUserEmail}));
    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:/${EnvConfig.refreshTokenEP}");
      var newToken = refreshTokenModelFromJson(response.body).model?.first.token;
      LocaleDatabaseHelper.i.setCurrentUserToken(newToken);
    }
  }
}
