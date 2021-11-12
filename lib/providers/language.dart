import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class   LanguageProvider extends ChangeNotifier {
  Locale    _appLocale = Locale('en');

  LanguageProvider() {
    fetchLocale().then(
      (localLocal) {
        _appLocale = localLocal;
      }
    ).timeout(
      Duration(seconds: 2),
      onTimeout: () {
        _appLocale = Locale('en');
      }
    );
  }

  Locale get    appLocale => _appLocale ?? Locale('en');

  fetchLocale() async {
    var       prefs = await SharedPreferences.getInstance();
    String    languageCode = prefs.getString('language_code');
    if (languageCode == null)
      return Locale('en');
    else
      return Locale(languageCode);
  }

  void      changeLanguage(Locale type) async {
    var   prefs = await SharedPreferences.getInstance();
    if (_appLocale != type) {
      if (type == Locale('fr')) {
        _appLocale = Locale('fr');
        prefs.setString('language_code', 'fr');
      }
      else if (type == Locale('ar')) {
        _appLocale = Locale('ar');
        prefs.setString('language_code', 'ar');
      }
      else {
        _appLocale = Locale('en');
        prefs.setString('language_code', 'en');
      }
      notifyListeners();
    }
  }

}