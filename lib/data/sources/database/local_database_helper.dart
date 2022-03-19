import 'package:flutter_order_management/core/utils/constants/database_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleDatabaseHelper {
  LocaleDatabaseHelper._();
  static final LocaleDatabaseHelper _instance = LocaleDatabaseHelper._();
  static LocaleDatabaseHelper get i => _instance;
  static SharedPreferences? _prefs;

  Future<void> initLocalDatabase() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? get currentUserEmail => _prefs?.getString(LocaleDatabaseConstants.getUserEmailKey);
  bool? get isLoggedIn => _prefs?.getBool(LocaleDatabaseConstants.getUserLoggedInKey);
  int? get currentUserId => _prefs?.getInt(LocaleDatabaseConstants.getUserIdKey);
  String? get currentUserName => _prefs?.getString(LocaleDatabaseConstants.getUserNameKey);
  String? get currentUserSurname => _prefs?.getString(LocaleDatabaseConstants.getUserSurnameKey);
  String? get currentUserToken => _prefs?.getString(LocaleDatabaseConstants.getUserTokenKey);
  int? get currentUserGroup => _prefs?.getInt(LocaleDatabaseConstants.getUserGroupKey);
  bool? get isLight => _prefs?.getBool(LocaleDatabaseConstants.getUserThemeKey);

  void setCurrentUserEmail(String userEmail) {
    _prefs?.setString(LocaleDatabaseConstants.getUserEmailKey, userEmail);
  }

  void setCurrentUserLoggedIn(bool loggedIn) {
    _prefs?.setBool(LocaleDatabaseConstants.getUserLoggedInKey, loggedIn);
  }

  void setCurrentUserId(int userId) {
    _prefs?.setInt(LocaleDatabaseConstants.getUserNameKey, userId);
  }

  void setCurrentUserName(String userName) {
    _prefs?.setString(LocaleDatabaseConstants.getUserNameKey, userName);
  }

  void setCurrentUserSurname(String userSurname) {
    _prefs?.setString(LocaleDatabaseConstants.getUserSurnameKey, userSurname);
  }

  void setCurrentUserToken(String token) {
    _prefs?.setString(LocaleDatabaseConstants.getUserTokenKey, token);
  }

  void setCurrentUserGroup(int userGroup) {
    _prefs?.setInt(LocaleDatabaseConstants.getUserGroupKey, userGroup);
  }

  void setCurrentUserTheme(bool isLight) {
    _prefs?.setBool(LocaleDatabaseConstants.getUserThemeKey, isLight);
  }
}
