import 'dart:async';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_order_management/core/services/socket/socket_config.dart';
import 'package:flutter_order_management/views/pages/login/login.dart';
import 'package:flutter_order_management/views/pages/page_management/page_management.dart';
import 'package:universal_io/io.dart';

import 'app_observer.dart';
import 'core/services/temp_storage.dart';
import 'data/sources/database/local_database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleDatabaseHelper.i.initLocalDatabase();
  await SocketConfig.i.initSocket();
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: MyAppObserver(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isLight;
  String? locale = LocaleDatabaseHelper.i.currentUserLang ?? Platform.localeName.substring(0, 2);
  StreamSubscription<bool>? themeStreamSubs;
  StreamSubscription<String>? langStreamSubs;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLight = LocaleDatabaseHelper.i.isLight;
    });
    themeStreamSubs = TempStorage.themeStream.listen((event) {
      setState(() {
        isLight = event;
      });
    });
    langStreamSubs = TempStorage.langStream.listen((event) {
      setState(() {
        locale = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    themeStreamSubs?.cancel();
    langStreamSubs?.cancel();
    TempStorage.themeDataController.close();
    TempStorage.langDataController.close();
    SocketConfig.i.closeSocket();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: isLight == null
          ? ThemeMode.light
          : isLight!
              ? ThemeMode.light
              : ThemeMode.dark,
      theme: FlexColorScheme.light(scheme: FlexScheme.green).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: FlexScheme.green).toTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(locale ?? 'tr'),
      home: LocaleDatabaseHelper.i.isLoggedIn != null
          ? LocaleDatabaseHelper.i.isLoggedIn!
              ? const PageManagement()
              : const Login()
          : const Login(),
    );
  }
}
