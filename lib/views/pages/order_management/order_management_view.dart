import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_order_management/core/utils/widget/dialog_managers/dialog_manager.dart';
import 'package:flutter_order_management/data/models/order_models/order_model.dart';
import 'package:flutter_order_management/data/models/order_models/order_request_model.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';
import 'package:flutter_order_management/views/pages/login/login.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'bloc/order_management_bloc.dart';
import 'order_management_view_model.dart';

class OrderManagementView extends OrderManagementViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Siparişler"),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => OrderManagementBloc(),
        child: BlocListener<OrderManagementBloc, OrderManagementState>(
          bloc: orderManagementBloc,
          listener: (context, state) {
            if (state is OrderManagementProcessLoading) {
              setState(() {
                isLoading = true;
              });
            } else if (state is OrderManagementProcessSuccesful) {
              setState(() {
                isLoading = false;
                allOrders = state.allOrders;
                allProducts = state.allProducts;
              });
            } else if (state is OrderManagementProcessError) {
              setState(() {
                isLoading = true;
              });
            } else if (state is OrderManagementUpdateLoading) {
              setState(() {
                isLoading = true;
              });
            } else if (state is OrderManagementUpdateSuccesful) {
              print(state.responseOrder.first.orderId);
              setState(() {
                isLoading = false;
              });
            } else if (state is OrderManagementUpdateError) {
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
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    if (allOrders[index].orderStatus == 0) {
                                      List<OrderProductModel> productList = [];
                                      for (int i = 0; i < allOrders[index].products!.length; i++) {
                                        productList.add(
                                          OrderProductModel(
                                            count: allOrders[index].products?[i].count,
                                            productId: allOrders[index].products?[i].productId,
                                          ),
                                        );
                                      }
                                      orderManagementBloc?.add(
                                        OrderManagementUpdateEvent(
                                          OrderRequestModel(
                                            userId: allOrders[index].userId,
                                            products: productList,
                                            userName: allOrders[index].userName,
                                            userSurname: allOrders[index].userSurname,
                                            orderStatus: allOrders[index].orderStatus == 0 ? 1 : 0,
                                          ),
                                          allOrders[index].orderId.toString(),
                                        ),
                                      );
                                    }
                                  },
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: Icons.check,
                                  label: 'Tamamlandı',
                                ),
                                SlidableAction(
                                  onPressed: null,
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Sil',
                                ),
                              ],
                            ),
                            child: ListTile(
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
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await LocaleDatabaseHelper.i.userSessionClear();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const Login(),
                          ),
                        );
                      },
                      child: const Text("Çık"),
                    )
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

classicButton(
            text: "Çıkk",
            customOnPressed: () async {
              await LocaleDatabaseHelper.i.userSessionClear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const Login(),
                ),
              );
            },
          ),
 */