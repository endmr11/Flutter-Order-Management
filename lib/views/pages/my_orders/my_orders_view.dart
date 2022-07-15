import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';

import '../../widgets/dialog_managers/dialog_manager.dart';
import 'my_orders_bloc/my_orders_bloc.dart';
import 'my_orders_view_model.dart';

class MyOrdersView extends MyOrdersViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Siparişlerim"),
      ),
      body: BlocConsumer(
        bloc: context.read<MyOrdersBloc>(),
        listener: (context, state) {
          if (state is MyOrdersProcessError) {
            DialogManager.i.showClassicAlertDialog(
              context: context,
              title: "Hata",
              content: [Text(state.error)],
              actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Ok"))],
            );
          }
        },
        builder: (context, state) {
          if (state is MyOrdersProcessLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (state is MyOrdersProcessSuccesful) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.allOrders.length,
                    itemBuilder: (context, index) {
                      return ListTile(
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
                      );
                    },
                  ),
                ),
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
