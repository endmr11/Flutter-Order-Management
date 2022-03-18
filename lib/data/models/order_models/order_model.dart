import 'dart:convert';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    this.orderId,
    this.userId,
    this.products,
  });

  int? orderId;
  int? userId;
  List<Product>? products;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
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
