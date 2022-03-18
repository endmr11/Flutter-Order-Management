// To parse this JSON data, do
//
//     final orderResponseModel = orderResponseModelFromJson(jsonString);

import 'dart:convert';

OrderResponseModel orderResponseModelFromJson(String str) => OrderResponseModel.fromJson(json.decode(str));

String orderResponseModelToJson(OrderResponseModel data) => json.encode(data.toJson());

class OrderResponseModel {
  OrderResponseModel({
    this.status,
    this.message,
    this.path,
    this.model,
  });

  int? status;
  String? message;
  String? path;
  List<Model>? model;

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) => OrderResponseModel(
        status: json["status"],
        message: json["message"],
        path: json["path"],
        model: json["model"] == null ? null : List<Model>.from(json["model"].map((x) => Model.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "path": path,
        "model": model == null ? null : List<dynamic>.from(model!.map((x) => x.toJson())),
      };
}

class Model {
  Model({
    this.orderId,
    this.userId,
    this.products,
  });

  int? orderId;
  int? userId;
  List<Product>? products;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        orderId: json["order_id"],
        userId: json["user_id"],
        products: json["products"] == null ? null : List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "user_id": userId,
        "products": products == null ? null : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    this.productId,
    this.count,
  });

  int? productId;
  int? count;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["product_id"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "count": count,
      };
}
