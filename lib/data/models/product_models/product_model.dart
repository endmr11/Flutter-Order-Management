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
