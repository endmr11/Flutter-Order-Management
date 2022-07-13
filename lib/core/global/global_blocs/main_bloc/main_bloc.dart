import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  static bool isLight = LocaleDatabaseHelper.i.isLight ?? true;
  static String locale = LocaleDatabaseHelper.i.currentUserLang ?? Platform.localeName.substring(0, 2);
  MainBloc() : super(ThemeChangeState(isLight, locale)) {
    on(themeEventControl);
  }

  Future<void> themeEventControl(MainEvent event, Emitter<MainState> emit) async {
    if (event is ThemeChangeEvent) {
      isLight = !isLight;
      LocaleDatabaseHelper.i.setCurrentUserTheme(isLight);
      emit(ThemeChangeState(isLight, locale));
    } else if (event is LanguageChangeEvent) {
      LocaleDatabaseHelper.i.setCurrentUserLang(event.value!);
      emit(ThemeChangeState(isLight, event.value!));
    }
  }
}
