import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        title: Text(AppLocalizations.of(context)!.appTitle),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
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
                    cartProducts.clear();
                    screenIndex = 0;
                  });
                } else if (state is ShoppingCartOrderError) {
                  Navigator.pop(context);
                  showErrorDialog();
                }
              },
            ),
          ],
          child: isLoading ?? true
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Icon(Icons.shopping_cart, size: 40, color: Colors.green),
                      screenIndex != 0
                          ? Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: cartProducts.isEmpty
                                        ? Text(
                                            "Sepetinizde ürün bulunmamaktadır.",
                                            style: Theme.of(context).textTheme.headline6,
                                          )
                                        : ListView.builder(
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
                                                        icon: const Icon(Icons.remove),
                                                      ),
                                                      Text(cartProductCount[index].toString()),
                                                      IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            cartProductCount[index] += 1;
                                                          });
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
                                    onPressed: cartProducts.isEmpty
                                        ? null
                                        : () {
                                            for (int i = 0; i < cartProducts.length; i++) {
                                              productList.add(OrderProductModel(
                                                count: cartProductCount[i],
                                                productId: cartProducts[i].productId,
                                              ));
                                            }
                                            shoppingCartBloc?.add(ShoppingCartAddOrder(OrderRequestModel(
                                              userId: LocaleDatabaseHelper.i.currentUserId,
                                              products: productList,
                                              userName: LocaleDatabaseHelper.i.currentUserName,
                                              userSurname: LocaleDatabaseHelper.i.currentUserSurname,
                                              orderStatus: 0,
                                            )));
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

  void showErrorDialog() {
    DialogManager.i.showClassicAlertDialog(
      context: context,
      content: [const Text("Hatalı Bilgi Girdiniz")],
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
            onPressed: () async {},
            child: const Text("Siparişlerim"),
          ),
          TextButton(
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
          ),
        ],
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