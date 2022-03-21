import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_order_management/core/services/global_blocs/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:flutter_order_management/core/utils/widget/dialog_managers/dialog_manager.dart';
import 'package:flutter_order_management/data/models/order_models/order_request_model.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';
import 'package:flutter_order_management/views/components/buttons/classic_button.dart';
import 'package:flutter_order_management/views/pages/login/login.dart';

import 'bloc/home_bloc.dart';
import 'home_view_model.dart';

class HomeView extends HomeViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DEGrocery"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            classicButton(
              text: "Çık",
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
          ],
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
          BlocProvider(
            create: (context) => ShoppingCartBloc(),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<HomeBloc, HomeState>(
              bloc: homeBloc,
              listener: (context, state) {
                if (state is HomeProcessLoading) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state is HomeProcessSuccesful) {
                  setState(() {
                    allProducts = state.allProducts;
                    isLoading = false;
                  });
                } else if (state is HomeProcessError) {
                  setState(() {
                    isLoading = true;
                    Future.delayed(const Duration(seconds: 2)).then((value) {
                      homeBloc?.add(HomeProcessStart());
                    });
                  });
                }
              },
            ),
            BlocListener<ShoppingCartBloc, ShoppingCartState>(
              bloc: shoppingCartBloc,
              listener: (context, state) {
                if (state is ShoppingCartAddedState) {
                  if (!cartProducts.contains(state.product)) {
                    setState(() {
                      cartProductCount.add(1);
                      cartProducts.add(state.product);
                    });
                  } else {
                    DialogManager.i.showClassicAlertDialog(
                      context: context,
                      title: "Uyarı",
                      content: [Text("Ürün zaten ekli. Sepetten ürünü çoğaltabilirsiniz!")],
                      actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Ok"))],
                    );
                  }
                }
              },
            ),
          ],
          child: isLoading ?? true
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Hoşgeldiniz", style: Theme.of(context).textTheme.headline4),
                      screenIndex != 0
                          ? Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: cartProducts.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.transparent,
                                                  child: Image.asset('assets/${cartProducts[index].productUrl}.png'),
                                                ),
                                                title: Text("${cartProducts[index].productName} ${cartProducts[index].productPrice}"),
                                                subtitle: Text(cartProducts[index].productDesc ?? ""),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (cartProductCount[index] != 1) {
                                                        cartProductCount[index] -= 1;
                                                      } else {
                                                        cartProducts.remove(cartProducts[index]);
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(Icons.remove),
                                                ),
                                                Text(cartProductCount[index].toString()),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      cartProductCount[index] += 1;
                                                    });
                                                  },
                                                  icon: Icon(Icons.add),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      for (int i = 0; i < cartProducts.length; i++) {
                                        addOrderModel.add(
                                          OrderRequestModel(
                                            userId: LocaleDatabaseHelper.i.currentUserId,
                                            products: [
                                              OrderProductModel(
                                                productId: cartProducts[i].productId,
                                                count: cartProductCount[i],
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      for (var element in addOrderModel) {
                                        print("SİPARİŞŞŞ USER ID: ${element.userId}");
                                        print("SİPARİŞŞŞ DETAY: ${element.products?.first.count}");
                                      }
                                    },
                                    child: const Text("Sipariş Ver"),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 2 / 2,
                                  crossAxisSpacing: 40,
                                  mainAxisSpacing: 40,
                                ),
                                itemCount: allProducts.length,
                                itemBuilder: (BuildContext context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Image.asset('assets/${allProducts[index].productUrl}.png'),
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            title: Text(allProducts[index].productName ?? ""),
                                            subtitle: Text(allProducts[index].productDesc ?? ""),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("${allProducts[index].productPrice}₺", style: Theme.of(context).textTheme.headline6),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    shoppingCartBloc?.add(ShoppingCartAddEvent(allProducts[index]));
                                                  },
                                                  child: const Icon(Icons.add),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: const Border(
                            top: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextButton(
                                  style: ButtonStyle(backgroundColor: (screenIndex == 0) ? MaterialStateProperty.all(Colors.green) : null),
                                  onPressed: () {
                                    setState(() {
                                      screenIndex = 0;
                                    });
                                  },
                                  child: Icon(Icons.home, color: (screenIndex == 0) ? Colors.white : null),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextButton(
                                  style: ButtonStyle(backgroundColor: (screenIndex == 1) ? MaterialStateProperty.all(Colors.green) : null),
                                  onPressed: () {
                                    setState(() {
                                      screenIndex = 1;
                                    });
                                  },
                                  child: Badge(
                                    badgeContent: Text(
                                      cartProducts.length.toString(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    badgeColor: Colors.green,
                                    child: Icon(Icons.shopping_cart, color: (screenIndex == 1) ? Colors.white : null),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}


/*
classicButton(
              text: "Çık",
              customOnPressed: () async {
                await LocaleDatabaseHelper.i.userSessionClear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Login(),
                  ),
                );
              })

 */