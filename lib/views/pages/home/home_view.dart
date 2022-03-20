import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';
import 'package:flutter_order_management/views/components/buttons/classic_button.dart';
import 'package:flutter_order_management/views/pages/login/login.dart';

import 'bloc/home_bloc.dart';
import 'home_view_model.dart';

class HomeView extends HomeViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
        ],
        child: BlocListener<HomeBloc, HomeState>(
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
          child: isLoading ?? true
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Hoşgeldiniz", style: Theme.of(context).textTheme.headline4),
                      Expanded(
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
                                          ElevatedButton(onPressed: () {}, child: const Icon(Icons.add))
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