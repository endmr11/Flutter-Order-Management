class TempStorage {
  TempStorage._();
  static final TempStorage _instance = TempStorage._();
  static TempStorage get i => _instance;
}
