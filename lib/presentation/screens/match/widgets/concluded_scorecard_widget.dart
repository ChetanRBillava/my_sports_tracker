import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../logics/cubits/app_theme_cubit.dart';
import '../../../widgets/batting_statistics_widget.dart';
import '../../../widgets/bowling_statistics_widget.dart';

class ConcludedScorecardWidget extends StatelessWidget {
  ConcludedScorecardWidget({super.key});

  final UiUtilityPackage uiUtilityPackage = UiUtilityPackage();

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
              itemCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, playerIndex) {
                return BattingStatisticsWidget(
                  hideHeading: playerIndex != 0,
                  player: 'ABC',
                  runs: '10',
                  balls: '6',
                  fours: '1',
                  sixes: '0',
                  sr: '123.45',
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
              itemCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, playerIndex) {
                return BowlingStatisticsWidget(
                  hideHeading: playerIndex != 0,
                  player: 'XYZ',
                  runs: '10',
                  balls: '6',
                  wides: '1',
                  noBalls: '0',
                  wickets: '0',
                  economy: '12.45',
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
