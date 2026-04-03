import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_enums.dart';
import '../../core/themes/app_theme.dart';
import '../../presentation/utils/custom_print.dart';

part 'app_theme_state.dart';

class AppThemeCubit extends Cubit<AppThemeState> {
  AppThemeCubit() : super(AppThemeState.initialize());
  CustomPrint customPrint = CustomPrint();

  Future<Color> getColor({required AppColors color}) async {
    switch (color) {
      case AppColors.backgroundColor:
        return state.themeClass.backgroundColor;
      case AppColors.formFieldBackgroundColor:
        return state.themeClass.formFieldBackgroundColor;
      case AppColors.enabledFormFieldBorderColor:
        return state.themeClass.enabledFormFieldBorderColor;
      case AppColors.focusedFormFieldBorderColor:
        return state.themeClass.focusedFormFieldBorderColor;
      case AppColors.appbarBackgroundColor:
        return state.themeClass.appbarBackgroundColor;
      case AppColors.primaryColor:
        return state.themeClass.primaryColor;
      case AppColors.secondaryColor:
        return state.themeClass.secondaryColor;
      case AppColors.successColor:
        return state.themeClass.successColor;
      case AppColors.dangerColor:
        return state.themeClass.dangerColor;
      case AppColors.infoColor:
        return state.themeClass.infoColor;
      case AppColors.warningColor:
        return state.themeClass.warningColor;
      case AppColors.textColor_1:
        return state.themeClass.textColor_1;
      case AppColors.textColor_2:
        return state.themeClass.textColor_2;
      case AppColors.textCaptionColor:
        return state.themeClass.textCaptionColor;
      case AppColors.buttonBackgroundColor:
        return state.themeClass.buttonBackgroundColor;
      case AppColors.buttonBackgroundColor2:
        return state.themeClass.buttonBackgroundColor2;
      case AppColors.white:
        return state.themeClass.white;
      case AppColors.black:
        return state.themeClass.black;
      case AppColors.cardBackgroundColor:
        return state.themeClass.cardBackgroundColor;
      case AppColors.cardBorderColor:
        return state.themeClass.cardBorderColor;
      default:
        return Colors.transparent;
    }
  }

  Future<String> getThemeType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String themeValue = prefs.getString('themeType') ?? 'auto';
    return themeValue;
  }

  Future<void> setThemeType(String themeValue) async {
    customPrint.print(message: themeValue);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeType', themeValue);
  }

  void setLightTheme(String themeSetting) {
    String temp = '';
    if (themeSetting == 'light') {
      temp = 'Light mode only activated';
    } else if (themeSetting == 'dark') {
      temp = 'Dark mode only activated';
    } else {
      temp = 'Auto Switching activated';
    }
    LightTheme lightTheme = LightTheme();
    customPrint.print(message: temp);
    customPrint.print(message: 'Light mode');

    emit(
      state.copyWith(
        brightness: Brightness.light,
        themeClass: lightTheme,
        themeSetting: temp,
      ),
    );
  }

  void setDarkTheme(String themeSetting) {
    String temp = '';
    if (themeSetting == 'light') {
      temp = 'Light mode only activated';
    } else if (themeSetting == 'dark') {
      temp = 'Dark mode only activated';
    } else {
      temp = 'Auto Switching activated';
    }
    DarkTheme darkTheme = DarkTheme();
    customPrint.print(message: temp);
    customPrint.print(message: 'Dark mode');

    emit(
      state.copyWith(
        brightness: Brightness.dark,
        themeClass: darkTheme,
        themeSetting: temp,
      ),
    );
  }

  Future<void> checkTheme() async {
    final Brightness currentBrightness =
        SchedulerBinding.instance.window.platformBrightness;
    String userTheme = await getThemeType();
    customPrint.print(message: 'User theme $userTheme');
    if (userTheme == 'light') {
      setLightTheme(userTheme);
    } else if (userTheme == 'dark') {
      setDarkTheme(userTheme);
    } else {
      customPrint.print(message: 'Initial brightness $currentBrightness');
      if (currentBrightness == Brightness.light) {
        setLightTheme(userTheme);
      } else {
        setDarkTheme(userTheme);
      }
    }
  }
}
