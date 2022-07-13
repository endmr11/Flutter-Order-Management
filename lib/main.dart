import 'dart:async';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_order_management/core/global/socket/socket_config.dart';
import 'package:flutter_order_management/views/pages/login/login.dart';
import 'package:flutter_order_management/views/pages/page_management/page_management.dart';

import 'app_observer.dart';
import 'core/global/global_blocs/main_bloc/main_bloc.dart';
import 'data/sources/database/local_database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleDatabaseHelper.i.initLocalDatabase();
  await SocketConfig.i.initSocket();
  BlocOverrides.runZoned(
    () => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => MainBloc(),
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SocketConfig.i.closeSocket();
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
            home: LocaleDatabaseHelper.i.isLoggedIn != null
                ? LocaleDatabaseHelper.i.isLoggedIn!
                    ? const PageManagement()
                    : Login(themeBloc: context.watch<MainBloc>())
                : Login(themeBloc: context.watch<MainBloc>()),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
