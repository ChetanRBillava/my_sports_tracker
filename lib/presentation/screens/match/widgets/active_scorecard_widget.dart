import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../logics/cubits/app_theme_cubit.dart';
import '../../../widgets/batting_statistics_widget.dart';
import '../../../widgets/bowling_statistics_widget.dart';

class ActiveScorecardWidget extends StatelessWidget {
  ActiveScorecardWidget({super.key, required this.toggle});

  final bool toggle;
  final UiUtilityPackage uiUtilityPackage = UiUtilityPackage();

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
                          text: 'ABC 0(0)',
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
                          text: '0/0 XYZ',
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
                      runs: '20',
                      balls: '1',
                      fours: '0',
                      sixes: '0',
                      sr: '200.00',
                      player: 'ABC',
                    ),
                    SizedBox(height: 16),
                    BowlingStatisticsWidget(
                      balls: '1',
                      runs: '2',
                      wickets: '0',
                      noBalls: '0',
                      wides: '0',
                      economy: '12.00',
                      player: 'XYZ',
                    ),
                  ],
                ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                uiUtilityPackage.customText(
                  text: 'This Over',
                  fontSize: TextSize.medium,
                  overrideColor: appThemeState.themeClass.textCaptionColor,
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      overs.map((ball) {
                        bool isShort = ball.length == 1;
                        return isShort
                            ? CircleAvatar(
                              radius: 16,
                              backgroundColor: _getBallColor(ball),
                              child: uiUtilityPackage.customText(
                                text: ball,
                                fontSize: TextSize.medium,
                                overrideColor: appThemeState.themeClass.white,
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
                                overrideColor: appThemeState.themeClass.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                      }).toList(),
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
