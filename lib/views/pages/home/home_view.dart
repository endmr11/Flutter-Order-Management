import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_order_management/data/models/order_models/order_request_model.dart';
import 'package:flutter_order_management/data/sources/api/api_service.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';
import 'package:flutter_order_management/views/components/buttons/classic_button.dart';
import 'package:flutter_order_management/views/pages/login/login.dart';
import 'package:flutter_order_management/views/pages/my_orders/my_orders.dart';

import '../../widgets/dialog_managers/dialog_manager.dart';
import 'home_bloc/home_bloc.dart';
import 'home_view_model.dart';
import 'shopping_cart_bloc/bloc/shopping_cart_bloc.dart';

class HomeView extends HomeViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => homeBloc ?? HomeBloc(APIService()),
          ),
          BlocProvider(
            create: (context) => shoppingCartBloc ?? ShoppingCartBloc(APIService()),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<HomeBloc, HomeState>(
              bloc: homeBloc,
              listener: (context, state) {
                if (state is HomeProcessError) {
                  DialogManager.i.showClassicAlertDialog(
                    context: context,
                    title: "Hata",
                    content: [Text(state.error)],
                    actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Ok"))],
                  );
                }
              },
            ),
            BlocListener<ShoppingCartBloc, ShoppingCartState>(
              bloc: shoppingCartBloc,
              listener: (context, state) {
                if (state is ShoppingCartAddedState) {
                  if (!state.isAdded) {
                    DialogManager.i.showClassicAlertDialog(
                      context: context,
                      title: "Uyarı",
                      content: [const Text("Ürün zaten ekli. Sepetten ürünü çoğaltabilirsiniz!")],
                      actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Ok"))],
                    );
                  }
                } else if (state is ShoppingCartOrderLoading) {
                  showLoadingDialog();
                } else if (state is ShoppingCartOrderSuccesful) {
                  Navigator.pop(context);
                  showSuccessfulDialog();
                  setState(() {
                    screenIndex = 0;
                    productList.clear();
                    productList = [];
                  });
                } else if (state is ShoppingCartOrderError) {
                  Navigator.pop(context);
                  showErrorDialog(state.error);
                }
              },
            ),
          ],
          child: BlocBuilder(
            bloc: homeBloc,
            builder: (context, state) {
              if (state is HomeProcessLoading) {
                return const Center(child: CircularProgressIndicator.adaptive());
              } else if (state is HomeProcessSuccesful) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Icon(Icons.shopping_cart, size: 40, color: Colors.green),
                      if (screenIndex != 0)
                        BlocBuilder(
                          bloc: shoppingCartBloc,
                          builder: (context, state) {
                            if (state is ShoppingCartLoadedState) {
                              return Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: state.cartProducts.isEmpty
                                          ? Text(
                                              "Sepetinizde ürün bulunmamaktadır.",
                                              style: Theme.of(context).textTheme.headline6,
                                            )
                                          : ListView.builder(
                                              itemCount: state.cartProducts.length,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: ListTile(
                                                        leading: CircleAvatar(
                                                          backgroundColor: Colors.transparent,
                                                          child: Image.asset('assets/${state.cartProducts[index].productUrl}.png'),
                                                        ),
                                                        title: Text("${state.cartProducts[index].productName} ${state.cartProducts[index].productPrice}"),
                                                        subtitle: Text(state.cartProducts[index].productDesc ?? ""),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            if (state.cartProductCount[index] != 1) {
                                                              shoppingCartBloc?.add(ShoppingProductCountDecreaseEvent(index));
                                                            } else {
                                                              shoppingCartBloc?.add(ShoppingCartRemoveEvent(state.cartProducts[index]));
                                                            }
                                                          },
                                                          icon: const Icon(Icons.remove),
                                                        ),
                                                        Text(state.cartProductCount[index].toString()),
                                                        IconButton(
                                                          onPressed: () {
                                                            shoppingCartBloc?.add(ShoppingProductCountIcrementEvent(index));
                                                          },
                                                          icon: const Icon(Icons.add),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                    ),
                                    ElevatedButton(
                                      onPressed: state.cartProducts.isEmpty
                                          ? null
                                          : () {
                                              for (int i = 0; i < state.cartProducts.length; i++) {
                                                productList.add(OrderProductModel(
                                                  count: state.cartProductCount[i],
                                                  productId: state.cartProducts[i].productId,
                                                ));
                                              }
                                              shoppingCartBloc?.add(
                                                ShoppingCartAddOrder(
                                                  OrderRequestModel(
                                                    userId: LocaleDatabaseHelper.i.currentUserId,
                                                    products: productList,
                                                    userName: LocaleDatabaseHelper.i.currentUserName,
                                                    userSurname: LocaleDatabaseHelper.i.currentUserSurname,
                                                    orderStatus: 0,
                                                  ),
                                                ),
                                              );
                                            },
                                      child: const Text("Sipariş Ver"),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Text(
                                "Sepetinizde ürün bulunmamaktadır.",
                                style: Theme.of(context).textTheme.headline6,
                              );
                            }
                          },
                        )
                      else
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 2 / 2,
                              crossAxisSpacing: 40,
                              mainAxisSpacing: 40,
                            ),
                            itemCount: state.allProducts.length,
                            itemBuilder: (BuildContext context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image.asset('assets/${state.allProducts[index].productUrl}.png'),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Text(state.allProducts[index].productName ?? ""),
                                        subtitle: Text(state.allProducts[index].productDesc ?? ""),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("${state.allProducts[index].productPrice}₺", style: Theme.of(context).textTheme.headline6),
                                            ElevatedButton(
                                              onPressed: () {
                                                shoppingCartBloc?.add(ShoppingCartAddEvent(state.allProducts[index]));
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
                                  child: BlocBuilder(
                                    bloc: shoppingCartBloc,
                                    builder: (context, state) {
                                      if (state is ShoppingCartLoadedState) {
                                        return Badge(
                                          badgeContent: Text(
                                            state.cartProductCount.length.toString(),
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          badgeColor: Colors.green,
                                          child: Icon(Icons.shopping_cart, color: (screenIndex == 1) ? Colors.white : null),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text("Error"),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void showSuccessfulDialog() {
    DialogManager.i.showClassicAlertDialog(
        context: context,
        title: "Başarılı",
        content: [const Text("Sipariş başarılı bir şekilde oluşturuldu.")],
        actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Tamam"))]);
  }

  void showLoadingDialog() {
    DialogManager.i.showLoadingAlertDialog(context: context);
  }

  void showErrorDialog(String error) {
    DialogManager.i.showClassicAlertDialog(
      context: context,
      content: [Text(error)],
      title: "Hata",
      actions: [
        classicButton(
          text: "Tamam",
          customOnPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const CircleAvatar(
            child: Icon(Icons.person),
          ),
          TextButton(
            onPressed: () async {
              Scaffold.of(context).openEndDrawer();
              Navigator.pushNamed(context, MyOrders.routeName);
            },
            child: const Text("Siparişlerim"),
          ),
          TextButton(
            onPressed: () async {
              await LocaleDatabaseHelper.i.userSessionClear();
              Navigator.pushReplacementNamed(context, Login.routeName);
            },
            child: const Text("Çık"),
          ),
        ],
      ),
    );
  }
}
