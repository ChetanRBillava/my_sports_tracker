import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sports_tracker/data/models/player_mini_model.dart';
import 'package:my_sports_tracker/data/models/player_model.dart';
import 'package:my_sports_tracker/data/models/series_model.dart';
import 'package:my_sports_tracker/presentation/screens/home/logic/home_screen_bloc.dart';
import 'package:my_sports_tracker/presentation/screens/home/logic/home_screen_state.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../core/constants/enums.dart';
import '../../../../logics/cubits/app_theme_cubit.dart';
import '../../../utils/custom_print.dart';
import '../../match/screens/match_screen.dart';
import '../logic/home_screen_event.dart';
import '../widgets/player_tile_widget.dart';
import '../widgets/series_tile_widget.dart';
import '../widgets/statistics_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  UiUtilityPackage uiUtilityPackage = UiUtilityPackage();
  CustomPrint customPrint = CustomPrint();
  bool isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AppThemeCubit>().checkTheme();
    });
    super.initState();
  }

  @override
  Future<void> didChangePlatformBrightness() async {
    final cubit = context.read<AppThemeCubit>();
    // TODO: implement didChangePlatformBrightness
    customPrint.print(message: 'Updating brightness');
    final Brightness currentBrightness =
        SchedulerBinding.instance.window.platformBrightness;

    if (mounted) {
      String userTheme = await cubit.getThemeType();
      customPrint.print(message: 'User theme $userTheme');
      if (userTheme == 'auto') {
        customPrint.print(message: 'Brightness changed $currentBrightness');
        if (currentBrightness == Brightness.light) {
          cubit.setLightTheme(userTheme);
        } else {
          cubit.setDarkTheme(userTheme);
        }
      }
    }
    super.didChangePlatformBrightness();
  }

  List<Widget> _widgetOptions({
    required HomeScreenState state,
    required Color textColor,
    required Color cardBackgroundColor,
    required Color whiteColor,
  }) {
    return [
      ///Players Widgets
      state.players.isEmpty
          ? emptyStateWidget(message: 'No Players Added', textColor: textColor)
          : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: state.players.length,
            itemBuilder: (context, index) {
              return playerTileWidget(
                index: index,
                player: state.players[index],
              );
            },
          ),

      ///Series Widgets
      ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: state.series.length,
        itemBuilder: (context, index) {
          final reverseIndex = state.series.length - 1 - index;
          final match = state.series[reverseIndex];
          return seriesTileWidget(
            index: reverseIndex,
            onTap: () => makeTeam(series: state.series[reverseIndex]),
            onDoubleTap: () {},
            series: match,
          );
        },
      ),

      ///Statistics Widgets
      ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: uiUtilityPackage.customDropdown(
              backgroundColor: cardBackgroundColor,
              value: state.selectedFilterIndex,
              hint: uiUtilityPackage.customText(
                text: 'Select a filter from dropdown...',
                fontSize: TextSize.medium,
                overrideColor: whiteColor,
              ),
              iconEnabledColor: whiteColor,
              items:
                  List<int>.generate(state.statFilters.length, (i) => i)
                      .map(
                        (zone) => DropdownMenuItem(
                          value: zone,
                          child: uiUtilityPackage.customText(
                            text:
                                '${state.statFilters[zone].monthName?.toUpperCase()}${zone == 0 ? '' : ' - ${state.statFilters[zone].year?.toUpperCase()}'}',
                            fontSize: TextSize.subTitle,
                            overrideColor: whiteColor,
                          ),
                        ),
                      )
                      .toList(),
              onChanged:
                  (v) => context.read<HomeScreenBloc>().add(
                    ToggleFilterEvent(index: v),
                  ),
            ),
          ),

          ListView.builder(
            itemCount: state.statTiles.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return statisticsTileWidget(
                statisticsTileModel: state.statTiles[index],
              );
            },
          ),
        ],
      ),

      ///Achievements Widgets
      emptyStateWidget(
        message: 'No Player Achievements Added',
        textColor: textColor,
      ),
    ];
  }

  Center emptyStateWidget({required String message, required Color textColor}) {
    return Center(
      child: uiUtilityPackage.customText(
        text: message,
        fontSize: TextSize.medium,
        overrideColor: textColor,
      ),
    );
  }

  Future<void> addPlayer() async {
    TextEditingController textEditingController = TextEditingController();
    final cubit = context.read<AppThemeCubit>();
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

      uiUtilityPackage.showCustomDialog(
        backgroundColor: dialogBackground,
        context: context,
        title: 'Add New Player',
        overrideTitleTextColor: textColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            uiUtilityPackage.customTextField(
              hintText: 'Enter player name...',
              controller: textEditingController,
              context: context,
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
            buttonText: 'Add',
            overrideTextColor: textColor,
            onTap: () {
              context.read<HomeScreenBloc>().add(
                AddPlayerEvent(name: textEditingController.text),
              );

              uiUtilityPackage.showCustomSnackBar(
                backgroundColor: buttonColor,
                context: context,
                content: uiUtilityPackage.customText(
                  text: 'Added new player: ${textEditingController.text}',
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

  Future<void> addSeries() async {
    final cubit = context.read<AppThemeCubit>();
    final List<PlayerModel> players =
            context.read<HomeScreenBloc>().state.players,
        selectedPlayers = [];
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

      uiUtilityPackage.showCustomDialog(
        backgroundColor: dialogBackground,
        context: context,
        title: 'Create New Series',
        overrideTitleTextColor: textColor,
        content: StatefulBuilder(
          builder: (context, setThisState) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  players.map<Widget>((player) {
                    bool isSelected = selectedPlayers.any((p) => p == player);

                    return uiUtilityPackage.customChip(
                      label: player.name,
                      chipSelected: isSelected,
                      onSelected: (selected) {
                        setThisState(() {
                          if (isSelected) {
                            selectedPlayers.removeWhere((p) => p == player);
                          } else {
                            selectedPlayers.add(player);
                          }
                        });
                      },
                    );
                  }).toList(),
            );
          },
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
            buttonText: 'Save',
            overrideTextColor: textColor,
            onTap: () {
              context.read<HomeScreenBloc>().add(
                AddSeriesEvent(players: selectedPlayers),
              );
              uiUtilityPackage.showCustomSnackBar(
                backgroundColor: buttonColor,
                context: context,
                content: uiUtilityPackage.customText(
                  text:
                      'Added players: ${selectedPlayers.isEmpty ? "" : selectedPlayers.map((p) => p.name).join(', ')}',
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

  Future<void> makeTeam({required SeriesModel series}) async {
    List<List<PlayerMiniModel>> teams = [];
    final cubit = context.read<AppThemeCubit>();
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
      showModalBottomSheet(
        context: context,
        backgroundColor: dialogBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, makeTeamPopupState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        uiUtilityPackage.customText(
                          text:
                              teams.isEmpty ? "Make team" : "The Teams are...",
                          fontSize: TextSize.title,
                          overrideColor: textColor,
                        ),
                        teams.isEmpty
                            ? SizedBox.shrink()
                            : Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.9,
                                      child: uiUtilityPackage.customText(
                                        text:
                                            "Team 1: ${teams.isEmpty ? "" : teams[0].map((p) => p.name).join(', ')}",
                                        fontSize: TextSize.medium,
                                        overrideColor: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.9,
                                      child: uiUtilityPackage.customText(
                                        text:
                                            "Team 2: ${teams.isEmpty ? "" : teams[1].map((p) => p.name).join(', ')}",
                                        fontSize: TextSize.medium,
                                        overrideColor: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        const SizedBox(height: 12),
                        teams.isEmpty
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                uiUtilityPackage.customButton(
                                  buttonText: 'MAKE TEAM',
                                  buttonColor: buttonColor,
                                  overrideTextColor: textColor,
                                  onTap: () {
                                    makeTeamPopupState(() {
                                      teams = makeTeamFunction(
                                        players: series.players,
                                      );
                                    });
                                  },
                                ),
                              ],
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                uiUtilityPackage.customButton(
                                  buttonText: 'REMAKE TEAM',
                                  buttonColor: buttonColor,
                                  overrideTextColor: textColor,
                                  onTap: () {
                                    makeTeamPopupState(() {
                                      teams = makeTeamFunction(
                                        players: series.players,
                                      );
                                    });
                                  },
                                ),
                                uiUtilityPackage.customButton(
                                  buttonText: 'CONFIRM TEAMS',
                                  buttonColor: buttonColor,
                                  overrideTextColor: textColor,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MatchScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  List<List<PlayerMiniModel>> makeTeamFunction({
    required List<PlayerMiniModel> players,
  }) {
    CustomPrint customPrint = CustomPrint();
    List<PlayerMiniModel> tempPlayers = players.toList();
    List<List<PlayerMiniModel>> teams = [];

    tempPlayers.shuffle(Random());
    customPrint.print(message: 'All players: $tempPlayers');
    int halfIndex = (tempPlayers.length / 2).ceil();

    teams.add(tempPlayers.sublist(0, halfIndex));
    teams.add(tempPlayers.sublist(halfIndex));
    customPrint.print(message: 'First team: ${teams[0]}');
    customPrint.print(message: 'Second team: ${teams[1]}');
    return teams;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeState>(
      builder: (context, appThemeState) {
        return BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (context, homeScreenState) {
            return Scaffold(
              backgroundColor: appThemeState.themeClass.backgroundColor,
              appBar: AppBar(
                backgroundColor: appThemeState.themeClass.appbarBackgroundColor,
                title: uiUtilityPackage.customText(
                  text: 'Home Screen ',
                  fontSize: TextSize.title,
                  overrideColor: appThemeState.themeClass.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              body:
                  isLoading
                      ? CircularProgressIndicator()
                      : _widgetOptions(
                        state: homeScreenState,
                        textColor: appThemeState.themeClass.textColor_1,
                        cardBackgroundColor:
                            appThemeState.themeClass.cardBackgroundColor,
                        whiteColor: appThemeState.themeClass.white,
                      )[homeScreenState.selectedBottomBarIndex],
              bottomNavigationBar: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    backgroundColor:
                        appThemeState.themeClass.appbarBackgroundColor,
                    icon: Icon(Icons.person),
                    label: 'Players',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor:
                        appThemeState.themeClass.appbarBackgroundColor,
                    icon: Icon(Icons.sports_cricket),
                    label: 'Series',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor:
                        appThemeState.themeClass.appbarBackgroundColor,
                    icon: Icon(Icons.leaderboard),
                    label: 'Statistics',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor:
                        appThemeState.themeClass.appbarBackgroundColor,
                    icon: Icon(Icons.emoji_events),
                    label: 'Achievements',
                  ),
                ],
                currentIndex: homeScreenState.selectedBottomBarIndex,
                selectedItemColor: appThemeState.themeClass.white,
                unselectedItemColor: appThemeState.themeClass.textCaptionColor,
                onTap:
                    (index) => context.read<HomeScreenBloc>().add(
                      ToggleBottomBarEvent(index: index),
                    ),
              ),
              floatingActionButton:
                  homeScreenState.selectedBottomBarIndex == 2
                      ? null
                      : FloatingActionButton(
                        backgroundColor:
                            appThemeState.themeClass.buttonBackgroundColor,
                        onPressed:
                            homeScreenState.selectedBottomBarIndex == 0
                                ? addPlayer
                                : addSeries,
                        tooltip: 'Add',
                        child: Icon(
                          Icons.add,
                          color: appThemeState.themeClass.white,
                        ),
                      ),
            );
          },
        );
      },
    );
  }
}
