import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_order_management/views/pages/home/home.dart';
import 'package:flutter_order_management/views/pages/login/login.dart';

import 'app_observer.dart';
import 'core/services/temp_storage.dart';
import 'data/sources/database/local_database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleDatabaseHelper.i.initLocalDatabase();
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
  String? locale;
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: isLight! ? ThemeData.light() : ThemeData.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(locale ?? 'tr'),
      home: LocaleDatabaseHelper.i.isLoggedIn != null
          ? LocaleDatabaseHelper.i.isLoggedIn!
              ? const Home()
              : const Login()
          : const Login(),
    );
  }
}


/*


 return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: state,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: LocaleDatabaseHelper.i.isLoggedIn != null
                ? LocaleDatabaseHelper.i.isLoggedIn!
                    ? const Home()
                    : const Login()
                : const Login(),
          );
        },
      ),
    );

 */
