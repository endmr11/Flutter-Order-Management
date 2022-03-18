import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../theme_data.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(ThemeCustomData.lightTheme);

  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? ThemeCustomData.lightTheme : ThemeCustomData.darkTheme);
  }
}
