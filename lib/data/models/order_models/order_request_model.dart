import 'dart:convert';

OrderRequestModel orderRequestModelFromJson(String str) => OrderRequestModel.fromJson(json.decode(str));

String orderRequestModelToJson(OrderRequestModel data) => json.encode(data.toJson());

class OrderRequestModel {
  OrderRequestModel({
    this.userId,
    this.products,
    this.userName,
    this.userSurname,
  });

  int? userId;
  List<OrderProductModel>? products;
  String? userName;
  String? userSurname;

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) => OrderRequestModel(
        userId: json["user_id"],
        products: json["products"] == null ? null : List<OrderProductModel>.from(json["products"].map((x) => OrderProductModel.fromJson(x))),
        userName: json["user_name"],
        userSurname: json["user_surname"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "products": products == null ? null : List<dynamic>.from(products!.map((x) => x.toJson())),
        "user_name": userName,
        "user_surname": userSurname,
      };
}

class OrderProductModel {
  OrderProductModel({
    this.productId,
    this.count,
  });

  int? productId;
  int? count;

  factory OrderProductModel.fromJson(Map<String, dynamic> json) => OrderProductModel(
        productId: json["product_id"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "count": count,
      };
}
