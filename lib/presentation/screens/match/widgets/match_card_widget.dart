import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sports_tracker/presentation/widgets/batting_statistics_widget.dart';
import 'package:my_sports_tracker/presentation/widgets/bowling_statistics_widget.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../logics/cubits/app_theme_cubit.dart';
import 'active_scorecard_widget.dart';
import 'concluded_scorecard_widget.dart';
import 'innings_widget.dart';

class MatchCardWidget extends StatefulWidget {
  const MatchCardWidget({
    super.key,
    required this.tossWonBy,
    required this.batOrBowl,
    required this.isActive,
    required this.concluded,
  });

  final int tossWonBy, batOrBowl;
  final bool isActive, concluded;

  @override
  State<MatchCardWidget> createState() => _MatchCardWidgetState();
}

class _MatchCardWidgetState extends State<MatchCardWidget> {
  final UiUtilityPackage uiUtilityPackage = UiUtilityPackage();

  bool toggle = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeState>(
      builder: (context, appThemeState) {
        return SizedBox(
          child: uiUtilityPackage.customCard(
            onDoubleTap: () {
              setState(() {
                toggle = !toggle;
              });
            },
            color: appThemeState.themeClass.cardBackgroundColor,
            widget: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    uiUtilityPackage.customText(
                      text: 'Match 1',
                      fontSize: TextSize.large,
                      overrideColor: appThemeState.themeClass.white,
                    ),
                  ],
                ),
                widget.tossWonBy == 0
                    ? SizedBox.shrink()
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        uiUtilityPackage.customText(
                          text:
                              'Team ${widget.tossWonBy} won the toss ${widget.batOrBowl == 0 ? '' : 'and chose to ${widget.batOrBowl == 1 ? 'bat' : 'bowl'} first'}',
                          fontSize: TextSize.medium,
                          overrideColor: appThemeState.themeClass.white,
                        ),
                      ],
                    ),
                !widget.concluded
                    ? SizedBox.shrink()
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 8),
                        uiUtilityPackage.customText(
                          text: 'Man of the match ABC - 6(2) & 1/1',
                          fontSize: TextSize.normal,
                          overrideColor: appThemeState.themeClass.white,
                        ),
                        SizedBox(height: 8),
                        uiUtilityPackage.customText(
                          text:
                              'Best Batter - ABC 6(2) | Best Bowler ABC - 1/1',
                          fontSize: TextSize.normal,
                          overrideColor: appThemeState.themeClass.white,
                        ),
                      ],
                    ),

                widget.batOrBowl == 0
                    ? SizedBox.shrink()
                    : ListView.builder(
                      reverse: true,
                      itemCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, inning) {
                        return InningsWidget(
                          toggle: toggle,
                          tossWonBy: widget.tossWonBy,
                          isActive: inning != 0,

                          index: inning,
                        );
                      },
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
