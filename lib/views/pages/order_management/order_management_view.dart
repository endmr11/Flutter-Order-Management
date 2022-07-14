import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_order_management/data/models/order_models/order_request_model.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';
import 'package:flutter_order_management/views/pages/login/login.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../widgets/dialog_managers/dialog_manager.dart';
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
      body: BlocConsumer(
        bloc: orderManagementBloc,
        listener: (context, state) {
          if (state is OrderManagementProcessError) {
            DialogManager.i.showClassicAlertDialog(
              context: context,
              title: "Hata",
              content: [Text(state.error)],
              actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Ok"))],
            );
          }
        },
        builder: (context, state) {
          if (state is OrderManagementProcessLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (state is OrderManagementProcessSuccesful) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.allOrders.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                if (state.allOrders[index].orderStatus == 0) {
                                  List<OrderProductModel> productList = [];
                                  for (int i = 0; i < state.allOrders[index].products!.length; i++) {
                                    productList.add(
                                      OrderProductModel(
                                        count: state.allOrders[index].products?[i].count,
                                        productId: state.allOrders[index].products?[i].productId,
                                      ),
                                    );
                                  }
                                  orderManagementBloc?.add(
                                    OrderManagementUpdateEvent(
                                      OrderRequestModel(
                                        userId: state.allOrders[index].userId,
                                        products: productList,
                                        userName: state.allOrders[index].userName,
                                        userSurname: state.allOrders[index].userSurname,
                                        orderStatus: state.allOrders[index].orderStatus == 0 ? 1 : 0,
                                      ),
                                      state.allOrders[index].orderId.toString(),
                                    ),
                                  );
                                }
                              },
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              icon: Icons.check,
                              label: 'Tamamlandı',
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: state.allOrders[index].orderStatus == 1 ? Colors.green.shade800 : Colors.red,
                            child: const Icon(Icons.check, color: Colors.white),
                          ),
                          title: Text(
                            state.allOrders[index].userName ?? "",
                          ),
                          trailing: Text("${utilManager.priceCalculate(state.allOrders[index].products, state.allProducts)}₺"),
                          onTap: () {
                            List<Widget> tempCartProducts = [];
                            state.allOrders[index].products?.forEach(
                              (element) {
                                ProductModel tempProduct = state.allProducts.firstWhere((val) => val.productId == element.productId);
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
                              totalPrice: utilManager.priceCalculate(state.allOrders[index].products, state.allProducts),
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
            );
          } else {
            return const Center(
              child: Text("Error"),
            );
          }
        },
      ),
    );
  }
}
