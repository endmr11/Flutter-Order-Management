import 'dart:convert';
import 'dart:developer';

import 'package:flutter_order_management/core/env/env_config.dart';
import 'package:flutter_order_management/data/models/login_models/login_model.dart';
import 'package:flutter_order_management/data/models/login_models/login_request_model.dart';
import 'package:flutter_order_management/data/models/order_models/order_model.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';
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
      log(response.statusCode.toString(), name: "API PATH:/products/all-products");
      return productResponseModelFromJson(response.body);
    }
  }

  Future<OrderResponseModel?> getAllOrders() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${LocaleDatabaseHelper.i.currentUserToken}',
    };
    var url = Uri.parse(EnvConfig.apiURL + EnvConfig.allOrderssEP);
    var response = await http.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      log(response.statusCode.toString(), name: "API PATH:/orders/all-orders");
      return orderResponseModelFromJson(response.body);
    }
  }
}
