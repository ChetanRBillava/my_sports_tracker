import 'package:my_sports_tracker/data/models/player_model.dart';

import '../../../../core/constants/enums.dart';

abstract class HomeScreenEvent {}

class InitEvent extends HomeScreenEvent {}

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
