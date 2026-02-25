import 'package:flutter/material.dart';

class AppTheme {
  ///main
  late Color backgroundColor;
  late Color formFieldBackgroundColor;
  late Color enabledFormFieldBorderColor;
  late Color focusedFormFieldBorderColor;
  late Color appbarBackgroundColor;
  late Color primaryColor;
  late Color secondaryColor;

  ///selections
  late Color successColor;
  late Color dangerColor;
  late Color infoColor;
  late Color warningColor;

  ///texts
  late Color textColor_1;
  late Color textColor_2;
  late Color textCaptionColor;

  ///button
  late Color buttonBackgroundColor;
  late Color buttonBackgroundColor2;

  ///constant colors
  late Color white;
  late Color black;

  ///card colors
  late Color cardBackgroundColor;
  late Color cardBackgroundColorSecondary;
  late Color cardBorderColor;
}

class LightTheme extends AppTheme {
  LightTheme();

  ///main
  @override
  Color get backgroundColor => const Color(0xffffffff);

  @override
  Color get formFieldBackgroundColor => const Color(0xffffffff);

  @override
  Color get enabledFormFieldBorderColor => const Color(0xff000000);

  @override
  Color get focusedFormFieldBorderColor => const Color(0xffffffff);

  @override
  Color get appbarBackgroundColor => const Color(0xff719bf1);

  @override
  Color get primaryColor => const Color(0xff719bf1);

  @override
  Color get secondaryColor => const Color(0xffffffff);

  ///selections
  @override
  Color get successColor => const Color(0xff2ee719);

  @override
  Color get dangerColor => const Color(0xfff60f0f);

  @override
  Color get infoColor => const Color(0xff719bf1);

  @override
  Color get warningColor => const Color(0xffffd719);

  ///texts
  @override
  Color get textColor_1 => const Color(0xff000000);

  @override
  Color get textColor_2 => const Color(0xffffffff);

  @override
  Color get textCaptionColor => const Color(0xff848484);

  ///button
  @override
  Color get buttonBackgroundColor => const Color(0xff5789ee);

  @override
  Color get buttonBackgroundColor2 => const Color(0xffffffff);

  ///constant colors
  @override
  Color get white => const Color(0xffffffff);
  @override
  Color get black => const Color(0xff000000);

  ///card colors
  @override
  Color get cardBackgroundColor => const Color(0xff464d5e);
  @override
  Color get cardBackgroundColorSecondary => const Color(0xff5c6473);
  @override
  Color get cardBorderColor => const Color(0xff000000);
}

class DarkTheme extends AppTheme {
  DarkTheme();

  ///main
  @override
  Color get backgroundColor => const Color(0xff000000);

  @override
  Color get formFieldBackgroundColor => const Color(0xff000000);

  @override
  Color get enabledFormFieldBorderColor => const Color(0xffffffff);

  @override
  Color get focusedFormFieldBorderColor => const Color(0xff000000);

  @override
  Color get appbarBackgroundColor => const Color(0xff07274d);

  @override
  Color get primaryColor => const Color(0xff07274d);

  @override
  Color get secondaryColor => const Color(0xff000000);

  ///selections
  @override
  Color get successColor => const Color(0xff1a6513);

  @override
  Color get dangerColor => const Color(0xff8f1818);

  @override
  Color get infoColor => const Color(0xff07274d);

  @override
  Color get warningColor => const Color(0xffa95801);

  ///texts
  @override
  Color get textColor_1 => const Color(0xffffffff);

  @override
  Color get textColor_2 => const Color(0xff000000);

  @override
  Color get textCaptionColor => const Color(0xffb49f9f);

  ///button
  @override
  Color get buttonBackgroundColor => const Color(0xff07274d);

  @override
  Color get buttonBackgroundColor2 => const Color(0xff000000);

  ///constant colors
  @override
  Color get white => const Color(0xffffffff);
  @override
  Color get black => const Color(0xff000000);

  ///card colors
  @override
  Color get cardBackgroundColor => const Color(0xff354169);
  @override
  Color get cardBackgroundColorSecondary => const Color(0xff434f73);
  @override
  Color get cardBorderColor => const Color(0xffffffff);
}
