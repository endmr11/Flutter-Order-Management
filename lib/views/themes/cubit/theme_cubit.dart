import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';

import '../theme_data.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit()
      : super(LocaleDatabaseHelper.i.isLight != null
            ? LocaleDatabaseHelper.i.isLight!
                ? ThemeCustomData.lightTheme
                : ThemeCustomData.darkTheme
            : ThemeCustomData.lightTheme);

  void toggleTheme() {
    LocaleDatabaseHelper.i.setCurrentUserTheme(state.brightness == Brightness.dark);
    emit(state.brightness == Brightness.dark ? ThemeCustomData.lightTheme : ThemeCustomData.darkTheme);
  }
}
