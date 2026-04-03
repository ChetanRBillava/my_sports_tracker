import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sports_tracker/core/constants/app_strings.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../data/models/match_models/inning/inning_model.dart';
import '../../../../logics/cubits/app_theme_cubit.dart';
import 'active_scorecard_widget.dart';
import 'concluded_scorecard_widget.dart';

class InningsWidget extends StatelessWidget {
  InningsWidget({
    super.key,

    required this.toggle,
    required this.tossWonBy,
    required this.isActive,
    required this.inningsIndex,
    required this.maxBalls,
    required this.inningModel,
  });

  final UiUtilityPackage uiUtilityPackage = UiUtilityPackage();
  final int tossWonBy, inningsIndex, maxBalls;
  final bool toggle, isActive;
  final InningModel inningModel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeState>(
      builder: (context, appThemeState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                uiUtilityPackage.customText(
                  text:
                      inningsIndex > 1
                          ? '${AppStrings.superOverInnings.toUpperCase()} ${inningsIndex - 1}'
                          : '${AppStrings.innings.toUpperCase()} ${inningsIndex + 1}',
                  fontSize: TextSize.title,
                  overrideColor: appThemeState.themeClass.white,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                uiUtilityPackage.customText(
                  text:
                      '${AppStrings.team} ${inningModel.currentBattingTeam}: ${inningModel.totalRuns}/${inningModel.totalWickets}',
                  fontSize: TextSize.subTitle,
                  overrideColor: appThemeState.themeClass.white,
                  fontWeight: FontWeight.bold,
                ),
                uiUtilityPackage.customText(
                  text:
                      '${AppStrings.overs}: ${(inningModel.totalBalls / 6).floor()}.${inningModel.totalBalls % 6}(${inningsIndex > 1 ? '1.0' : maxBalls / 6})',
                  fontSize: TextSize.subTitle,
                  overrideColor: appThemeState.themeClass.white,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            inningModel.currentBatsman == 999
                ? SizedBox.shrink()
                : isActive
                ? ActiveScorecardWidget(
                  toggle: toggle,
                  currentBatsmanIndex: inningModel.currentBatsman,
                  currentBowlerIndex: inningModel.currentBowler,
                  inningModel: inningModel,
                )
                : ConcludedScorecardWidget(inningModel: inningModel),
          ],
        );
      },
    );
  }
}
