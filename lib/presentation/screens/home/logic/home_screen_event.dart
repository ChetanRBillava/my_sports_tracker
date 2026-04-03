import 'package:my_sports_tracker/data/models/player_models/player/player_model.dart';
import 'package:my_sports_tracker/data/models/match_models/series/series_model.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../data/models/player_models/player_mini/player_mini_model.dart';

abstract class HomeScreenEvent {}

class InitEvent extends HomeScreenEvent {}

class ImportDataEvent extends HomeScreenEvent {
  String importString;
  bool isPlayerData;

  ImportDataEvent({required this.importString, required this.isPlayerData});
}

class ToggleBottomBarEvent extends HomeScreenEvent {
  final int index;

  ToggleBottomBarEvent({required this.index});
}

class ToggleFilterEvent extends HomeScreenEvent {
  final int index;

  ToggleFilterEvent({required this.index});
}

class AddPlayerEvent extends HomeScreenEvent {
  final String name;

  AddPlayerEvent({required this.name});
}

class AddSeriesEvent extends HomeScreenEvent {
  final List<PlayerModel> players;

  AddSeriesEvent({required this.players});
}

class UpdateMainFlagEvent extends HomeScreenEvent {
  final String flag;

  UpdateMainFlagEvent({required this.flag});
}

class UpdateSubFlagEvent extends HomeScreenEvent {
  final StatTileEnums flag;

  UpdateSubFlagEvent({required this.flag});
}

class UpdatePlayerStatsEvent extends HomeScreenEvent {
  final PlayerMiniModel player;
  final PlayerType type;
  final String activity;
  final bool revert;

  UpdatePlayerStatsEvent({
    required this.player,
    required this.type,
    required this.activity,
    this.revert = false,
  });
}

class UpdateAndStoreDataEvent extends HomeScreenEvent {
  final int seriesId;
  final SeriesModel series;

  UpdateAndStoreDataEvent({required this.seriesId, required this.series});
}
