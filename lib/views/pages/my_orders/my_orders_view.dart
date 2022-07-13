import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';

import '../../../core/utils/util/util_manager.dart';
import '../../widgets/dialog_managers/dialog_manager.dart';
import 'bloc/my_orders_bloc.dart';
import 'my_orders_view_model.dart';

class MyOrdersView extends MyOrdersViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Siparişlerim"),
      ),
      body: BlocConsumer(
        bloc: myOrdersBloc,
        listener: (context, state) {},
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
                        trailing: Text("${UtilManager().priceCalculate(state.allOrders[index].products, state.allProducts)}₺"),
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
                            totalPrice: UtilManager().priceCalculate(state.allOrders[index].products, state.allProducts),
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


/*

BlocProvider(
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


isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Column()
*/