

import 'package:car_shop/storage/storage_helper.dart';
import 'package:flutter/material.dart';

class ThemeHelper {
  static ThemeMode _themeMode = ThemeMode.light;
  static ThemeMode get themeMode => _themeMode;

  static void setTheme(ThemeMode themeMode){
     _themeMode = themeMode;
  }
  static ThemeMode getTheme(){
    if(StorageHelper.getMode()){
        print("DarkMode");
       _themeMode = ThemeMode.dark;
    }  else {
        print("LightMode");
       _themeMode = ThemeMode.light;
    }
    return _themeMode;
  }
}
