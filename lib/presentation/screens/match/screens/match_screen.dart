import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sports_tracker/core/constants/app_strings.dart';
import 'package:my_sports_tracker/data/models/match_models/inning/inning_model.dart';
import 'package:my_sports_tracker/data/models/match_models/series/series_model.dart';
import 'package:my_sports_tracker/logics/cubits/app_theme_cubit.dart';
import 'package:my_sports_tracker/presentation/screens/match/logic/match_screen_bloc.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../data/models/statistic_models/batting/batting_model.dart';
import '../../../../data/models/statistic_models/bowling/bowling_model.dart';
import '../../../../data/models/match_models/match/match_model.dart';
import '../../../../data/models/player_models/player_mini/player_mini_model.dart';
import '../../../../data/models/player_models/player/player_model.dart';
import '../../../utils/custom_print.dart';
import '../../home/logic/home_screen_bloc.dart';
import '../logic/match_screen_event.dart';
import '../logic/match_screen_state.dart';
import '../widgets/match_card_widget.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  UiUtilityPackage uiUtilityPackage = UiUtilityPackage();
  CustomPrint customPrint = CustomPrint();
  List<String> scores = ['0', '2', '4', '6', 'WD', 'NB', 'W'];
  BowlingModel? bowler;
  BattingModel? batter;
  int batterIndex = 0, bowlerIndex = 0;

  Future<void> matchSetup({bool update = false, bool addMatch = false}) async {
    // if (!update) {
    //   setState(() {
    //     batter = null;
    //     bowler = null;
    //   });
    // }
    final cubit = context.read<AppThemeCubit>();
    final bloc = context.read<MatchScreenBloc>();
    int tossWonBy = await bloc.getTossValue(),
        batOrBowl = await bloc.getBatOrBowl(),
        overs = await bloc.getOversCount();
    bool superOver = await bloc.checkSuperOver();
    Color? dialogBackground, textColor, buttonColor;
    if (mounted) {
      textColor = await cubit.getColor(color: AppColors.white);
      dialogBackground = await cubit.getColor(
        color: AppColors.cardBackgroundColor,
      );
      buttonColor = await cubit.getColor(
        color: AppColors.buttonBackgroundColor,
      );

      List<BowlingModel> bowlers = await bloc.getBowlers();
      List<BattingModel> batters = await bloc.getBatters();

      if (batters.isNotEmpty &&
          bowlers.isNotEmpty &&
          batter == null &&
          bowler == null) {
        PlayerMiniModel? tempBatsman = await bloc.getCurrentBatsman(),
            tempBowler = await bloc.getCurrentBowler();

        for (var ba in batters) {
          if (ba.player == tempBatsman) {
            batter = ba;
            break;
          }
        }
        for (var bo in bowlers) {
          if (bo.player == tempBowler) {
            bowler = bo;
            break;
          }
        }
      }

      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        backgroundColor: dialogBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, makeTossState) {
              return BlocListener<MatchScreenBloc, MatchScreenState>(
                listener: (context, matchScreenState) async {
                  customPrint.print(message: 'Listener updated ');
                  batters = await bloc.getBatters();
                  bowlers = await bloc.getBowlers();
                },
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Column(
                              children: [
                                uiUtilityPackage.customText(
                                  text:
                                      addMatch
                                          ? AppStrings.addNewMatch
                                          : update
                                          ? AppStrings.updateLineup
                                          : tossWonBy == 999
                                          ? AppStrings.toss
                                          : batOrBowl == 999
                                          ? "${AppStrings.team} $tossWonBy ${AppStrings.wonTheToss}"
                                          : "${AppStrings.team} $tossWonBy ${AppStrings.chooseTo} ${batOrBowl == 1 ? AppStrings.bat : AppStrings.bowl}",
                                  fontSize: TextSize.title,
                                  overrideColor: textColor,
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                            addMatch
                                ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    uiUtilityPackage.customButton(
                                      buttonText: AppStrings.add.toUpperCase(),
                                      borderColor: buttonColor,
                                      overrideTextColor: textColor,
                                      onTap: () {
                                        context.read<MatchScreenBloc>().add(
                                          AddNewMatchEvent(context: context),
                                        );
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                )
                                : tossWonBy == 999
                                ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    uiUtilityPackage.customButton(
                                      buttonText:
                                          AppStrings.makeToss.toUpperCase(),
                                      borderColor: buttonColor,
                                      overrideTextColor: textColor,
                                      onTap: () {
                                        setState(() {
                                          makeTossState(() {
                                            tossWonBy = makeToss();
                                          });
                                        });
                                      },
                                    ),
                                  ],
                                )
                                : batOrBowl == 999
                                ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    uiUtilityPackage.customButton(
                                      buttonText: AppStrings.bat.toUpperCase(),
                                      borderColor: buttonColor,
                                      overrideTextColor: textColor,
                                      onTap: () {
                                        setState(() {
                                          makeTossState(() {
                                            batOrBowl = 1;
                                          });
                                        });
                                        context.read<MatchScreenBloc>().add(
                                          MatchTossEvent(
                                            tossWonBy: tossWonBy,
                                            batOrBowl: batOrBowl,
                                            context: context,
                                          ),
                                        );
                                      },
                                    ),
                                    uiUtilityPackage.customButton(
                                      buttonText: AppStrings.bowl.toUpperCase(),
                                      borderColor: buttonColor,
                                      overrideTextColor: textColor,
                                      onTap: () {
                                        setState(() {
                                          makeTossState(() {
                                            batOrBowl = 2;
                                          });
                                        });
                                        context.read<MatchScreenBloc>().add(
                                          MatchTossEvent(
                                            tossWonBy: tossWonBy,
                                            batOrBowl: batOrBowl,
                                            context: context,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )
                                : Column(
                                  children: [
                                    uiUtilityPackage.customText(
                                      text: AppStrings.selectBatsman,
                                      fontSize: TextSize.subTitle,
                                      overrideColor: textColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children:
                                          batters.asMap().entries.map<Widget>((
                                            player,
                                          ) {
                                            if (!(player.value.out)) {
                                              return uiUtilityPackage
                                                  .customChip(
                                                    selectedColor: buttonColor,
                                                    overrideTextColor:
                                                        batter == player.value
                                                            ? textColor
                                                            : null,
                                                    checkmarkColor: textColor,
                                                    label:
                                                        player
                                                            .value
                                                            .player
                                                            .name,
                                                    chipSelected:
                                                        batter == player.value,
                                                    onSelected: (selected) {
                                                      makeTossState(() {
                                                        batter = player.value;
                                                      });
                                                      batterIndex = player.key;
                                                    },
                                                  );
                                            } else {
                                              return SizedBox.shrink();
                                            }
                                          }).toList(),
                                    ),
                                    const SizedBox(height: 16),

                                    uiUtilityPackage.customText(
                                      text: AppStrings.selectBowler,
                                      fontSize: TextSize.subTitle,
                                      overrideColor: textColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children:
                                          bowlers.asMap().entries.map<Widget>((
                                            player,
                                          ) {
                                            if ((bowlers.length < overs &&
                                                    player.value.balls < 9) ||
                                                (player.value.balls < 6)) {
                                              return uiUtilityPackage
                                                  .customChip(
                                                    selectedColor: buttonColor,
                                                    overrideTextColor:
                                                        bowler == player.value
                                                            ? textColor
                                                            : null,
                                                    checkmarkColor: textColor,
                                                    label:
                                                        player
                                                            .value
                                                            .player
                                                            .name,
                                                    chipSelected:
                                                        bowler == player.value,
                                                    onSelected: (selected) {
                                                      makeTossState(() {
                                                        bowler = player.value;
                                                      });
                                                      bowlerIndex = player.key;
                                                    },
                                                  );
                                            } else {
                                              return SizedBox.shrink();
                                            }
                                          }).toList(),
                                    ),
                                    const SizedBox(height: 16),
                                    update
                                        ? Row(
                                          mainAxisAlignment:
                                              superOver
                                                  ? MainAxisAlignment.center
                                                  : MainAxisAlignment
                                                      .spaceEvenly,
                                          children: [
                                            superOver
                                                ? SizedBox.shrink()
                                                : uiUtilityPackage.customButton(
                                                  buttonText:
                                                      AppStrings
                                                          .concludeInnings,
                                                  borderColor: buttonColor,
                                                  overrideTextColor: textColor,
                                                  onTap: () {
                                                    context
                                                        .read<MatchScreenBloc>()
                                                        .add(
                                                          ConcludeInningsEvent(
                                                            context: context,
                                                          ),
                                                        );
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                            uiUtilityPackage.customButton(
                                              buttonText:
                                                  AppStrings.updateInnings,
                                              borderColor: buttonColor,
                                              overrideTextColor: textColor,
                                              onTap: () {
                                                context
                                                    .read<MatchScreenBloc>()
                                                    .add(
                                                      MatchUpdatePlayerEvent(
                                                        batterIndex:
                                                            batterIndex,
                                                        bowlerIndex:
                                                            bowlerIndex,
                                                        context: context,
                                                      ),
                                                    );
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        )
                                        : uiUtilityPackage.customButton(
                                          buttonText:
                                              AppStrings.proceed.toUpperCase(),
                                          borderColor: buttonColor,
                                          overrideTextColor: textColor,
                                          onTap: () {
                                            setState(() {
                                              customPrint.print(
                                                message: 'Players selected',
                                              );
                                            });
                                            context.read<MatchScreenBloc>().add(
                                              MatchUpdatePlayerEvent(
                                                batterIndex: batterIndex,
                                                bowlerIndex: bowlerIndex,
                                                context: context,
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                        ),
                                  ],
                                ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

  int makeToss() {
    CustomPrint customPrint = CustomPrint();
    int tossWonBy = Random().nextInt(2) + 1;
    customPrint.print(message: 'Toss won by: $tossWonBy');
    return tossWonBy;
  }

  Future<void> scorePopup({
    required String batterName,
    required String batterRuns,
    required String batterBalls,
    required String bowlerName,
    required String bowlerRuns,
    required String bowlerWickets,
  }) async {
    final cubit = context.read<AppThemeCubit>();
    final bloc = context.read<MatchScreenBloc>();
    Color? dialogBackground, textColor, textCaptionColor;
    if (mounted) {
      textColor = await cubit.getColor(color: AppColors.white);
      textCaptionColor = await cubit.getColor(
        color: AppColors.textCaptionColor,
      );
      dialogBackground = await cubit.getColor(
        color: AppColors.cardBackgroundColor,
      );

      if (!mounted) return;

      PlayerMiniModel? batter = await bloc.getCurrentBatsman();
      bool noBall = false;

      showModalBottomSheet(
        context: context,
        backgroundColor: dialogBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, scoreState) {
              return SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          uiUtilityPackage.customText(
                            text: AppStrings.addScore.toUpperCase(),
                            fontSize: TextSize.title,
                            overrideColor: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  uiUtilityPackage.customText(
                                    text: AppStrings.batsman,
                                    fontSize: TextSize.medium,
                                    overrideColor: textCaptionColor,
                                  ),
                                  uiUtilityPackage.customText(
                                    text:
                                        '$batterName $batterRuns($batterBalls)',
                                    fontSize: TextSize.subTitle,
                                    overrideColor: textColor,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  uiUtilityPackage.customText(
                                    text: AppStrings.bowler,
                                    fontSize: TextSize.medium,
                                    overrideColor: textCaptionColor,
                                  ),
                                  uiUtilityPackage.customText(
                                    text:
                                        '$bowlerWickets/$bowlerRuns $bowlerName',
                                    fontSize: TextSize.subTitle,
                                    overrideColor: textColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                scores.map<Widget>((val) {
                                  return uiUtilityPackage.customChip(
                                    label: val,
                                    chipSelected: false,
                                    onSelected: (selected) {
                                      if (val != 'W') {
                                        if (val == 'NB') {
                                          noBall = true;
                                        } else {
                                          context.read<MatchScreenBloc>().add(
                                            MatchUpdateScoreEvent(
                                              score: noBall ? 'NB+$val' : val,
                                              context: context,
                                            ),
                                          );
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        customPrint.print(message: 'wicket');
                                        uiUtilityPackage.showCustomDialog(
                                          backgroundColor: dialogBackground,
                                          context: context,
                                          title: AppStrings.confirmWicket,
                                          overrideTitleTextColor: textColor,
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              uiUtilityPackage.customText(
                                                text:
                                                    '${AppStrings.confirmWicket} of ${batter?.name}',
                                                overrideColor: textColor,
                                                fontSize: TextSize.label,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            uiUtilityPackage.customButton(
                                              buttonText:
                                                  AppStrings.confirm
                                                      .toUpperCase(),
                                              overrideTextColor: textColor,
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            uiUtilityPackage.customButton(
                                              buttonText:
                                                  AppStrings.yes.toUpperCase(),
                                              overrideTextColor: textColor,
                                              onTap: () {
                                                context
                                                    .read<MatchScreenBloc>()
                                                    .add(
                                                      MatchUpdateScoreEvent(
                                                        score: val,
                                                        context: context,
                                                      ),
                                                    );
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  );
                                }).toList(),
                          ),
                          const SizedBox(height: 16),
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
  }

  Future<void> addPlayer() async {
    final cubit = context.read<AppThemeCubit>();
    final homeScreenBloc = context.read<HomeScreenBloc>();
    final matchScreenBloc = context.read<MatchScreenBloc>();
    List<PlayerMiniModel> team1 = await matchScreenBloc.getTeam(teamNum: 1);
    List<PlayerMiniModel> team2 = await matchScreenBloc.getTeam(teamNum: 2);
    Color? dialogBackground, textColor, buttonColor;
    if (mounted) {
      textColor = await cubit.getColor(color: AppColors.white);
      dialogBackground = await cubit.getColor(
        color: AppColors.cardBackgroundColor,
      );
      buttonColor = await cubit.getColor(
        color: AppColors.buttonBackgroundColor,
      );
      if (!mounted) return;

      // String selectedPlayer = '';
      PlayerMiniModel? selectedPlayer;
      List<PlayerModel> tempPlayers = await homeScreenBloc.getPlayers();
      SeriesModel seriesModel = await matchScreenBloc.getSeries();

      customPrint.print(message: 'Total loaded players: ${tempPlayers.length}');
      customPrint.print(
        message: 'Total players in team 1: ${seriesModel.team1.length}',
      );
      customPrint.print(
        message: 'Total players in team 2: ${seriesModel.team2.length}',
      );

      tempPlayers =
          tempPlayers
              .where(
                (element) =>
                    !seriesModel.team1.any(
                      (player) => player.id == element.id,
                    ) &&
                    !seriesModel.team2.any((player) => player.id == element.id),
              )
              .toList();

      uiUtilityPackage.showCustomDialog(
        backgroundColor: dialogBackground,
        context: context,
        title: AppStrings.addPlayerTitle,
        overrideTitleTextColor: textColor,
        content: StatefulBuilder(
          builder: (context, setThisState) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  tempPlayers.map<Widget>((player) {
                    return uiUtilityPackage.customChip(
                      selectedColor: buttonColor,
                      overrideTextColor:
                          selectedPlayer?.id == player.id ? textColor : null,
                      checkmarkColor: textColor,
                      label: player.name,
                      chipSelected: selectedPlayer?.id == player.id,
                      onSelected: (selected) {
                        setThisState(() {
                          selectedPlayer = PlayerMiniModel(
                            id: player.id,
                            name: player.name,
                          );
                        });
                      },
                    );
                  }).toList(),
            );
          },
        ),
        actions: [
          team1.length > team2.length
              ? SizedBox.shrink()
              : uiUtilityPackage.customButton(
                buttonText: '${AppStrings.team} 1',
                overrideTextColor: textColor,
                onTap: () {
                  context.read<MatchScreenBloc>().add(
                    MatchAddPlayerEvent(
                      player: selectedPlayer!,
                      teamNum: 1,
                      context: context,
                    ),
                  );
                  uiUtilityPackage.showCustomSnackBar(
                    backgroundColor: buttonColor,
                    context: context,
                    content: uiUtilityPackage.customText(
                      text:
                          '${AppStrings.playerAdded} to ${AppStrings.team} 1: ${selectedPlayer?.name}',
                      fontSize: TextSize.medium,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
          team2.length > team1.length
              ? SizedBox.shrink()
              : uiUtilityPackage.customButton(
                buttonText: '${AppStrings.team} 2',
                overrideTextColor: textColor,
                onTap: () {
                  context.read<MatchScreenBloc>().add(
                    MatchAddPlayerEvent(
                      player: selectedPlayer!,
                      teamNum: 2,
                      context: context,
                    ),
                  );
                  uiUtilityPackage.showCustomSnackBar(
                    backgroundColor: buttonColor,
                    context: context,
                    content: uiUtilityPackage.customText(
                      text:
                          '${AppStrings.playerAdded} to ${AppStrings.team} 2: ${selectedPlayer?.name}',
                      fontSize: TextSize.medium,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeState>(
      builder: (context, appThemeState) {
        return BlocBuilder<MatchScreenBloc, MatchScreenState>(
          builder: (context, matchScreenState) {
            return Scaffold(
              backgroundColor: appThemeState.themeClass.backgroundColor,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: appThemeState.themeClass.appbarBackgroundColor,
                title: uiUtilityPackage.customText(
                  text: matchScreenState.series!.name,
                  fontSize: TextSize.title,
                  overrideColor: appThemeState.themeClass.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    uiUtilityPackage.customCard(
                      color: appThemeState.themeClass.cardBackgroundColor,
                      widget: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              uiUtilityPackage.customText(
                                text: AppStrings.teams,
                                fontSize: TextSize.title,
                                overrideColor: appThemeState.themeClass.white,
                              ),

                              uiUtilityPackage.customButton(
                                type: ButtonType.icon,
                                icon: Icons.person_add,
                                iconColor: appThemeState.themeClass.white,
                                onTap: addPlayer,
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          Row(
                            children: [
                              uiUtilityPackage.customText(
                                text:
                                    '${AppStrings.team} 1: ${matchScreenState.series!.team1.map((p) => p.name).join(', ')}',
                                fontSize: TextSize.medium,
                                overrideColor: appThemeState.themeClass.white,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              uiUtilityPackage.customText(
                                text:
                                    '${AppStrings.team} 2: ${matchScreenState.series!.team2.map((p) => p.name).join(', ')}',
                                fontSize: TextSize.medium,
                                overrideColor: appThemeState.themeClass.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    matchScreenState.series!.matches.isEmpty
                        ? SizedBox.shrink()
                        : ListView.builder(
                          itemCount: matchScreenState.series!.matches.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final reverseIndex =
                                matchScreenState.series!.matches.length -
                                1 -
                                index;
                            final MatchModel matchModel =
                                matchScreenState.series!.matches[reverseIndex];
                            return MatchCardWidget(
                              index: reverseIndex,
                              matchModel: matchModel,
                            );
                          },
                        ),

                    SizedBox(height: 80),
                  ],
                ),
              ),
              floatingActionButton: GestureDetector(
                onDoubleTap: () {
                  matchSetup(update: true);
                },
                child: FloatingActionButton(
                  backgroundColor:
                      appThemeState.themeClass.buttonBackgroundColor,
                  onPressed:
                      (![999, 2].contains(
                                matchScreenState
                                    .series!
                                    .matches[matchScreenState.matchIndex]
                                    .wonBy,
                              ) ||
                              matchScreenState
                                      .series!
                                      .matches[matchScreenState.matchIndex]
                                      .batOrBowl ==
                                  999 ||
                              matchScreenState.updateLineup)
                          ? () => matchSetup(
                            update: matchScreenState.updateLineup,
                            addMatch:
                                (matchScreenState
                                            .series!
                                            .matches[matchScreenState
                                                .matchIndex]
                                            .wonBy !=
                                        999 &&
                                    matchScreenState
                                            .series!
                                            .matches[matchScreenState
                                                .matchIndex]
                                            .wonBy !=
                                        2),
                          )
                          : () {
                            MatchModel match =
                                matchScreenState
                                    .series!
                                    .matches[matchScreenState.matchIndex];
                            InningModel inning =
                                match.innings[matchScreenState.inningsIndex];
                            String batter =
                                    inning
                                        .batting[inning.currentBatsman]
                                        .player
                                        .name,
                                bowler =
                                    inning
                                        .bowling[inning.currentBowler]
                                        .player
                                        .name,
                                batterRuns =
                                    inning.batting[inning.currentBatsman].runs
                                        .toString(),
                                batterBalls =
                                    inning.batting[inning.currentBatsman].balls
                                        .toString(),
                                bowlerRuns =
                                    inning.bowling[inning.currentBowler].runs
                                        .toString(),
                                bowlerWickets =
                                    inning.bowling[inning.currentBowler].wickets
                                        .toString();
                            customPrint.print(message: 'Batter: $batter');
                            scorePopup(
                              batterName: batter,
                              batterRuns: batterRuns,
                              batterBalls: batterBalls,
                              bowlerName: bowler,
                              bowlerRuns: bowlerRuns,
                              bowlerWickets: bowlerWickets,
                            );
                          },
                  child: Icon(
                    (matchScreenState
                                    .series!
                                    .matches[matchScreenState.matchIndex]
                                    .wonBy !=
                                999 &&
                            matchScreenState
                                    .series!
                                    .matches[matchScreenState.matchIndex]
                                    .wonBy !=
                                2)
                        ? Icons.add
                        : matchScreenState
                                .series!
                                .matches[matchScreenState.matchIndex]
                                .batOrBowl ==
                            999
                        ? Icons.casino
                        : matchScreenState.updateLineup
                        ? Icons.update
                        : Icons.sports_baseball,
                    color: appThemeState.themeClass.white,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
