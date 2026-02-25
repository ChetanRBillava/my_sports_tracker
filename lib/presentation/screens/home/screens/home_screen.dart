import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../core/constants/enums.dart';
import '../../../../logics/cubits/app_theme_cubit.dart';
import '../../../utils/custom_print.dart';
import '../../match/screens/match_screen.dart';
import '../models/statistics_tile_model.dart';
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
  int _selectedIndex = 1;
  bool isLoading = false;
  String? selectedFilter;
  List<String> dropdownValues = ['All time stats', 'January', 'February'];
  List<String> players = ['ABC', 'MNO', 'XYZ', 'PQR', 'STU', 'IJK', 'DEF'];
  List<String> selectedPlayers = [];
  List<StatisticsTileModel> stats = [
    StatisticsTileModel(
      title: 'Match Statistics',
      stats: [
        Stat(
          title: 'Most Wins',
          type: 'wins',
          players: ['ABC', 'MNO', 'XYZ', 'PQR', 'STU'],
        ),
        Stat(
          title: 'Most MOTM',
          type: 'motm',
          players: ['ABC', 'MNO', 'XYZ', 'PQR', 'STU'],
        ),
      ],
    ),
    StatisticsTileModel(
      title: 'Batting Statistics',
      stats: [
        Stat(
          title: 'Most Runs',
          type: 'runs',
          players: ['ABC', 'MNO', 'XYZ', 'PQR', 'STU'],
        ),
        Stat(
          title: 'Most 6s',
          type: '6s',
          players: ['ABC', 'MNO', 'XYZ', 'PQR', 'STU'],
        ),
      ],
    ),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<AppThemeCubit>(context).checkTheme();
    });
    super.initState();
  }

  @override
  Future<void> didChangePlatformBrightness() async {
    // TODO: implement didChangePlatformBrightness
    customPrint.print(message: 'Updating brightness');
    final Brightness currentBrightness =
        SchedulerBinding.instance.window.platformBrightness;

    String userTheme =
        await BlocProvider.of<AppThemeCubit>(context).getThemeType();
    customPrint.print(message: 'User theme $userTheme');
    if (userTheme == 'auto') {
      customPrint.print(message: 'Brightness changed $currentBrightness');
      if (currentBrightness == Brightness.light) {
        BlocProvider.of<AppThemeCubit>(context).setLightTheme(userTheme);
      } else {
        BlocProvider.of<AppThemeCubit>(context).setDarkTheme(userTheme);
      }
    }
    super.didChangePlatformBrightness();
  }

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _widgetOptions {
    return [
      ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return playerTileWidget(index: index);
        },
      ),
      ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return seriesTileWidget(
            index: index,
            onTap: makeTeam,
            onDoubleTap: () {},
          );
        },
      ),
      SingleChildScrollView(
        child: BlocBuilder<AppThemeCubit, AppThemeState>(
          builder: (context, appThemeState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: uiUtilityPackage.customDropdown(
                    backgroundColor:
                        appThemeState.themeClass.cardBackgroundColor,
                    value: selectedFilter,
                    hint: uiUtilityPackage.customText(
                      text: 'Select a filter from dropdown...',
                      fontSize: TextSize.medium,
                      overrideColor: appThemeState.themeClass.white,
                    ),
                    iconEnabledColor: appThemeState.themeClass.white,
                    items:
                        List<int>.generate(dropdownValues.length, (i) => i)
                            .map(
                              (zone) => DropdownMenuItem(
                                value: dropdownValues[zone],
                                child: uiUtilityPackage.customText(
                                  text: dropdownValues[zone],
                                  fontSize: TextSize.subTitle,
                                  overrideColor: appThemeState.themeClass.white,
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFilter = value;
                      });
                    },
                  ),
                ),

                ListView.builder(
                  itemCount: stats.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return statisticsTileWidget(
                      statisticsTileModel: stats[index],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
      BlocBuilder<AppThemeCubit, AppThemeState>(
        builder: (context, state) {
          return Center(
            child: uiUtilityPackage.customText(
              text: 'Player Achievements',
              fontSize: TextSize.medium,
              overrideColor: state.themeClass.textColor_1,
            ),
          );
        },
      ),
    ];
  }

  Future<void> addPlayer() async {
    TextEditingController textEditingController = TextEditingController();
    Color dialogBackground = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.cardBackgroundColor);
    Color textColor = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.white);
    Color buttonColor = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.buttonBackgroundColor);

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

  Future<void> addSeries() async {
    Color dialogBackground = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.cardBackgroundColor);
    Color textColor = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.white);
    Color buttonColor = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.buttonBackgroundColor);
    selectedPlayers = [];

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
                    label: player,
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
            uiUtilityPackage.showCustomSnackBar(
              backgroundColor: buttonColor,
              context: context,
              content: uiUtilityPackage.customText(
                text: 'Added players: $selectedPlayers',
                fontSize: TextSize.medium,
              ),
            );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Future<void> makeTeam() async {
    Color dialogBackground = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.cardBackgroundColor);
    Color textColor = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.white);
    Color buttonColor = await BlocProvider.of<AppThemeCubit>(
      context,
    ).getColor(color: AppColors.buttonBackgroundColor);
    List<List<String>> teams = [];
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
                        text: teams.isEmpty ? "Make team" : "The Teams are...",
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
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: uiUtilityPackage.customText(
                                      text:
                                          "Team 1: ${teams.isEmpty ? "" : teams[0].map((p) => p).join(', ')}",
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
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: uiUtilityPackage.customText(
                                      text:
                                          "Team 2: ${teams.isEmpty ? "" : teams[1].map((p) => p).join(', ')}",
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
                                    teams = makeTeamFunction();
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
                                    teams = makeTeamFunction();
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

  List<List<String>> makeTeamFunction() {
    CustomPrint customPrint = CustomPrint();
    List<String> tempPlayers = players.toList();
    List<List<String>> teams = [];

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
                  : _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: appThemeState.themeClass.appbarBackgroundColor,
                icon: Icon(Icons.person),
                label: 'Players',
              ),
              BottomNavigationBarItem(
                backgroundColor: appThemeState.themeClass.appbarBackgroundColor,
                icon: Icon(Icons.sports_cricket),
                label: 'Series',
              ),
              BottomNavigationBarItem(
                backgroundColor: appThemeState.themeClass.appbarBackgroundColor,
                icon: Icon(Icons.leaderboard),
                label: 'Statistics',
              ),
              BottomNavigationBarItem(
                backgroundColor: appThemeState.themeClass.appbarBackgroundColor,
                icon: Icon(Icons.emoji_events),
                label: 'Achievements',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: appThemeState.themeClass.white,
            unselectedItemColor: appThemeState.themeClass.textCaptionColor,
            onTap: _onItemTapped,
          ),
          floatingActionButton:
              _selectedIndex == 2
                  ? null
                  : FloatingActionButton(
                    backgroundColor:
                        appThemeState.themeClass.buttonBackgroundColor,
                    onPressed: _selectedIndex == 0 ? addPlayer : addSeries,
                    tooltip: 'Add',
                    child: Icon(
                      Icons.add,
                      color: appThemeState.themeClass.white,
                    ),
                  ),
        );
      },
    );
  }
}
