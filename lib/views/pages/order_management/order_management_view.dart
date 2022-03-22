import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_order_management/data/models/order_models/order_model.dart';
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
              });
            } else if (state is OrderManagementProcessError) {
              setState(() {
                isLoading = false;
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
                            endActionPane: const ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: null,
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
                              title: Text(
                                allOrders[index].userName ?? "",
                              ),
                              trailing: Text("${priceCalculate(allOrders[index].products)}₺"),
                              onTap: () {},
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

  String priceCalculate(List<Product>? products) {

    products?.forEach((element) {
      print(">>>>  ${element.count}");
    });
    return "";
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