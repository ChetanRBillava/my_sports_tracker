import 'package:flutter/cupertino.dart';

import '../../../../core/constants/enums.dart';
import '../../../../data/models/player_mini_model.dart';
import '../../../../data/models/series_model.dart';

abstract class MatchScreenEvent {}

class MatchInitEvent extends MatchScreenEvent {
  final BuildContext context;
  final int index;
  final SeriesModel series;

  MatchInitEvent({
    required this.context,
    required this.index,
    required this.series,
  });
}

class MatchConfirmTeamEvent extends MatchScreenEvent {
  final BuildContext context;
  final List<List<PlayerMiniModel>> teams;

  MatchConfirmTeamEvent({required this.context, required this.teams});
}

class MatchTossEvent extends MatchScreenEvent {
  final BuildContext context;
  final int tossWonBy;
  final int batOrBowl;

  MatchTossEvent({
    required this.context,
    required this.tossWonBy,
    required this.batOrBowl,
  });
}

class MatchUpdatePlayerEvent extends MatchScreenEvent {
  final BuildContext context;
  final int batterIndex, bowlerIndex;

  MatchUpdatePlayerEvent({
    required this.context,
    required this.batterIndex,
    required this.bowlerIndex,
  });
}

class MatchAddPlayerEvent extends MatchScreenEvent {
  final BuildContext context;
  final PlayerMiniModel player;
  final int teamNum;

  MatchAddPlayerEvent({
    required this.context,
    required this.player,
    required this.teamNum,
  });
}

class MatchUpdateScoreEvent extends MatchScreenEvent {
  final BuildContext context;
  final String score;

  MatchUpdateScoreEvent({required this.context, required this.score});
}

class RevertScoreEvent extends MatchScreenEvent {
  final BuildContext context;

  RevertScoreEvent({required this.context});
}

class ConcludeInningsEvent extends MatchScreenEvent {
  final BuildContext context;
  ConcludeInningsEvent({required this.context});
}

class AddNewMatchEvent extends MatchScreenEvent {
  final BuildContext context;
  AddNewMatchEvent({required this.context});
}
