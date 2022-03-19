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
  static String userGroupKey = 'CURRENTGROUP';
  static String userThemeKey = 'CURRENTTHEME';

  static String get getUserEmailKey => userEmailKey;
  static String get getUserLoggedInKey => userLoggedInKey;
  static String get getUserIdKey => userIdKey;
  static String get getUserNameKey => userNameKey;
  static String get getUserSurnameKey => userSurnameKey;
  static String get getUserTokenKey => userTokenKey;
  static String get getUserGroupKey => userGroupKey;
  static String get getUserThemeKey => userThemeKey;
}
