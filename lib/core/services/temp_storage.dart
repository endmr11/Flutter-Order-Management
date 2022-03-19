import 'dart:async';

class TempStorage {
  TempStorage._();
  static final TempStorage _instance = TempStorage._();
  static TempStorage get i => _instance;

  static StreamController<bool> themeDataController = StreamController<bool>.broadcast();

  static Stream<bool> get themeStream => themeDataController.stream;

  static StreamController<String> langDataController = StreamController<String>.broadcast();

  static Stream<String> get langStream => langDataController.stream;
}
