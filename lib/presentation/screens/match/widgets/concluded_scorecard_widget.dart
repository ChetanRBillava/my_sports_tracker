import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../data/models/inning_model.dart';
import '../../../../logics/cubits/app_theme_cubit.dart';
import '../../../widgets/batting_statistics_widget.dart';
import '../../../widgets/bowling_statistics_widget.dart';

class ConcludedScorecardWidget extends StatelessWidget {
  ConcludedScorecardWidget({super.key, required this.inningModel});
  final InningModel inningModel;

  final UiUtilityPackage uiUtilityPackage = UiUtilityPackage();

  String getSR({required int runs, required int balls}) {
    String strikeRate = ((runs / balls) * 100).toStringAsFixed(2);

    return strikeRate;
  }

  String getEconomy({required int runs, required int balls}) {
    String economy = ((runs / balls) * 6).toStringAsFixed(2);

    return economy;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeState>(
      builder: (context, appThemeState) {
        return Column(
          children: [
            ///Batting Scorecard
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                uiUtilityPackage.customText(
                  text: 'Batting Scorecard'.toUpperCase(),
                  fontSize: TextSize.label,
                  overrideColor: appThemeState.themeClass.white,
                ),
              ],
            ),
            SizedBox(height: 16),
            ListView.separated(
              itemCount: inningModel.batting.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, battingStatsIndex) {
                return BattingStatisticsWidget(
                  matchCard: true,
                  hideHeading: battingStatsIndex != 0,
                  player: inningModel.batting[battingStatsIndex].player.name,
                  runs: inningModel.batting[battingStatsIndex].runs.toString(),
                  balls:
                      inningModel.batting[battingStatsIndex].balls.toString(),
                  fours:
                      inningModel.batting[battingStatsIndex].fours.toString(),
                  sixes:
                      inningModel.batting[battingStatsIndex].sixes.toString(),
                  sr: getSR(
                    runs: inningModel.batting[battingStatsIndex].runs,
                    balls: inningModel.batting[battingStatsIndex].balls,
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
            ),
            SizedBox(height: 16),

            ///Bowling scorecard
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                uiUtilityPackage.customText(
                  text: 'Bowling Scorecard'.toUpperCase(),
                  fontSize: TextSize.label,
                  overrideColor: appThemeState.themeClass.white,
                ),
              ],
            ),
            SizedBox(height: 16),
            ListView.separated(
              itemCount: inningModel.bowling.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, bowlingStatsIndex) {
                return BowlingStatisticsWidget(
                  matchCard: true,
                  hideHeading: bowlingStatsIndex != 0,
                  player: inningModel.bowling[bowlingStatsIndex].player.name,
                  runs: inningModel.bowling[bowlingStatsIndex].runs.toString(),
                  balls:
                      inningModel.bowling[bowlingStatsIndex].balls.toString(),
                  wides:
                      inningModel.bowling[bowlingStatsIndex].wides.toString(),
                  noBalls:
                      inningModel.bowling[bowlingStatsIndex].noBalls.toString(),
                  wickets:
                      inningModel.bowling[bowlingStatsIndex].wickets.toString(),
                  economy: getEconomy(
                    runs: inningModel.bowling[bowlingStatsIndex].runs,
                    balls: inningModel.bowling[bowlingStatsIndex].balls,
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
            ),
          ],
        );
      },
    );
  }
}
