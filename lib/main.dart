import 'dart:async';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_order_management/core/env/env_config.dart';
import 'package:flutter_order_management/core/global/socket/socket_config.dart';
import 'package:flutter_order_management/data/sources/api/api_service.dart';
import 'package:flutter_order_management/views/pages/home/home.dart';
import 'package:flutter_order_management/views/pages/login/login.dart';
import 'package:flutter_order_management/views/pages/order_management/order_management.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketio;

import 'app_observer.dart';
import 'core/global/global_blocs/main_bloc/main_bloc.dart';
import 'core/router/router.dart';
import 'data/sources/database/local_database_helper.dart';
import 'views/pages/my_orders/my_orders_bloc/my_orders_bloc.dart';
import 'views/pages/order_management/order_management_bloc/order_management_bloc.dart';
import 'views/widgets/dialog_managers/dialog_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleDatabaseHelper.i.initLocalDatabase();
  BlocOverrides.runZoned(
    () => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => MainBloc(),
          ),
          BlocProvider(
            create: (BuildContext context) => MyOrdersBloc(APIService()),
          ),
          BlocProvider(
            create: (BuildContext context) => OrderManagementBloc(APIService()),
          )
        ],
        child: const MyApp(),
      ),
    ),
    blocObserver: MyAppObserver(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<String>? langStreamSubs;
  ISocketConfig socketConfig = SocketConfig(socketio.io(EnvConfig.socketApiURL, <String, dynamic>{
    'transports': ['websocket'],
  }));
  @override
  void initState() {
    try {
      tryInitSocket();
    } catch (e) {
      DialogManager.i.showClassicAlertDialog(
        context: context,
        title: "Hata",
        content: [Text(e.toString())],
        actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Ok"))],
      );
    }
    super.initState();
  }

  Future<void> tryInitSocket() async {
    MyOrdersBloc myOrdersBloc = context.read<MyOrdersBloc>();
    OrderManagementBloc orderManagementBloc = context.read<OrderManagementBloc>();
    await socketConfig.initSocket(myOrdersBloc, orderManagementBloc);
  }

  @override
  void dispose() {
    socketConfig.closeSocket();
    context.read<MyOrdersBloc>().close();
    context.read<MainBloc>().close();
    context.read<OrderManagementBloc>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: context.watch<MainBloc>(),
      builder: (context, state) {
        if (state is ThemeChangeState) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            themeMode: state.isLight ? ThemeMode.light : ThemeMode.dark,
            theme: FlexColorScheme.light(scheme: FlexScheme.green).toTheme,
            darkTheme: FlexColorScheme.dark(scheme: FlexScheme.green).toTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(state.locale),
            onGenerateRoute: (settings) => generateRoute(settings),
            home: LocaleDatabaseHelper.i.isLoggedIn != null
                ? LocaleDatabaseHelper.i.isLoggedIn!
                    ? LocaleDatabaseHelper.i.currentUserType == 0
                        ? const Home()
                        : const OrderManagement()
                    : const Login()
                : const Login(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
