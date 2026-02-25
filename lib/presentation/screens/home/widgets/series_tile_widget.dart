import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../logics/cubits/app_theme_cubit.dart';

UiUtilityPackage uiUtilityPackage = UiUtilityPackage();
Widget seriesTileWidget({
  required int index,
  required Function() onTap,
  required Function() onDoubleTap,
}) {
  return StatefulBuilder(
    builder: (context, setThisState) {
      return BlocBuilder<AppThemeCubit, AppThemeState>(
        builder: (context, appThemeState) {
          return uiUtilityPackage.customCard(
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            color: appThemeState.themeClass.cardBackgroundColor,
            widget: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      appThemeState.themeClass.appbarBackgroundColor,
                  child: uiUtilityPackage.customText(
                    text: '${index + 1}',
                    fontSize: TextSize.medium,
                    overrideColor: appThemeState.themeClass.textColor_1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    uiUtilityPackage.customText(
                      text: 'Series ${index + 1}',
                      fontSize: TextSize.title,
                      overrideColor: appThemeState.themeClass.white,
                      fontWeight: FontWeight.bold,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        uiUtilityPackage.customText(
                          text: 'ID: series_${index + 1}',
                          fontSize: TextSize.normal,
                          overrideColor: appThemeState.themeClass.white,
                        ),
                        uiUtilityPackage.customText(
                          text: 'Date: 2026-02-20',
                          fontSize: TextSize.normal,
                          overrideColor: appThemeState.themeClass.white,
                        ),
                        uiUtilityPackage.customText(
                          text: 'Players: ABC, MNO, XYZ',
                          fontSize: TextSize.normal,
                          overrideColor: appThemeState.themeClass.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
