import '../../../data/models/order_models/order_model.dart';
import '../../../data/models/product_models/product_model.dart';

abstract class IUtilManager {
  String? priceCalculate(List<Product>? products, List<ProductModel> allProducts);
}

class UtilManager extends IUtilManager {
  @override
  String? priceCalculate(List<Product>? products, List<ProductModel> allProducts) {
    int price = 0;
    products?.forEach((element) {
      ProductModel tempProduct = allProducts.firstWhere((val) => val.productId == element.productId);
      price += tempProduct.productPrice! * (element.count!);
    });
    return price.toString();
  }
}
