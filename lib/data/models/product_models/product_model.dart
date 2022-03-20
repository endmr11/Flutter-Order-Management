// To parse this JSON data, do
//
//     final productResponseModel = productResponseModelFromJson(jsonString);

import 'dart:convert';

ProductResponseModel productResponseModelFromJson(String str) => ProductResponseModel.fromJson(json.decode(str));

String productResponseModelToJson(ProductResponseModel data) => json.encode(data.toJson());

class ProductResponseModel {
  ProductResponseModel({
    this.status,
    this.message,
    this.path,
    this.model,
  });

  int? status;
  String? message;
  String? path;
  List<ProductModel>? model;

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) => ProductResponseModel(
        status: json["status"],
        message: json["message"],
        path: json["path"],
        model: json["model"] == null ? null : List<ProductModel>.from(json["model"].map((x) => ProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "path": path,
        "model": model == null ? null : List<dynamic>.from(model!.map((x) => x.toJson())),
      };
}

class ProductModel {
  ProductModel({
    this.productId,
    this.productName,
    this.productDesc,
    this.productPrice,
    this.productUrl,
  });

  int? productId;
  String? productName;
  String? productDesc;
  int? productPrice;
  String? productUrl;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productId: json["product_id"],
        productName: json["product_name"],
        productDesc: json["product_desc"],
        productPrice: json["product_price"],
        productUrl: json["product_url"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_desc": productDesc,
        "product_price": productPrice,
        "product_url": productUrl,
      };
}
