class LocaleDatabaseConstants {
  LocaleDatabaseConstants._();
  static final LocaleDatabaseConstants _instance = LocaleDatabaseConstants._();
  static LocaleDatabaseConstants get i => _instance;
  static String userEmailKey = 'CURRENTEMAIL';
  static String userLoggedInKey = 'LOGGEDIN';
  static String userIdKey = 'CURRENTID';
  static String userNameKey = 'CURRENTNAME';
  static String userSurnameKey = 'CURRENTSURNAME';
  static String userTokenKey = 'CURRENTTOKEN';
  static String userTypeKey = 'CURRENTGROUP';
  static String userThemeKey = 'CURRENTTHEME';
  static String userLangKey = 'CURRENTLANG';

  static String get getUserEmailKey => userEmailKey;
  static String get getUserLoggedInKey => userLoggedInKey;
  static String get getUserIdKey => userIdKey;
  static String get getUserNameKey => userNameKey;
  static String get getUserSurnameKey => userSurnameKey;
  static String get getUserTokenKey => userTokenKey;
  static String get getUserTypeKey => userTypeKey;
  static String get getUserThemeKey => userThemeKey;
  static String get getUserLangKey => userLangKey;
}
