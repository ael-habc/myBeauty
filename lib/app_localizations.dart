import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';


class   AppLocalizations {
  final   Locale  locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concose
  // Localizations are accessed using an InheritedWidget "of" syntax
  static  AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static member to have a simple access to the delegate from MaterialApp
  static const    LocalizationsDelegate<AppLocalizations>   delegate = _AppLocalizationsDelegate();

  Map<String, String>   _localizedStrings;

  Future      load() async {
    // Load the JSON file from i18n folder
    String                jsonString = await rootBundle.loadString('i18n/${locale.languageCode}.json');
    Map<String, dynamic>  jsonMap = json.decode(jsonString);
  
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  // Method called from widgets that need a localized text
  String      translate(String key) => _localizedStrings[key];

}


// Localizations Delegate is a factory for a set of localized ressources
// In this case the localized strings will be gotten in an AppLocalization object

class   _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change
  const   _AppLocalizationsDelegate();

  @override
  bool    isSupported(Locale locale) => ['en', 'fr', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations>    load(Locale locale) async {
    AppLocalizations    localizations = new AppLocalizations(locale);

    await localizations.load();
    return localizations;
  }

  @override
  bool    shouldReload(_AppLocalizationsDelegate old) => false;
}
