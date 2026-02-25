import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../logics/cubits/app_theme_cubit.dart';
import '../../../widgets/batting_statistics_widget.dart';
import '../../../widgets/bowling_statistics_widget.dart';

UiUtilityPackage uiUtilityPackage = UiUtilityPackage();

Widget playerTileWidget({required int index}) {
  bool isOpen = false;
  return StatefulBuilder(
    builder: (context, setThisState) {
      return BlocBuilder<AppThemeCubit, AppThemeState>(
        builder: (context, appThemeState) {
          return GestureDetector(
            onDoubleTap: () {
              setThisState(() {
                isOpen = !isOpen;
              });
            },
            onLongPress: () {},
            child: uiUtilityPackage.customCard(
              color: appThemeState.themeClass.cardBackgroundColor,
              widget: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        appThemeState.themeClass.appbarBackgroundColor,
                    child: uiUtilityPackage.customText(
                      text: 'P${index + 1}',
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
                        text: 'Player Name',
                        fontSize: TextSize.title,
                        overrideColor: appThemeState.themeClass.white,
                        fontWeight: FontWeight.bold,
                      ),

                      isOpen
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Batting Statistics
                              uiUtilityPackage.customText(
                                text: 'Batting Statistics',
                                fontSize: TextSize.subTitle,
                                overrideColor: appThemeState.themeClass.white,
                              ),
                              BattingStatisticsWidget(
                                hideLabel: true,
                                runs: '100',
                                balls: '50',
                                fours: '20',
                                sixes: '10',
                                sr: '200.00',
                                player: 'ABC',
                              ),

                              SizedBox(height: 8),

                              ///Bowling Statistics
                              uiUtilityPackage.customText(
                                text: 'Bowling Statistics',
                                fontSize: TextSize.subTitle,
                                overrideColor: appThemeState.themeClass.white,
                              ),
                              BowlingStatisticsWidget(
                                hideLabel: true,
                                balls: '100',
                                runs: '50',
                                wickets: '10',
                                noBalls: '20',
                                wides: '10',
                                economy: '12.00',
                                player: 'ABC',
                              ),

                              SizedBox(height: 8),

                              ///Match Statistics
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  uiUtilityPackage.customText(
                                    text: 'Match Statistics',
                                    fontSize: TextSize.subTitle,
                                    overrideColor:
                                        appThemeState.themeClass.white,
                                  ),
                                  Row(
                                    children: [
                                      ///Played
                                      Row(
                                        children: [
                                          uiUtilityPackage.customText(
                                            text: 'Played - ',
                                            fontSize: TextSize.normal,
                                            overrideColor:
                                                appThemeState.themeClass.white,
                                          ),
                                          uiUtilityPackage.customText(
                                            text: '100',
                                            fontSize: TextSize.medium,
                                            overrideColor:
                                                appThemeState.themeClass.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),

                                      SizedBox(width: 8),

                                      ///Won
                                      Row(
                                        children: [
                                          uiUtilityPackage.customText(
                                            text: 'Won - ',
                                            fontSize: TextSize.normal,
                                            overrideColor:
                                                appThemeState.themeClass.white,
                                          ),
                                          uiUtilityPackage.customText(
                                            text: '50',
                                            fontSize: TextSize.medium,
                                            overrideColor:
                                                appThemeState.themeClass.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),

                                      SizedBox(width: 8),

                                      ///Man of the Match
                                      Row(
                                        children: [
                                          uiUtilityPackage.customText(
                                            text: 'MOTM - ',
                                            fontSize: TextSize.normal,
                                            overrideColor:
                                                appThemeState.themeClass.white,
                                          ),
                                          uiUtilityPackage.customText(
                                            text: '25',
                                            fontSize: TextSize.medium,
                                            overrideColor:
                                                appThemeState.themeClass.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              uiUtilityPackage.customText(
                                text: 'ID: player_${index + 1}',
                                fontSize: TextSize.normal,
                                overrideColor: appThemeState.themeClass.white,
                              ),
                              uiUtilityPackage.customText(
                                text: 'RUNS: 100 | S/R: 120.12 | WICKETS: 10',
                                fontSize: TextSize.normal,
                                overrideColor: appThemeState.themeClass.white,
                              ),
                            ],
                          ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
