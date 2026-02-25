import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../logics/cubits/app_theme_cubit.dart';
import 'active_scorecard_widget.dart';
import 'concluded_scorecard_widget.dart';

class InningsWidget extends StatelessWidget {
  InningsWidget({
    super.key,

    required this.toggle,
    required this.tossWonBy,
    required this.isActive,
    required this.index,
  });

  final UiUtilityPackage uiUtilityPackage = UiUtilityPackage();
  final int tossWonBy, index;
  final bool toggle, isActive;

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
                  text: 'Innings ${index + 1}',
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
                  text: 'Team $tossWonBy: 0/0',
                  fontSize: TextSize.subTitle,
                  overrideColor: appThemeState.themeClass.white,
                  fontWeight: FontWeight.bold,
                ),
                uiUtilityPackage.customText(
                  text: 'Overs: 0.0(2.0)',
                  fontSize: TextSize.subTitle,
                  overrideColor: appThemeState.themeClass.white,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            isActive
                ? ActiveScorecardWidget(toggle: toggle)
                : ConcludedScorecardWidget(),
          ],
        );
      },
    );
  }
}
