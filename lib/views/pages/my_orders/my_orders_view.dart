import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_order_management/core/utils/widget/dialog_managers/dialog_manager.dart';
import 'package:flutter_order_management/data/models/order_models/order_model.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';

import 'bloc/my_orders_bloc.dart';
import 'my_orders_view_model.dart';

class MyOrdersView extends MyOrdersViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Siparişlerim"),
      ),
      body: BlocProvider(
        create: (context) => MyOrdersBloc(),
        child: BlocListener<MyOrdersBloc, MyOrdersState>(
          bloc: myOrdersBloc,
          listener: (context, state) {
            if (state is MyOrdersProcessLoading) {
              setState(() {
                isLoading = true;
              });
            } else if (state is MyOrdersProcessSuccesful) {
              setState(() {
                isLoading = false;
                allOrders = state.allOrders;
                allProducts = state.allProducts;
              });
            } else if (state is MyOrdersProcessError) {
              setState(() {
                isLoading = true;
              });
            }
          },
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: allOrders.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: allOrders[index].orderStatus == 1 ? Colors.green.shade800 : Colors.red,
                              child: const Icon(Icons.check, color: Colors.white),
                            ),
                            title: Text(
                              allOrders[index].userName ?? "",
                            ),
                            trailing: Text("${priceCalculate(allOrders[index].products)}₺"),
                            onTap: () {
                              List<Widget> tempCartProducts = [];
                              allOrders[index].products?.forEach(
                                (element) {
                                  ProductModel tempProduct = allProducts.firstWhere((val) => val.productId == element.productId);
                                  tempCartProducts.add(
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: Image.asset('assets/${tempProduct.productUrl}.png'),
                                      ),
                                      title: Text(tempProduct.productName ?? ""),
                                      subtitle: Text("Tane Fiyatı: ${tempProduct.productPrice}"),
                                      trailing: Text("${element.count} Adet"),
                                    ),
                                  );
                                },
                              );
                              DialogManager.i.showCartViewAlertDialog(
                                context: context,
                                title: "Sipariş Detayı",
                                content: tempCartProducts,
                                actions: [],
                                totalPrice: priceCalculate(allOrders[index].products),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  String? priceCalculate(List<Product>? products) {
    int price = 0;
    products?.forEach((element) {
      ProductModel tempProduct = allProducts.firstWhere((val) => val.productId == element.productId);
      price += tempProduct.productPrice! * (element.count!);
    });
    return price.toString();
  }
}


/*
isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Column()
*/