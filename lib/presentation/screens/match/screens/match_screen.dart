import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sports_tracker/logics/cubits/app_theme_cubit.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../core/constants/enums.dart';
import '../../../utils/custom_print.dart';
import '../widgets/match_card_widget.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  UiUtilityPackage uiUtilityPackage = UiUtilityPackage();
  CustomPrint customPrint = CustomPrint();
  int tossWonBy = 0, batOrBowl = 0;
  List<String> players = ['ABC', 'MNO', 'XYZ', 'PQR', 'STU', 'IJK', 'DEF'];
  List<String> batting = ['ABC', 'MNO'],
      bowling = ['IJK', 'DEF'],
      scores = ['0', '2', '4', '6', 'WD', 'NB', 'W'];
  String batter = '', bowler = '', score = '';
  bool concluded = false;

  Future<void> matchSetup({bool update = false}) async {
    if (!update) {
      setState(() {
        tossWonBy = 0;
        batOrBowl = 0;

        batter = '';
        bowler = '';
      });
    }
    Color dialogBackground = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.cardBackgroundColor);
    Color textColor = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.white);
    Color buttonColor = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.buttonBackgroundColor);

    showModalBottomSheet(
      context: context,
      backgroundColor: dialogBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, makeTossState) {
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
                        update
                            ? SizedBox.shrink()
                            : Column(
                              children: [
                                uiUtilityPackage.customText(
                                  text:
                                      tossWonBy == 0
                                          ? "Toss"
                                          : batOrBowl == 0
                                          ? "Team $tossWonBy won the toss"
                                          : "Team $tossWonBy choose to ${batOrBowl == 1 ? "Bat" : "Bowl"}",
                                  fontSize: TextSize.title,
                                  overrideColor: textColor,
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                        tossWonBy == 0
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                uiUtilityPackage.customButton(
                                  buttonText: 'MAKE TOSS',
                                  borderColor: buttonColor,
                                  overrideTextColor: textColor,
                                  onTap: () {
                                    setState(() {
                                      makeTossState(() {
                                        makeToss();
                                      });
                                    });
                                  },
                                ),
                              ],
                            )
                            : batOrBowl == 0
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                uiUtilityPackage.customButton(
                                  buttonText: 'BAT',
                                  borderColor: buttonColor,
                                  overrideTextColor: textColor,
                                  onTap: () {
                                    setState(() {
                                      makeTossState(() {
                                        batOrBowl = 1;
                                      });
                                    });
                                  },
                                ),
                                uiUtilityPackage.customButton(
                                  buttonText: 'BOWL',
                                  borderColor: buttonColor,
                                  overrideTextColor: textColor,
                                  onTap: () {
                                    setState(() {
                                      makeTossState(() {
                                        batOrBowl = 2;
                                      });
                                    });
                                  },
                                ),
                              ],
                            )
                            : Column(
                              children: [
                                uiUtilityPackage.customText(
                                  text: "Select Batsman",
                                  fontSize: TextSize.subTitle,
                                  overrideColor: textColor,
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                      batting.map<Widget>((player) {
                                        return uiUtilityPackage.customChip(
                                          selectedColor: buttonColor,
                                          overrideTextColor:
                                              batter == player
                                                  ? textColor
                                                  : null,
                                          checkmarkColor: textColor,
                                          label: player,
                                          chipSelected: batter == player,
                                          onSelected: (selected) {
                                            makeTossState(() {
                                              batter = player;
                                            });
                                          },
                                        );
                                      }).toList(),
                                ),
                                const SizedBox(height: 16),
                                uiUtilityPackage.customText(
                                  text: "Select Bowler",
                                  fontSize: TextSize.subTitle,
                                  overrideColor: textColor,
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                      bowling.map<Widget>((player) {
                                        return uiUtilityPackage.customChip(
                                          selectedColor: buttonColor,
                                          overrideTextColor:
                                              bowler == player
                                                  ? textColor
                                                  : null,
                                          checkmarkColor: textColor,
                                          label: player,
                                          chipSelected: bowler == player,
                                          onSelected: (selected) {
                                            makeTossState(() {
                                              bowler = player;
                                            });
                                          },
                                        );
                                      }).toList(),
                                ),
                                const SizedBox(height: 16),
                                update
                                    ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        uiUtilityPackage.customButton(
                                          buttonText: 'Conclude Innings',
                                          borderColor: buttonColor,
                                          overrideTextColor: textColor,
                                          onTap: () {
                                            setState(() {
                                              concluded = true;
                                              customPrint.print(
                                                message: 'Conclude Innings',
                                              );
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        uiUtilityPackage.customButton(
                                          buttonText: 'Update Innings',
                                          borderColor: buttonColor,
                                          overrideTextColor: textColor,
                                          onTap: () {
                                            setState(() {
                                              customPrint.print(
                                                message: 'Update Innings',
                                              );
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    )
                                    : uiUtilityPackage.customButton(
                                      buttonText: 'Proceed',
                                      borderColor: buttonColor,
                                      overrideTextColor: textColor,
                                      onTap: () {
                                        setState(() {
                                          customPrint.print(
                                            message: 'Players selected',
                                          );
                                        });
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
            );
          },
        );
      },
    );
  }

  void makeToss() {
    CustomPrint customPrint = CustomPrint();
    tossWonBy = Random().nextInt(2) + 1;
    customPrint.print(message: 'Toss won by: $tossWonBy');
  }

  Future<void> scorePopup() async {
    Color dialogBackground = await BlocProvider.of<AppThemeCubit>(
          context,
        ).getColor(color: AppColors.cardBackgroundColor),
        textColor = await BlocProvider.of<AppThemeCubit>(
          context,
        ).getColor(color: AppColors.white);

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
                          text: "Add Score".toUpperCase(),
                          fontSize: TextSize.title,
                          overrideColor: textColor,
                          fontWeight: FontWeight.bold,
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
                                    if (score != 'W') {
                                      scoreState(() {
                                        score = val;
                                      });
                                      uiUtilityPackage.showCustomToast(
                                        context: context,
                                        message: 'Added score: $val',
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      customPrint.print(message: 'wicket');
                                      uiUtilityPackage.showCustomDialog(
                                        backgroundColor: dialogBackground,
                                        context: context,
                                        title: 'Confirm Wicket',
                                        overrideTitleTextColor: textColor,
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            uiUtilityPackage.customText(
                                              text: 'Confirm wicket of abc',
                                              overrideColor: textColor,
                                              fontSize: TextSize.label,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          uiUtilityPackage.customButton(
                                            buttonText: 'Cancel',
                                            overrideTextColor: textColor,
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          uiUtilityPackage.customButton(
                                            buttonText: 'Confirm',
                                            overrideTextColor: textColor,
                                            onTap: () {
                                              scoreState(() {
                                                score = val;
                                              });
                                              uiUtilityPackage.showCustomToast(
                                                context: context,
                                                message: 'Added score: $val',
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

  Future<void> addPlayer() async {
    Color dialogBackground = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.cardBackgroundColor);
    Color textColor = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.white);
    Color buttonColor = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.buttonBackgroundColor);

    String selectedPlayer = '';

    uiUtilityPackage.showCustomDialog(
      backgroundColor: dialogBackground,
      context: context,
      title: 'Add Player',
      overrideTitleTextColor: textColor,
      content: StatefulBuilder(
        builder: (context, setThisState) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                players.map<Widget>((player) {
                  return uiUtilityPackage.customChip(
                    selectedColor: buttonColor,
                    overrideTextColor:
                        selectedPlayer == player ? textColor : null,
                    checkmarkColor: textColor,
                    label: player,
                    chipSelected: selectedPlayer == player,
                    onSelected: (selected) {
                      setThisState(() {
                        selectedPlayer = player;
                      });
                    },
                  );
                }).toList(),
          );
        },
      ),
      actions: [
        uiUtilityPackage.customButton(
          buttonText: 'Team 1',
          overrideTextColor: textColor,
          onTap: () {
            uiUtilityPackage.showCustomSnackBar(
              backgroundColor: buttonColor,
              context: context,
              content: uiUtilityPackage.customText(
                text: 'Player added to team 1: $selectedPlayer',
                fontSize: TextSize.medium,
              ),
            );
            Navigator.pop(context);
          },
        ),
        uiUtilityPackage.customButton(
          buttonText: 'Team 2',
          overrideTextColor: textColor,
          onTap: () {
            uiUtilityPackage.showCustomSnackBar(
              backgroundColor: buttonColor,
              context: context,
              content: uiUtilityPackage.customText(
                text: 'Player added to team 2: $selectedPlayer',
                fontSize: TextSize.medium,
              ),
            );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeState>(
      builder: (context, appThemeState) {
        return Scaffold(
          backgroundColor: appThemeState.themeClass.backgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: appThemeState.themeClass.appbarBackgroundColor,
            title: uiUtilityPackage.customText(
              text: 'Match Screen ',
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
                            text: 'Teams',
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
                            text: 'Team 1: ABC, XYZ, MNO',
                            fontSize: TextSize.medium,
                            overrideColor: appThemeState.themeClass.white,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          uiUtilityPackage.customText(
                            text: 'Team 2: DEF, STU, PQR',
                            fontSize: TextSize.medium,
                            overrideColor: appThemeState.themeClass.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                MatchCardWidget(
                  tossWonBy: tossWonBy,
                  batOrBowl: batOrBowl,
                  isActive: false,
                  concluded: concluded,
                ),
              ],
            ),
          ),
          floatingActionButton: GestureDetector(
            onDoubleTap: () {
              matchSetup(update: true);
            },
            child: FloatingActionButton(
              backgroundColor: appThemeState.themeClass.buttonBackgroundColor,
              onPressed: batOrBowl == 0 ? matchSetup : scorePopup,
              child: Icon(
                batOrBowl == 0 ? Icons.casino : Icons.sports_baseball,
                color: appThemeState.themeClass.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
