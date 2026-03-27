import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../logics/cubits/app_theme_cubit.dart';

class BattingStatisticsWidget extends StatelessWidget {
  BattingStatisticsWidget({
    super.key,
    required this.player,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.sr,
    this.hideLabel = false,
    this.hideHeading = false,
    this.matchCard = false,
  });

  final UiUtilityPackage uiUtilityPackage = UiUtilityPackage();

  String runs, balls, fours, sixes, sr, player;
  bool hideLabel, hideHeading, matchCard;

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
                          text: 'Batsman',
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

                ///4s
                SizedBox(
                  width: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      hideHeading
                          ? SizedBox.shrink()
                          : uiUtilityPackage.customText(
                            text: '4',
                            fontSize: TextSize.normal,
                            overrideColor:
                                appThemeState.themeClass.textCaptionColor,
                          ),
                      uiUtilityPackage.customText(
                        text: fours,
                        fontSize: TextSize.medium,
                        overrideColor: appThemeState.themeClass.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),

                ///6s
                SizedBox(
                  width: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      hideHeading
                          ? SizedBox.shrink()
                          : uiUtilityPackage.customText(
                            text: '6',
                            fontSize: TextSize.normal,
                            overrideColor:
                                appThemeState.themeClass.textCaptionColor,
                          ),
                      uiUtilityPackage.customText(
                        text: sixes,
                        fontSize: TextSize.medium,
                        overrideColor: appThemeState.themeClass.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),

                ///S/R
                SizedBox(
                  width: 48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      hideHeading
                          ? SizedBox.shrink()
                          : uiUtilityPackage.customText(
                            text: 'S/R',
                            fontSize: TextSize.normal,
                            overrideColor:
                                appThemeState.themeClass.textCaptionColor,
                          ),
                      uiUtilityPackage.customText(
                        text: sr,
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
