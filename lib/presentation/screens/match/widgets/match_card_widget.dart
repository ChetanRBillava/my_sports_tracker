import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sports_tracker/data/models/match_models/match/match_model.dart';
import 'package:my_sports_tracker/presentation/widgets/batting_statistics_widget.dart';
import 'package:my_sports_tracker/presentation/widgets/bowling_statistics_widget.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../logics/cubits/app_theme_cubit.dart';
import 'active_scorecard_widget.dart';
import 'concluded_scorecard_widget.dart';
import 'innings_widget.dart';

enum Motm {
  motmName,
  motmRuns,
  motmWickets,
  bestBatterName,
  bestBatterRuns,
  bestBowlerName,
  bestBowlerWickets,
}

class MatchCardWidget extends StatefulWidget {
  const MatchCardWidget({
    super.key,
    required this.index,
    required this.matchModel,
  });

  final int index;
  final MatchModel matchModel;

  @override
  State<MatchCardWidget> createState() => _MatchCardWidgetState();
}

class _MatchCardWidgetState extends State<MatchCardWidget> {
  final UiUtilityPackage uiUtilityPackage = UiUtilityPackage();

  bool toggle = true;

  String getLabel() {
    String label = 'Toss not done yet';

    if (widget.matchModel.wonBy == 3) {
      label = 'SUPER OVER ENDED IN A DRAW!!!';
    } else if (widget.matchModel.innings.length > 2 &&
        widget.matchModel.wonBy != 2) {
      label = 'Team ${widget.matchModel.wonBy + 1} won the match in super over';
    } else if (widget.matchModel.innings.length == 4 &&
        widget.matchModel.wonBy == 2) {
      int runs =
              widget.matchModel.innings[2].totalRuns -
              widget.matchModel.innings[3].totalRuns +
              1,
          balls = 6 - widget.matchModel.innings[3].totalBalls;
      label =
          '$runs RUNS needed in $balls balls to win the SUPER!!! ${widget.matchModel.wonBy}';
    } else if (widget.matchModel.wonBy == 2) {
      label = 'Match into the SUPER OVER!!!';
    } else if (![999, 2].contains(widget.matchModel.wonBy)) {
      String difference = '';
      if (widget.matchModel.innings[0].currentBattingTeam ==
          widget.matchModel.wonBy + 1) {
        difference =
            'by ${widget.matchModel.innings[0].totalRuns - widget.matchModel.innings[1].totalRuns} runs';
      } else {
        difference =
            'by ${widget.matchModel.innings[1].batting.length - widget.matchModel.innings[1].totalWickets} wickets';
      }
      label = 'Team ${widget.matchModel.wonBy + 1} won the match $difference';
    } else if (widget.matchModel.toss != 999 &&
        widget.matchModel.innings.length == 1) {
      label =
          'Team ${widget.matchModel.toss} won the toss ${widget.matchModel.batOrBowl == 0 ? '' : 'and chose to ${widget.matchModel.batOrBowl == 1 ? 'bat' : 'bowl'} first'}';
    } else if (widget.matchModel.innings.length == 2) {
      int team = widget.matchModel.innings[1].currentBattingTeam,
          runs =
              widget.matchModel.innings[0].totalRuns -
              widget.matchModel.innings[1].totalRuns +
              1,
          balls =
              widget.matchModel.maxBalls -
              widget.matchModel.innings[1].totalBalls;
      label = 'Team $team needs $runs runs in $balls balls to win!!!';
    }

    return label;
  }

  String? getMotmDetails({required Motm type}) {
    switch (type) {
      case Motm.motmName:
        return widget.matchModel.stats?.manOfTheMatch?.player?.name;
      case Motm.motmRuns:
        if (widget.matchModel.stats?.manOfTheMatch?.batting == null) {
          return '0(0)';
        }
        return '${widget.matchModel.stats?.manOfTheMatch?.batting!.runs}(${widget.matchModel.stats?.manOfTheMatch?.batting!.balls})';
      case Motm.motmWickets:
        if (widget.matchModel.stats?.manOfTheMatch?.bowling == null) {
          return '0/0';
        }
        return '${widget.matchModel.stats?.manOfTheMatch?.bowling!.wickets}/${widget.matchModel.stats?.manOfTheMatch?.bowling!.runs}';
      case Motm.bestBatterName:
        return widget.matchModel.stats?.bestBatting?.player.name;
      case Motm.bestBatterRuns:
        return '${widget.matchModel.stats?.bestBatting!.runs}(${widget.matchModel.stats?.bestBatting!.balls})';
      case Motm.bestBowlerName:
        return widget.matchModel.stats?.bestBowling?.player.name;
      case Motm.bestBowlerWickets:
        return '${widget.matchModel.stats?.bestBowling!.wickets}/${widget.matchModel.stats?.bestBowling!.runs}';
    }
  }

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
                      text: '${AppStrings.match} ${widget.index + 1}',
                      fontSize: TextSize.large,
                      overrideColor: appThemeState.themeClass.white,
                    ),
                  ],
                ),
                widget.matchModel.toss == 999
                    ? SizedBox.shrink()
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        uiUtilityPackage.customText(
                          text: getLabel(),
                          fontSize: TextSize.medium,
                          overrideColor: appThemeState.themeClass.white,
                        ),
                      ],
                    ),
                (widget.matchModel.wonBy == 999 ||
                        widget.matchModel.wonBy == 2 ||
                        widget.matchModel.stats?.manOfTheMatch?.batting == null)
                    ? SizedBox.shrink()
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 8),
                        uiUtilityPackage.customText(
                          text:
                              '${AppStrings.motmTitle} ${getMotmDetails(type: Motm.motmName)} - ${getMotmDetails(type: Motm.motmRuns)}  &  ${getMotmDetails(type: Motm.motmWickets)}',
                          fontSize: TextSize.normal,
                          overrideColor: appThemeState.themeClass.white,
                        ),
                        SizedBox(height: 8),
                        uiUtilityPackage.customText(
                          text:
                              '${AppStrings.bestBatter} - ${getMotmDetails(type: Motm.bestBatterName)} ${getMotmDetails(type: Motm.bestBatterRuns)}'
                              ' | ${AppStrings.bestBowler} - ${getMotmDetails(type: Motm.bestBowlerName)} ${getMotmDetails(type: Motm.bestBowlerWickets)}',
                          fontSize: TextSize.normal,
                          overrideColor: appThemeState.themeClass.white,
                        ),
                      ],
                    ),

                widget.matchModel.batOrBowl == 0
                    ? SizedBox.shrink()
                    : ListView.builder(
                      reverse: true,
                      itemCount: widget.matchModel.innings.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, inning) {
                        return InningsWidget(
                          toggle: toggle,
                          tossWonBy: widget.matchModel.toss,
                          isActive:
                              ([999, 2].contains(widget.matchModel.wonBy) &&
                                  inning ==
                                      widget.matchModel.innings.length - 1),
                          inningsIndex: inning,
                          inningModel: widget.matchModel.innings[inning],
                          maxBalls: widget.matchModel.maxBalls,
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
