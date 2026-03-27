import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sports_tracker/presentation/screens/match/logic/match_screen_event.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../data/models/inning_model.dart';
import '../../../../logics/cubits/app_theme_cubit.dart';
import '../../../widgets/batting_statistics_widget.dart';
import '../../../widgets/bowling_statistics_widget.dart';
import '../logic/match_screen_bloc.dart';

class ActiveScorecardWidget extends StatelessWidget {
  ActiveScorecardWidget({
    super.key,
    required this.toggle,
    required this.currentBatsmanIndex,
    required this.currentBowlerIndex,
    required this.inningModel,
  });

  final bool toggle;
  final int currentBatsmanIndex, currentBowlerIndex;
  final InningModel inningModel;
  final UiUtilityPackage uiUtilityPackage = UiUtilityPackage();

  String getSR() {
    String strikeRate = (((inningModel
                        .batting[inningModel.currentBatsman]
                        .runs ??
                    0) /
                (inningModel.batting[inningModel.currentBatsman].balls ?? 0)) *
            100)
        .toStringAsFixed(2);

    return strikeRate;
  }

  String getEconomy() {
    String economy = (((inningModel.bowling[inningModel.currentBowler].runs ??
                    0) /
                (inningModel.bowling[inningModel.currentBowler].balls ?? 0)) *
            6)
        .toStringAsFixed(2);

    return economy;
  }

  final overs = ['0', '2', '4', 'WD', 'NB+2', '6', 'W'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeState>(
      builder: (context, appThemeState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            toggle
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        uiUtilityPackage.customText(
                          text: 'Batsman',
                          fontSize: TextSize.medium,
                          overrideColor:
                              appThemeState.themeClass.textCaptionColor,
                        ),
                        uiUtilityPackage.customText(
                          text:
                              '${inningModel.batting[inningModel.currentBatsman].player.name} '
                              '${inningModel.batting[inningModel.currentBatsman].runs}'
                              '(${inningModel.batting[inningModel.currentBatsman].balls})',
                          fontSize: TextSize.subTitle,
                          overrideColor: appThemeState.themeClass.white,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        uiUtilityPackage.customText(
                          text: 'Bowler',
                          fontSize: TextSize.medium,
                          overrideColor:
                              appThemeState.themeClass.textCaptionColor,
                        ),
                        uiUtilityPackage.customText(
                          text:
                              '${inningModel.bowling[inningModel.currentBowler].wickets}/'
                              '${inningModel.bowling[inningModel.currentBowler].runs} '
                              '${inningModel.bowling[inningModel.currentBowler].player.name}',
                          fontSize: TextSize.subTitle,
                          overrideColor: appThemeState.themeClass.white,
                        ),
                      ],
                    ),
                  ],
                )
                : Column(
                  children: [
                    BattingStatisticsWidget(
                      matchCard: true,
                      runs:
                          inningModel.batting[inningModel.currentBatsman].runs
                              .toString(),
                      balls:
                          inningModel.batting[inningModel.currentBatsman].balls
                              .toString(),
                      fours:
                          inningModel.batting[inningModel.currentBatsman].fours
                              .toString(),
                      sixes:
                          inningModel.batting[inningModel.currentBatsman].sixes
                              .toString(),
                      sr: getSR(),
                      player:
                          inningModel
                              .batting[inningModel.currentBatsman]
                              .player
                              .name,
                    ),
                    SizedBox(height: 16),
                    BowlingStatisticsWidget(
                      matchCard: true,
                      runs:
                          inningModel.bowling[inningModel.currentBowler].runs
                              .toString(),
                      balls:
                          inningModel.bowling[inningModel.currentBowler].balls
                              .toString(),
                      wides:
                          inningModel.bowling[inningModel.currentBowler].wides
                              .toString(),
                      noBalls:
                          inningModel.bowling[inningModel.currentBowler].noBalls
                              .toString(),
                      wickets:
                          inningModel.bowling[inningModel.currentBowler].wickets
                              .toString(),
                      economy: getEconomy(),
                      player:
                          inningModel
                              .bowling[inningModel.currentBowler]
                              .player
                              .name,
                    ),
                  ],
                ),
            SizedBox(height: 16),
            inningModel.overs.isEmpty
                ? SizedBox.shrink()
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    uiUtilityPackage.customText(
                      text: 'This Over',
                      fontSize: TextSize.medium,
                      overrideColor: appThemeState.themeClass.textCaptionColor,
                    ),
                    SizedBox(height: 8),
                    inningModel.overs.last.over.isEmpty
                        ? CircleAvatar(
                          radius: 16,
                          backgroundColor: _getBallColor('-'),
                          child: uiUtilityPackage.customText(
                            text: '-',
                            fontSize: TextSize.medium,
                            overrideColor: appThemeState.themeClass.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : GestureDetector(
                          onLongPress: () {
                            if (inningModel.overs.last.over.last != 'W') {
                              uiUtilityPackage.showCustomDialog(
                                backgroundColor:
                                    appThemeState
                                        .themeClass
                                        .cardBackgroundColor,
                                context: context,
                                title:
                                    'Revert score - ${inningModel.overs.last.over.last}!?',
                                overrideTitleTextColor:
                                    appThemeState.themeClass.white,
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    uiUtilityPackage.customText(
                                      text:
                                          'Do you really want to revert\nthe score!??',
                                      overrideColor:
                                          appThemeState.themeClass.white,
                                      fontSize: TextSize.label,
                                    ),
                                  ],
                                ),
                                actions: [
                                  uiUtilityPackage.customButton(
                                    buttonText: 'Cancel',
                                    overrideTextColor:
                                        appThemeState.themeClass.white,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  uiUtilityPackage.customButton(
                                    buttonText: 'Confirm',
                                    overrideTextColor:
                                        appThemeState.themeClass.white,
                                    onTap: () {
                                      context.read<MatchScreenBloc>().add(
                                        RevertScoreEvent(context: context),
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                inningModel.overs.last.over.map((ball) {
                                  bool isShort = ball.length == 1;
                                  return isShort
                                      ? CircleAvatar(
                                        radius: 16,
                                        backgroundColor: _getBallColor(ball),
                                        child: uiUtilityPackage.customText(
                                          text: ball,
                                          fontSize: TextSize.medium,
                                          overrideColor:
                                              appThemeState.themeClass.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                      : Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getBallColor(ball),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: uiUtilityPackage.customText(
                                          text: ball,
                                          fontSize: TextSize.medium,
                                          overrideColor:
                                              appThemeState.themeClass.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                }).toList(),
                          ),
                        ),
                  ],
                ),
            inningModel.overs.length < 2
                ? SizedBox.shrink()
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    uiUtilityPackage.customText(
                      text: 'Last Over',
                      fontSize: TextSize.medium,
                      overrideColor: appThemeState.themeClass.textCaptionColor,
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          inningModel.overs[inningModel.overs.length - 2].over
                              .map((ball) {
                                bool isShort = ball.length == 1;
                                return isShort
                                    ? CircleAvatar(
                                      radius: 16,
                                      backgroundColor: _getBallColor(ball),
                                      child: uiUtilityPackage.customText(
                                        text: ball,
                                        fontSize: TextSize.medium,
                                        overrideColor:
                                            appThemeState.themeClass.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                    : Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getBallColor(ball),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: uiUtilityPackage.customText(
                                        text: ball,
                                        fontSize: TextSize.medium,
                                        overrideColor:
                                            appThemeState.themeClass.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                              })
                              .toList(),
                    ),
                  ],
                ),
          ],
        );
      },
    );
  }
}

Color _getBallColor(String ball) {
  switch (ball) {
    case "-":
      return Colors.black; // Empty over
    case "0":
      return Colors.grey.shade400; // dot ball
    case "1":
    case "2":
    case "3":
      return Colors.green.shade300; // normal runs
    case "4":
      return Colors.blue.shade300; // boundary
    case "6":
      return Colors.purple.shade300; // six
    case "W":
      return Colors.red.shade400; // wicket
    case "WD":
      return Colors.yellow.shade800; // wide
    default:
      return Colors.orange.shade800; // fallback or No Ball
  }
}
