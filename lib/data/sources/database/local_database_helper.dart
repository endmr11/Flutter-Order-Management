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
  int? get currentUserType => _prefs?.getInt(LocaleDatabaseConstants.getUserTypeKey);
  bool? get isLight => _prefs?.getBool(LocaleDatabaseConstants.getUserThemeKey);
  String? get currentUserLang => _prefs?.getString(LocaleDatabaseConstants.getUserLangKey);

  void setCurrentUserEmail(String? userEmail) {
    if (userEmail != null) {
      _prefs?.setString(LocaleDatabaseConstants.getUserEmailKey, userEmail);
    }
  }

  void setCurrentUserLoggedIn(bool? loggedIn) {
    if (loggedIn != null) {
      _prefs?.setBool(LocaleDatabaseConstants.getUserLoggedInKey, loggedIn);
    }
  }

  void setCurrentUserId(int? userId) {
    if (userId != null) {
      _prefs?.setInt(LocaleDatabaseConstants.getUserIdKey, userId);
    }
  }

  void setCurrentUserName(String? userName) {
    if (userName != null) {
      _prefs?.setString(LocaleDatabaseConstants.getUserNameKey, userName);
    }
  }

  void setCurrentUserSurname(String? userSurname) {
    if (userSurname != null) {
      _prefs?.setString(LocaleDatabaseConstants.getUserSurnameKey, userSurname);
    }
  }

  void setCurrentUserToken(String? token) {
    if (token != null) {
      _prefs?.setString(LocaleDatabaseConstants.getUserTokenKey, token);
    }
  }

  void setCurrentUserType(int? userType) {
    if (userType != null) {
      _prefs?.setInt(LocaleDatabaseConstants.getUserTypeKey, userType);
    }
  }

  void setCurrentUserTheme(bool? isLight) {
    if (isLight != null) {
      _prefs?.setBool(LocaleDatabaseConstants.getUserThemeKey, isLight);
    }
  }

  void setCurrentUserLang(String? lang) {
    if (lang != null) {
      _prefs?.setString(LocaleDatabaseConstants.getUserLangKey, lang);
    }
  }

  Future<void> userSessionClear() async {
    //await _prefs?.clear();
    await _prefs?.remove(LocaleDatabaseConstants.getUserEmailKey);
    await _prefs?.remove(LocaleDatabaseConstants.getUserIdKey);
    await _prefs?.remove(LocaleDatabaseConstants.getUserLoggedInKey);
    await _prefs?.remove(LocaleDatabaseConstants.getUserNameKey);
    await _prefs?.remove(LocaleDatabaseConstants.getUserSurnameKey);
    await _prefs?.remove(LocaleDatabaseConstants.getUserTokenKey);
    await _prefs?.remove(LocaleDatabaseConstants.getUserTypeKey);
  }
}
