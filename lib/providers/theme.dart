import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mybeautyadvisor/tools/sharedPreference.dart';




class ThemeProvider with ChangeNotifier {
  ThemeMode _mode;
  ThemeMode get mode => _mode;
  
  ThemeProvider() {
    ThemePreferences().getTheme().then(
      (mode) {
        if (mode != null)
          _mode = mode;
        else {
          var brightness = SchedulerBinding.instance.window.platformBrightness;
          _mode = (brightness == Brightness.dark) ?
            ThemeMode.dark :
            ThemeMode.light;
        }
        notifyListeners();
      }
    ).timeout(
      Duration(seconds: 2),
      onTimeout: () {
        _mode =ThemeMode.light;
      }
    );
  }


  toggleMode() async {
    SharedPreferences   space = await SharedPreferences.getInstance();
  
    // Set Light Mode
    if (_mode == ThemeMode.light) {
      _mode = ThemeMode.dark;
      space.setString('theme', 'dark');
    }
    // Set Dark Mode
    else {
      _mode = ThemeMode.light;
      space.setString('theme', 'light');
    }
    notifyListeners();
  }

  void      setLightMode() {  
    _mode = ThemeMode.light;
    notifyListeners();
  
  }

  void      setDarkMode() {
    _mode = ThemeMode.dark;
    notifyListeners();
  }

}