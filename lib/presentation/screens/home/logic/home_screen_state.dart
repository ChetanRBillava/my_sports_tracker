import 'package:my_sports_tracker/data/models/series_model.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/constants/enums.dart';
import '../../../../data/models/player_model.dart';
import '../../../../data/models/stat_filter_model.dart';
import '../models/statistics_tile_model.dart';

class HomeScreenState {
  final int selectedBottomBarIndex, selectedFilterIndex;
  final List<PlayerModel> players;
  final List<SeriesModel> series;
  final List<StatFilterModel> statFilters;
  final List<StatisticsTileModel> statTiles;
  final Map<String, bool> mainStatTileFlags;
  final Map<StatTileEnums, bool> subStatTileFlags;
  final Map<String, ScreenshotController> screenshotControllers;

  const HomeScreenState({
    required this.selectedBottomBarIndex,
    required this.selectedFilterIndex,
    required this.players,
    required this.series,
    required this.statFilters,
    required this.statTiles,
    required this.mainStatTileFlags,
    required this.subStatTileFlags,
    this.screenshotControllers = const {},
  });

  HomeScreenState init() {
    return HomeScreenState(
      selectedBottomBarIndex: 1,
      selectedFilterIndex: 0,
      players: [],
      series: [],
      statFilters: [],
      statTiles: [],
      mainStatTileFlags: {},
      subStatTileFlags: {},
      screenshotControllers: {},
    );
  }

  HomeScreenState copyWith({
    int? selectedBottomBarIndex,
    int? selectedFilterIndex,
    List<PlayerModel>? players,
    List<SeriesModel>? series,
    List<StatFilterModel>? statFilters,
    List<StatisticsTileModel>? statTiles,
    Map<String, bool>? mainStatTileFlags,
    Map<StatTileEnums, bool>? subStatTileFlags,
    Map<String, ScreenshotController>? screenshotControllers,
  }) {
    return HomeScreenState(
      selectedBottomBarIndex:
          selectedBottomBarIndex ?? this.selectedBottomBarIndex,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      players: players ?? this.players,
      series: series ?? this.series,
      statFilters: statFilters ?? this.statFilters,
      statTiles: statTiles ?? this.statTiles,
      mainStatTileFlags: mainStatTileFlags ?? this.mainStatTileFlags,
      subStatTileFlags: subStatTileFlags ?? this.subStatTileFlags,
      screenshotControllers:
          screenshotControllers ?? this.screenshotControllers,
    );
  }

  List<Object?> get props => [
    selectedBottomBarIndex,
    selectedFilterIndex,
    players,
    series,
    statFilters,
    statTiles,
    mainStatTileFlags,
    subStatTileFlags,
    screenshotControllers,
  ];
}
