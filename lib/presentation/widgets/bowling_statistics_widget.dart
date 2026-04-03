import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../core/constants/app_strings.dart';
import '../../logics/cubits/app_theme_cubit.dart';

class BowlingStatisticsWidget extends StatelessWidget {
  BowlingStatisticsWidget({
    super.key,
    required this.player,
    required this.balls,
    required this.runs,
    required this.wickets,
    required this.noBalls,
    required this.wides,
    required this.economy,
    this.hideLabel = false,
    this.hideHeading = false,
    this.matchCard = false,
  });

  final UiUtilityPackage uiUtilityPackage = UiUtilityPackage();

  bool hideLabel, hideHeading, matchCard;
  String player, balls, runs, wickets, noBalls, wides, economy;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeState>(
      builder: (context, appThemeState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            hideLabel
                ? SizedBox.shrink()
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    hideHeading
                        ? SizedBox.shrink()
                        : uiUtilityPackage.customText(
                          text: AppStrings.bowler,
                          fontSize: TextSize.normal,
                          overrideColor:
                              appThemeState.themeClass.textCaptionColor,
                        ),
                    uiUtilityPackage.customText(
                      text: player,
                      fontSize: TextSize.medium,
                      overrideColor: appThemeState.themeClass.white,
                    ),
                  ],
                ),
            Row(
              children: [
                ///balls
                SizedBox(
                  width: matchCard ? 24 : 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      hideHeading
                          ? SizedBox.shrink()
                          : uiUtilityPackage.customText(
                            text: 'B',
                            fontSize: TextSize.normal,
                            overrideColor:
                                appThemeState.themeClass.textCaptionColor,
                          ),
                      uiUtilityPackage.customText(
                        text: balls,
                        fontSize: TextSize.medium,
                        overrideColor: appThemeState.themeClass.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),

                ///runs
                SizedBox(
                  width: matchCard ? 24 : 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      hideHeading
                          ? SizedBox.shrink()
                          : uiUtilityPackage.customText(
                            text: 'R',
                            fontSize: TextSize.normal,
                            overrideColor:
                                appThemeState.themeClass.textCaptionColor,
                          ),
                      uiUtilityPackage.customText(
                        text: runs,
                        fontSize: TextSize.medium,
                        overrideColor: appThemeState.themeClass.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),

                ///Wides
                SizedBox(
                  width: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      hideHeading
                          ? SizedBox.shrink()
                          : uiUtilityPackage.customText(
                            text: 'WD',
                            fontSize: TextSize.normal,
                            overrideColor:
                                appThemeState.themeClass.textCaptionColor,
                          ),
                      uiUtilityPackage.customText(
                        text: wides,
                        fontSize: TextSize.medium,
                        overrideColor: appThemeState.themeClass.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),

                ///No Balls
                SizedBox(
                  width: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      hideHeading
                          ? SizedBox.shrink()
                          : uiUtilityPackage.customText(
                            text: 'NB',
                            fontSize: TextSize.normal,
                            overrideColor:
                                appThemeState.themeClass.textCaptionColor,
                          ),
                      uiUtilityPackage.customText(
                        text: noBalls,
                        fontSize: TextSize.medium,
                        overrideColor: appThemeState.themeClass.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),

                ///Wickets
                SizedBox(
                  width: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      hideHeading
                          ? SizedBox.shrink()
                          : uiUtilityPackage.customText(
                            text: 'W',
                            fontSize: TextSize.normal,
                            overrideColor:
                                appThemeState.themeClass.textCaptionColor,
                          ),
                      uiUtilityPackage.customText(
                        text: wickets,
                        fontSize: TextSize.medium,
                        overrideColor: appThemeState.themeClass.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),

                ///Economy
                SizedBox(
                  width: 48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      hideHeading
                          ? SizedBox.shrink()
                          : uiUtilityPackage.customText(
                            text: 'Econ',
                            fontSize: TextSize.normal,
                            overrideColor:
                                appThemeState.themeClass.textCaptionColor,
                          ),
                      uiUtilityPackage.customText(
                        text: economy,
                        fontSize: TextSize.medium,
                        overrideColor: appThemeState.themeClass.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
