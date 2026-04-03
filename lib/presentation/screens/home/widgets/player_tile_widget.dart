import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sports_tracker/core/constants/app_strings.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../data/models/player_models/player/player_model.dart';
import '../../../../logics/cubits/app_theme_cubit.dart';
import '../../../widgets/batting_statistics_widget.dart';
import '../../../widgets/bowling_statistics_widget.dart';

UiUtilityPackage uiUtilityPackage = UiUtilityPackage();

Widget playerTileWidget({required int index, required PlayerModel player}) {
  bool isOpen = false;

  String getSR() {
    String strikeRate = (((player.stats?.batting?.runs ?? 0) /
                (player.stats?.batting?.balls ?? 0)) *
            100)
        .toStringAsFixed(2);

    return strikeRate;
  }

  String getEconomy() {
    String economy = (((player.stats!.bowling!.runs ?? 0) /
                (player.stats!.bowling!.balls ?? 0)) *
            6)
        .toStringAsFixed(2);

    return economy;
  }

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
                      text: player.name[0].toUpperCase(),
                      fontSize: TextSize.label,
                      overrideColor: appThemeState.themeClass.textColor_1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.6,
                        child: uiUtilityPackage.customText(
                          text: player.name.toUpperCase(),
                          fontSize: TextSize.title,
                          overrideColor: appThemeState.themeClass.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      isOpen
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Batting Statistics
                              uiUtilityPackage.customText(
                                text: AppStrings.battingStatistics,
                                fontSize: TextSize.subTitle,
                                overrideColor: appThemeState.themeClass.white,
                              ),
                              BattingStatisticsWidget(
                                hideLabel: true,
                                runs:
                                    (player.stats?.batting?.runs ?? 0)
                                        .toString(),
                                balls:
                                    (player.stats?.batting?.balls ?? 0)
                                        .toString(),
                                fours:
                                    (player.stats?.batting?.fours ?? 0)
                                        .toString(),
                                sixes:
                                    (player.stats?.batting?.sixes ?? 0)
                                        .toString(),
                                sr: getSR(),
                                player: player.name,
                              ),

                              SizedBox(height: 8),

                              ///Bowling Statistics
                              uiUtilityPackage.customText(
                                text: AppStrings.bowlingStatistics,
                                fontSize: TextSize.subTitle,
                                overrideColor: appThemeState.themeClass.white,
                              ),
                              BowlingStatisticsWidget(
                                hideLabel: true,
                                balls:
                                    (player.stats?.bowling?.balls ?? 0)
                                        .toString(),
                                runs:
                                    (player.stats?.bowling?.runs ?? 0)
                                        .toString(),
                                wickets:
                                    (player.stats?.bowling?.wickets ?? 0)
                                        .toString(),
                                noBalls:
                                    (player.stats?.bowling?.noBalls ?? 0)
                                        .toString(),
                                wides:
                                    (player.stats?.bowling?.wides ?? 0)
                                        .toString(),
                                economy: getEconomy(),
                                player: player.name,
                              ),

                              SizedBox(height: 8),

                              ///Match Statistics
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  uiUtilityPackage.customText(
                                    text: AppStrings.matchStatistics,
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
                                            text:
                                                '${AppStrings.played.toUpperCase()} - ',
                                            fontSize: TextSize.normal,
                                            overrideColor:
                                                appThemeState.themeClass.white,
                                          ),
                                          uiUtilityPackage.customText(
                                            text:
                                                (player.stats?.match?.played ??
                                                        0)
                                                    .toString(),
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
                                            text:
                                                '${AppStrings.won.toUpperCase()} - ',
                                            fontSize: TextSize.normal,
                                            overrideColor:
                                                appThemeState.themeClass.white,
                                          ),
                                          uiUtilityPackage.customText(
                                            text:
                                                (player.stats?.match?.won ?? 0)
                                                    .toString(),
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
                                            text: '${AppStrings.motm} - ',
                                            fontSize: TextSize.normal,
                                            overrideColor:
                                                appThemeState.themeClass.white,
                                          ),
                                          uiUtilityPackage.customText(
                                            text:
                                                (player.stats?.match?.motm ?? 0)
                                                    .toString(),
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
                                text: '${AppStrings.id}: ${player.id}',
                                fontSize: TextSize.normal,
                                overrideColor: appThemeState.themeClass.white,
                              ),
                              uiUtilityPackage.customText(
                                text:
                                    '${AppStrings.runs.toUpperCase()}: ${player.stats?.batting?.runs} | '
                                    '${AppStrings.sr}: ${getSR()} | ${AppStrings.wickets.toUpperCase()}: ${player.stats?.bowling?.wickets}',
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
