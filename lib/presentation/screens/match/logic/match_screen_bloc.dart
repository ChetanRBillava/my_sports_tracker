import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sports_tracker/data/models/statistic_models/batting/batting_model.dart';
import 'package:my_sports_tracker/data/models/match_models/inning/inning_model.dart';
import 'package:my_sports_tracker/data/models/player_models/player_mini/player_mini_model.dart';
import 'package:my_sports_tracker/data/models/match_models/series/series_model.dart';
import 'package:my_sports_tracker/presentation/screens/home/logic/home_screen_bloc.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../data/models/match_models/over/over_model.dart';
import '../../../../data/models/statistic_models/bowling/bowling_model.dart';
import '../../../../data/models/match_models/match/match_model.dart';
import '../../../../data/models/statistic_models/man_of_the_match/man_of_the_match_model.dart';
import '../../../../data/models/statistic_models/match_stats/match_stats_model.dart';
import '../../../router/AppRouter.dart';
import '../../../utils/custom_print.dart';
import '../../home/logic/home_screen_event.dart';
import 'match_screen_event.dart';
import 'match_screen_state.dart';

class MatchScreenBloc extends Bloc<MatchScreenEvent, MatchScreenState> {
  CustomPrint customPrint = CustomPrint();
  MatchScreenBloc()
    : super(
        MatchScreenState(
          seriesIndex: 0,
          matchIndex: 0,
          inningsIndex: 0,
          overIndex: 0,
          updateLineup: false,
        ),
      ) {
    on<MatchInitEvent>(init);
    on<MatchConfirmTeamEvent>(confirmTeam);
    on<MatchTossEvent>(updateToss);
    on<MatchUpdatePlayerEvent>(updatePlayer);
    on<MatchAddPlayerEvent>(addPlayer);
    on<MatchUpdateScoreEvent>(updateScore);
    on<RevertScoreEvent>(revertScore);
    on<ConcludeInningsEvent>(concludeInnings);
    on<AddNewMatchEvent>(addNewMatch);
  }

  void init(MatchInitEvent event, Emitter<MatchScreenState> emit) async {
    int matchIndex = state.matchIndex,
        inningsIndex = state.inningsIndex,
        overIndex = state.overIndex;
    bool updateLineup = false;
    SeriesModel seriesModel = event.series;
    if (seriesModel.matches.isNotEmpty) {
      matchIndex = seriesModel.matches.length - 1;
      MatchModel matchModel = seriesModel.matches[matchIndex];
      if (matchModel.innings.isNotEmpty) {
        inningsIndex = matchModel.innings.length - 1;
        InningModel inningModel = matchModel.innings[inningsIndex];
        if (inningModel.overs.isNotEmpty) {
          overIndex = inningModel.overs.length - 1;
        }
        if (inningModel.currentBatsman == 999 ||
            inningModel.currentBowler == 999) {
          updateLineup = true;
        }
      }
    }

    customPrint.print(
      message:
          'Initialised Match index: $matchIndex, Innings index: $inningsIndex, Over index: $overIndex',
    );
    emit(
      state.copyWith(
        seriesIndex: event.index,
        matchIndex: matchIndex,
        inningsIndex: inningsIndex,
        overIndex: overIndex,
        series: event.series,
        updateLineup: updateLineup,
      ),
    );
  }

  Future<SeriesModel> getSeries() async {
    return state.series!;
  }

  void confirmTeam(
    MatchConfirmTeamEvent event,
    Emitter<MatchScreenState> emit,
  ) {
    SeriesModel seriesModel = state.series!;

    seriesModel.team1 = event.teams[0];
    seriesModel.team2 = event.teams[1];
    int maxBalls = event.teams[0].length;
    if (event.teams[1].length > maxBalls) {
      maxBalls = event.teams[1].length;
    }

    seriesModel.matches.add(
      MatchModel(
        team1: event.teams[0],
        team2: event.teams[1],
        innings: [],
        toss: 999,
        batOrBowl: 999,
        wonBy: 999,
        maxBalls: maxBalls * 6,
        stats: MatchStatsModel(),
      ),
    );

    emit(state.copyWith(series: seriesModel, matchIndex: 0));
    AppRouter.navigateTo(routeName: AppRouter.match, context: event.context);

    event.context.read<HomeScreenBloc>().add(
      UpdateAndStoreDataEvent(series: seriesModel, seriesId: state.seriesIndex),
    );
  }

  void updateToss(MatchTossEvent event, Emitter<MatchScreenState> emit) async {
    SeriesModel seriesModel = state.series!;
    MatchModel matchModel = seriesModel.matches[state.matchIndex];

    matchModel.toss = event.tossWonBy;
    matchModel.batOrBowl = event.batOrBowl;
    int currentBattingTeam = 0;
    if ((event.tossWonBy == 1 && event.batOrBowl == 1) ||
        (event.tossWonBy == 2 && event.batOrBowl == 2)) {
      currentBattingTeam = 1;
    } else {
      currentBattingTeam = 2;
    }

    matchModel.innings.add(
      InningModel(
        currentBattingTeam: currentBattingTeam,
        currentBatsman: 999,
        currentBowler: 999,
        totalRuns: 0,
        totalWickets: 0,
        totalBalls: 0,
        overs: [OverModel(bowlers: [], over: [])],
        batting: [],
        bowling: [],
        superOver: false,
      ),
    );

    if (currentBattingTeam == 1) {
      for (var player in matchModel.team1) {
        matchModel.innings[0].batting.add(
          BattingModel(
            player: player,
            runs: 0,
            balls: 0,
            fours: 0,
            sixes: 0,
            strikeRate: 0,
            out: false,
          ),
        );
      }
      for (var player in matchModel.team2) {
        matchModel.innings[0].bowling.add(
          BowlingModel(
            player: player,
            runs: 0,
            balls: 0,
            wickets: 0,
            wides: 0,
            noBalls: 0,
          ),
        );
      }
    } else {
      for (var player in matchModel.team2) {
        matchModel.innings[0].batting.add(
          BattingModel(
            player: player,
            runs: 0,
            balls: 0,
            fours: 0,
            sixes: 0,
            strikeRate: 0,
            out: false,
          ),
        );
      }
      for (var player in matchModel.team1) {
        matchModel.innings[0].bowling.add(
          BowlingModel(
            player: player,
            runs: 0,
            balls: 0,
            wickets: 0,
            wides: 0,
            noBalls: 0,
          ),
        );
      }
    }

    seriesModel.matches[state.matchIndex] = matchModel;

    emit(state.copyWith(series: seriesModel, inningsIndex: 0, overIndex: 0));

    event.context.read<HomeScreenBloc>().add(
      UpdateAndStoreDataEvent(series: seriesModel, seriesId: state.seriesIndex),
    );
  }

  Future<int> getTossValue() async {
    return state.series!.matches[state.matchIndex].toss;
  }

  Future<int> getBatOrBowl() async {
    return state.series!.matches[state.matchIndex].batOrBowl;
  }

  Future<int> getOversCount() async {
    return (state.series!.matches[state.matchIndex].maxBalls / 6).floor();
  }

  Future<List<PlayerMiniModel>> getTeam({required int teamNum}) async {
    List<PlayerMiniModel> team = [];
    if (teamNum == 1) {
      state.series?.matches[state.matchIndex].team1.forEach((p) {
        team.add(p);
      });
    } else {
      state.series?.matches[state.matchIndex].team2.forEach((p) {
        team.add(p);
      });
    }
    return team;
  }

  Future<List<BattingModel>> getBatters() async {
    customPrint.print(message: 'Current inning index: ${state.inningsIndex}');
    if (state.series!.matches[state.matchIndex].innings.isNotEmpty) {
      return state
              .series
              ?.matches[state.matchIndex]
              .innings[state.inningsIndex]
              .batting ??
          [];
    }
    return [];
  }

  Future<List<BowlingModel>> getBowlers() async {
    if (state.series!.matches[state.matchIndex].innings.isNotEmpty) {
      return state
              .series
              ?.matches[state.matchIndex]
              .innings[state.inningsIndex]
              .bowling ??
          [];
    }
    return [];
  }

  Future<PlayerMiniModel?> getCurrentBatsman() async {
    PlayerMiniModel? batter;
    int currentBatterId =
        state
            .series!
            .matches[state.matchIndex]
            .innings[state.inningsIndex]
            .currentBatsman;
    customPrint.print(message: 'Current batter ID: $currentBatterId');
    if (currentBatterId != 999) {
      batter =
          state
              .series!
              .matches[state.matchIndex]
              .innings[state.inningsIndex]
              .batting[currentBatterId]
              .player;
    }
    return batter;
  }

  Future<PlayerMiniModel?> getCurrentBowler() async {
    PlayerMiniModel? bowler;
    int currentBowlerId =
        state
            .series!
            .matches[state.matchIndex]
            .innings[state.inningsIndex]
            .currentBowler;

    if (currentBowlerId != 999) {
      bowler =
          state
              .series!
              .matches[state.matchIndex]
              .innings[state.inningsIndex]
              .bowling[currentBowlerId]
              .player;
    }
    return bowler;
  }

  Future<bool> checkSuperOver() async {
    bool superOver = false;
    try {
      if (state
              .series
              ?.matches[state.matchIndex]
              .innings[state.inningsIndex]
              .superOver ==
          true) {
        superOver = true;
      }
      return superOver;
    } catch (e) {
      return superOver;
    }
  }

  void updatePlayer(
    MatchUpdatePlayerEvent event,
    Emitter<MatchScreenState> emit,
  ) {
    SeriesModel seriesModel = state.series!;
    MatchModel matchModel = seriesModel.matches[state.matchIndex];
    InningModel inningModel = matchModel.innings[state.inningsIndex];

    inningModel.currentBatsman = event.batterIndex;
    inningModel.currentBowler = event.bowlerIndex;
    inningModel.overs[state.overIndex].bowlers.add(
      inningModel.bowling[event.bowlerIndex].player,
    );

    matchModel.innings[state.inningsIndex] = inningModel;
    seriesModel.matches[state.matchIndex] = matchModel;

    emit(state.copyWith(series: seriesModel, updateLineup: false));

    event.context.read<HomeScreenBloc>().add(
      UpdateAndStoreDataEvent(series: seriesModel, seriesId: state.seriesIndex),
    );
  }

  void addPlayer(MatchAddPlayerEvent event, Emitter<MatchScreenState> emit) {
    SeriesModel seriesModel = state.series!;
    MatchModel matchModel = seriesModel.matches[state.matchIndex];
    InningModel inningModel = matchModel.innings[state.inningsIndex];
    List<PlayerMiniModel> team = [];

    if (event.teamNum == 1) {
      for (var t in seriesModel.team1) {
        team.add(t);
      }
      team.add(event.player);
      seriesModel.team1 = team;
      matchModel.team1 = team;
    } else {
      for (var t in seriesModel.team2) {
        team.add(t);
      }
      team.add(event.player);
      seriesModel.team2 = team;
      matchModel.team2 = team;
    }

    if ((event.teamNum == 1 && inningModel.currentBattingTeam == 1) ||
        (event.teamNum == 2 && inningModel.currentBattingTeam == 2)) {
      inningModel.batting.add(
        BattingModel(
          player: event.player,
          runs: 0,
          balls: 0,
          fours: 0,
          sixes: 0,
          strikeRate: 0,
          out: false,
        ),
      );
    } else {
      inningModel.bowling.add(
        BowlingModel(
          player: event.player,
          runs: 0,
          balls: 0,
          wickets: 0,
          wides: 0,
          noBalls: 0,
        ),
      );
    }

    int maxBalls = seriesModel.team1.length;
    if (seriesModel.team2.length > maxBalls) {
      maxBalls = seriesModel.team2.length;
    }
    matchModel.maxBalls = maxBalls * 6;

    matchModel.innings[state.inningsIndex] = inningModel;
    seriesModel.matches[state.matchIndex] = matchModel;

    emit(state.copyWith(series: seriesModel));

    event.context.read<HomeScreenBloc>().add(
      UpdateAndStoreDataEvent(series: seriesModel, seriesId: state.seriesIndex),
    );
  }

  void updateScore(
    MatchUpdateScoreEvent event,
    Emitter<MatchScreenState> emit,
  ) {
    bool updateLineup = false;
    customPrint.print(message: 'Updating score: ${event.score}');
    SeriesModel seriesModel = state.series!;
    int inningsIndex = state.inningsIndex,
        matchIndex = state.matchIndex,
        overIndex = state.overIndex;
    MatchModel matchModel = seriesModel.matches[matchIndex];
    InningModel inningModel = matchModel.innings[inningsIndex];

    if (['0', '2', '4', '6'].contains(event.score)) {
      inningModel.totalRuns += int.parse(event.score);
      inningModel.totalBalls += 1;

      inningModel.batting[inningModel.currentBatsman].runs += int.parse(
        event.score,
      );
      inningModel.bowling[inningModel.currentBowler].runs += int.parse(
        event.score,
      );

      inningModel.batting[inningModel.currentBatsman].balls += 1;
      inningModel.bowling[inningModel.currentBowler].balls += 1;

      if (event.score == '4') {
        inningModel.batting[inningModel.currentBatsman].fours += 1;
      } else if (event.score == '6') {
        inningModel.batting[inningModel.currentBatsman].sixes += 1;
      }
    } else if (event.score == 'WD') {
      inningModel.totalRuns += 1;
      inningModel.bowling[inningModel.currentBowler].runs += 1;

      inningModel.bowling[inningModel.currentBowler].wides += 1;
    } else if (event.score.contains('NB')) {
      List<String> scores = event.score.split('+');
      int score = int.parse(scores[1]);
      inningModel.totalRuns += score + 1;

      inningModel.batting[inningModel.currentBatsman].runs += score;
      inningModel.bowling[inningModel.currentBowler].runs += score + 1;

      if (scores[1] == '4') {
        inningModel.batting[inningModel.currentBatsman].fours += 1;
      } else if (scores[1] == '6') {
        inningModel.batting[inningModel.currentBatsman].sixes += 1;
      }

      inningModel.bowling[inningModel.currentBowler].noBalls += 1;
    } else {
      inningModel.totalWickets += 1;
      inningModel.totalBalls += 1;
      inningModel.bowling[inningModel.currentBowler].wickets += 1;
      inningModel.bowling[inningModel.currentBowler].balls += 1;
      inningModel.batting[inningModel.currentBatsman].balls += 1;
      inningModel.batting[inningModel.currentBatsman].out = true;
      inningModel.currentBatsman == 999;
      updateLineup = true;
    }

    event.context.read<HomeScreenBloc>().add(
      UpdatePlayerStatsEvent(
        player: inningModel.batting[inningModel.currentBatsman].player,
        type: PlayerType.batter,
        activity: event.score,
      ),
    );

    event.context.read<HomeScreenBloc>().add(
      UpdatePlayerStatsEvent(
        player: inningModel.bowling[inningModel.currentBowler].player,
        type: PlayerType.bowler,
        activity: event.score,
      ),
    );

    inningModel.overs[inningModel.overs.length - 1].over.add(event.score);

    if (((inningModel.totalBalls != 0 && inningModel.totalBalls % 6 == 0) ||
            inningModel.bowling[inningModel.currentBowler].balls == 9) &&
        (inningModel.overs[overIndex].over.length > 5)) {
      if (inningModel.totalBalls < matchModel.maxBalls &&
          inningModel.totalBalls % 6 == 0) {
        inningModel.overs.add(OverModel(bowlers: [], over: []));
        overIndex += 1;
      }
      updateLineup = true;
    }
    customPrint.print(
      message:
          'Updating score: ${event.score}, current over: ${inningModel.overs[inningModel.overs.length - 1].over}',
    );

    if (matchModel.stats?.bestBatting == null) {
      matchModel.stats?.bestBatting =
          inningModel.batting[inningModel.currentBatsman];
    } else {
      if (matchModel.stats!.bestBatting!.runs <
          inningModel.batting[inningModel.currentBatsman].runs) {
        matchModel.stats?.bestBatting =
            inningModel.batting[inningModel.currentBatsman];
      }
    }

    if (matchModel.stats?.bestBowling == null) {
      matchModel.stats?.bestBowling =
          inningModel.bowling[inningModel.currentBowler];
    } else {
      if (matchModel.stats!.bestBowling!.wickets <
          inningModel.bowling[inningModel.currentBowler].wickets) {
        matchModel.stats?.bestBowling =
            inningModel.bowling[inningModel.currentBowler];
      } else if ((matchModel.stats!.bestBowling!.wickets ==
              inningModel.bowling[inningModel.currentBowler].wickets) &&
          (matchModel.stats!.bestBowling!.runs >
              inningModel.bowling[inningModel.currentBowler].runs)) {
        matchModel.stats?.bestBowling =
            inningModel.bowling[inningModel.currentBowler];
      }
    }

    matchModel.innings[inningsIndex] = inningModel;
    seriesModel.matches[matchIndex] = matchModel;

    if (inningsIndex == 3) {
      if (inningModel.totalRuns == matchModel.innings[2].totalRuns &&
          (inningModel.totalBalls == 6 || inningModel.totalWickets > 0)) {
        matchModel.wonBy = 3;
      } else if (inningModel.totalRuns > matchModel.innings[2].totalRuns) {
        matchModel.wonBy = matchModel.innings[0].currentBattingTeam - 1;
      } else if (inningModel.totalBalls == 6 || inningModel.totalWickets > 0) {
        matchModel.wonBy = matchModel.innings[1].currentBattingTeam - 1;
      }

      if (matchModel.wonBy != 2) {
        PlayerMiniModel? player;
        BattingModel? batting;
        BowlingModel? bowling;
        int bestRuns = matchModel.stats?.bestBatting?.runs ?? 0,
            bestWickets = matchModel.stats?.bestBowling?.wickets ?? 0;

        if (bestWickets * 15 > bestRuns) {
          player = matchModel.stats?.bestBowling?.player;
        } else {
          player = matchModel.stats?.bestBatting?.player;
        }

        for (var i in matchModel.innings) {
          for (var ba in i.batting) {
            if (ba.player == player) {
              batting = ba;
              break;
            }
          }
          for (var bo in i.bowling) {
            if (bo.player == player) {
              bowling = bo;
              break;
            }
          }
        }

        matchModel.stats?.manOfTheMatch = ManOfTheMatchModel(
          player: player,
          batting: batting,
          bowling: bowling,
        );

        seriesModel.matches[matchIndex] = matchModel;
      }
    } else if (inningsIndex == 2 &&
        (inningModel.totalBalls == 6 || inningModel.totalWickets > 0)) {
      List<BattingModel> batting = [];
      List<BowlingModel> bowling = [];

      if (matchModel.innings[0].currentBattingTeam == 1) {
        for (var player in matchModel.team1) {
          batting.add(
            BattingModel(
              player: player,
              runs: 0,
              balls: 0,
              fours: 0,
              sixes: 0,
              strikeRate: 0,
              out: false,
            ),
          );
        }
        for (var player in matchModel.team2) {
          bowling.add(
            BowlingModel(
              player: player,
              runs: 0,
              balls: 0,
              wickets: 0,
              wides: 0,
              noBalls: 0,
            ),
          );
        }
      } else {
        for (var player in matchModel.team2) {
          batting.add(
            BattingModel(
              player: player,
              runs: 0,
              balls: 0,
              fours: 0,
              sixes: 0,
              strikeRate: 0,
              out: false,
            ),
          );
        }
        for (var player in matchModel.team1) {
          bowling.add(
            BowlingModel(
              player: player,
              runs: 0,
              balls: 0,
              wickets: 0,
              wides: 0,
              noBalls: 0,
            ),
          );
        }
      }
      matchModel.innings.add(
        InningModel(
          currentBattingTeam: matchModel.innings[0].currentBattingTeam,
          currentBatsman: 999,
          currentBowler: 999,
          totalRuns: 0,
          totalWickets: 0,
          totalBalls: 0,
          overs: [OverModel(bowlers: [], over: [])],
          batting: batting,
          bowling: bowling,
          superOver: true,
        ),
      );

      inningsIndex += 1;
      overIndex = 0;
    } else if (inningsIndex == 1) {
      if (inningModel.totalRuns > matchModel.innings[0].totalRuns) {
        matchModel.wonBy = matchModel.innings[1].currentBattingTeam - 1;
      } else if ((inningModel.totalBalls == matchModel.maxBalls ||
              inningModel.totalWickets == inningModel.batting.length) &&
          inningModel.totalRuns < matchModel.innings[0].totalRuns) {
        matchModel.wonBy = matchModel.innings[0].currentBattingTeam - 1;
      } else if (inningModel.totalRuns == matchModel.innings[0].totalRuns &&
          (inningModel.totalBalls == matchModel.maxBalls ||
              inningModel.totalWickets == inningModel.batting.length)) {
        matchModel.wonBy = 2;
      }

      if (matchModel.wonBy == 2) {
        List<BattingModel> batting = [];
        List<BowlingModel> bowling = [];

        if (inningModel.currentBattingTeam == 1) {
          for (var player in matchModel.team1) {
            batting.add(
              BattingModel(
                player: player,
                runs: 0,
                balls: 0,
                fours: 0,
                sixes: 0,
                strikeRate: 0,
                out: false,
              ),
            );
          }
          for (var player in matchModel.team2) {
            bowling.add(
              BowlingModel(
                player: player,
                runs: 0,
                balls: 0,
                wickets: 0,
                wides: 0,
                noBalls: 0,
              ),
            );
          }
        } else {
          for (var player in matchModel.team2) {
            batting.add(
              BattingModel(
                player: player,
                runs: 0,
                balls: 0,
                fours: 0,
                sixes: 0,
                strikeRate: 0,
                out: false,
              ),
            );
          }
          for (var player in matchModel.team1) {
            bowling.add(
              BowlingModel(
                player: player,
                runs: 0,
                balls: 0,
                wickets: 0,
                wides: 0,
                noBalls: 0,
              ),
            );
          }
        }
        matchModel.innings.add(
          InningModel(
            currentBattingTeam: inningModel.currentBattingTeam,
            currentBatsman: 999,
            currentBowler: 999,
            totalRuns: 0,
            totalWickets: 0,
            totalBalls: 0,
            overs: [OverModel(bowlers: [], over: [])],
            batting: batting,
            bowling: bowling,
            superOver: true,
          ),
        );

        inningsIndex += 1;
        overIndex = 0;
      } else if (matchModel.wonBy != 999) {
        PlayerMiniModel? player;
        BattingModel? batting;
        BowlingModel? bowling;
        int bestRuns = matchModel.stats?.bestBatting?.runs ?? 0,
            bestWickets = matchModel.stats?.bestBowling?.wickets ?? 0;

        if (bestWickets * 15 > bestRuns) {
          player = matchModel.stats?.bestBowling?.player;
        } else {
          player = matchModel.stats?.bestBatting?.player;
        }

        customPrint.print(
          message:
              'bestRuns: $bestRuns, bestWickets: $bestWickets, player: ${player?.toJson()}',
        );
        for (var i in matchModel.innings) {
          customPrint.print(message: 'Checking inning: ${i.toJson()}');
          for (var ba in i.batting) {
            customPrint.print(
              message:
                  'Checking batter: ${ba.toJson()} :: ${ba.player == player} -  ${ba.player.id == player?.id}',
            );
            if (ba.player.id == player?.id) {
              batting = ba;
              customPrint.print(
                message:
                    'Setting batting: ${player?.name} - ${ba.toJson()}::${batting.toJson()}',
              );
              break;
            }
          }
          for (var bo in i.bowling) {
            customPrint.print(
              message:
                  'Checking bowler: ${bo.toJson()} :: ${bo.player == player} -  ${bo.player.id == player?.id}',
            );
            if (bo.player.id == player?.id) {
              bowling = bo;
              customPrint.print(
                message:
                    'Setting bowling: ${player?.name} - ${bo.toJson()}::${bowling.toJson()}',
              );
              break;
            }
          }
        }

        customPrint.print(
          message:
              'Batting stats: ${batting?.toJson()}\nBowling stats: ${bowling?.toJson()}',
        );

        matchModel.stats?.manOfTheMatch = ManOfTheMatchModel(
          player: player,
          batting: batting,
          bowling: bowling,
        );

        seriesModel.matches[matchIndex] = matchModel;
      }
    } else if (inningModel.totalBalls == matchModel.maxBalls ||
        inningModel.totalWickets == inningModel.batting.length) {
      int currentBattingTeam = inningModel.currentBattingTeam == 1 ? 2 : 1;
      List<BattingModel> batting = [];
      List<BowlingModel> bowling = [];

      if (currentBattingTeam == 1) {
        for (var player in matchModel.team1) {
          batting.add(
            BattingModel(
              player: player,
              runs: 0,
              balls: 0,
              fours: 0,
              sixes: 0,
              strikeRate: 0,
              out: false,
            ),
          );
        }
        for (var player in matchModel.team2) {
          bowling.add(
            BowlingModel(
              player: player,
              runs: 0,
              balls: 0,
              wickets: 0,
              wides: 0,
              noBalls: 0,
            ),
          );
        }
      } else {
        for (var player in matchModel.team2) {
          batting.add(
            BattingModel(
              player: player,
              runs: 0,
              balls: 0,
              fours: 0,
              sixes: 0,
              strikeRate: 0,
              out: false,
            ),
          );
        }
        for (var player in matchModel.team1) {
          bowling.add(
            BowlingModel(
              player: player,
              runs: 0,
              balls: 0,
              wickets: 0,
              wides: 0,
              noBalls: 0,
            ),
          );
        }
      }

      matchModel.innings.add(
        InningModel(
          currentBattingTeam: currentBattingTeam,
          currentBatsman: 999,
          currentBowler: 999,
          totalRuns: 0,
          totalWickets: 0,
          totalBalls: 0,
          overs: [OverModel(bowlers: [], over: [])],
          batting: batting,
          bowling: bowling,
          superOver: false,
        ),
      );

      inningsIndex += 1;
      overIndex = 0;
    }

    emit(
      state.copyWith(
        series: seriesModel,
        updateLineup: updateLineup,
        inningsIndex: inningsIndex,
        matchIndex: matchIndex,
        overIndex: overIndex,
      ),
    );

    event.context.read<HomeScreenBloc>().add(
      UpdateAndStoreDataEvent(series: seriesModel, seriesId: state.seriesIndex),
    );
  }

  void revertScore(RevertScoreEvent event, Emitter<MatchScreenState> emit) {
    SeriesModel seriesModel = state.series!;
    MatchModel matchModel = seriesModel.matches[state.matchIndex];
    InningModel inningModel = matchModel.innings[state.inningsIndex];
    List<OverModel> overs = inningModel.overs;
    OverModel over = overs[state.overIndex];
    String score = over.over.last;

    customPrint.print(message: 'Removing $score');

    if (['0', '2', '4', '6'].contains(score)) {
      inningModel.totalRuns -= int.parse(score);
      inningModel.totalBalls -= 1;

      inningModel.batting[inningModel.currentBatsman].runs -= int.parse(score);
      inningModel.bowling[inningModel.currentBowler].runs -= int.parse(score);

      inningModel.batting[inningModel.currentBatsman].balls -= 1;
      inningModel.bowling[inningModel.currentBowler].balls -= 1;

      if (score == '4') {
        inningModel.batting[inningModel.currentBatsman].fours -= 1;
      } else if (score == '6') {
        inningModel.batting[inningModel.currentBatsman].sixes -= 1;
      }
    } else if (score == 'WD') {
      inningModel.totalRuns -= 1;
      inningModel.bowling[inningModel.currentBowler].runs -= 1;

      inningModel.bowling[inningModel.currentBowler].wides -= 1;
    } else if (score.contains('NB')) {
      List<String> scores = score.split('+');
      int run = int.parse(scores[1]);
      inningModel.totalRuns -= run + 1;

      inningModel.batting[inningModel.currentBatsman].runs -= run;
      inningModel.bowling[inningModel.currentBowler].runs -= run + 1;

      if (scores[1] == '4') {
        inningModel.batting[inningModel.currentBatsman].fours -= 1;
      } else if (scores[1] == '6') {
        inningModel.batting[inningModel.currentBatsman].sixes -= 1;
      }

      inningModel.bowling[inningModel.currentBowler].noBalls -= 1;
    }

    event.context.read<HomeScreenBloc>().add(
      UpdatePlayerStatsEvent(
        player: inningModel.batting[inningModel.currentBatsman].player,
        type: PlayerType.batter,
        activity: score,
        revert: true,
      ),
    );

    event.context.read<HomeScreenBloc>().add(
      UpdatePlayerStatsEvent(
        player: inningModel.bowling[inningModel.currentBowler].player,
        type: PlayerType.bowler,
        activity: score,
        revert: true,
      ),
    );

    over.over.removeLast();
    overs[state.overIndex] = over;
    inningModel.overs = overs;
    matchModel.innings[state.inningsIndex] = inningModel;
    seriesModel.matches[state.matchIndex] = matchModel;

    emit(state.copyWith(series: seriesModel));

    event.context.read<HomeScreenBloc>().add(
      UpdateAndStoreDataEvent(series: seriesModel, seriesId: state.seriesIndex),
    );
  }

  void concludeInnings(
    ConcludeInningsEvent event,
    Emitter<MatchScreenState> emit,
  ) {
    bool updateLineup = false;
    int matchIndex = state.matchIndex,
        inningsIndex = state.inningsIndex,
        overIndex = state.overIndex;
    SeriesModel seriesModel = state.series!;
    MatchModel matchModel = seriesModel.matches[matchIndex];
    InningModel inningModel = matchModel.innings[inningsIndex];

    if (inningsIndex == 1) {
      InningModel previousInningModel = matchModel.innings[inningsIndex - 1];
      if (previousInningModel.totalRuns == inningModel.totalRuns) {
        matchModel.wonBy = 2;
        List<BattingModel> batting = [];
        List<BowlingModel> bowling = [];

        if (inningModel.currentBattingTeam == 1) {
          for (var player in matchModel.team1) {
            batting.add(
              BattingModel(
                player: player,
                runs: 0,
                balls: 0,
                fours: 0,
                sixes: 0,
                strikeRate: 0,
                out: false,
              ),
            );
          }
          for (var player in matchModel.team2) {
            bowling.add(
              BowlingModel(
                player: player,
                runs: 0,
                balls: 0,
                wickets: 0,
                wides: 0,
                noBalls: 0,
              ),
            );
          }
        } else {
          for (var player in matchModel.team2) {
            batting.add(
              BattingModel(
                player: player,
                runs: 0,
                balls: 0,
                fours: 0,
                sixes: 0,
                strikeRate: 0,
                out: false,
              ),
            );
          }
          for (var player in matchModel.team1) {
            bowling.add(
              BowlingModel(
                player: player,
                runs: 0,
                balls: 0,
                wickets: 0,
                wides: 0,
                noBalls: 0,
              ),
            );
          }
        }
        matchModel.innings.add(
          InningModel(
            currentBattingTeam: inningModel.currentBattingTeam,
            currentBatsman: 999,
            currentBowler: 999,
            totalRuns: 0,
            totalWickets: 0,
            totalBalls: 0,
            overs: [OverModel(bowlers: [], over: [])],
            batting: batting,
            bowling: bowling,
            superOver: true,
          ),
        );

        inningsIndex += 1;
        overIndex = 0;
      } else {
        PlayerMiniModel? player;
        BattingModel? batting;
        BowlingModel? bowling;
        int bestRuns = matchModel.stats?.bestBatting?.runs ?? 0,
            bestWickets = matchModel.stats?.bestBowling?.wickets ?? 0;

        if (bestWickets * 15 > bestRuns) {
          player = matchModel.stats?.bestBowling?.player;
        } else {
          player = matchModel.stats?.bestBatting?.player;
        }

        for (var i in matchModel.innings) {
          for (var ba in i.batting) {
            if (ba.player == player) {
              batting = ba;
              break;
            }
          }
          for (var bo in i.bowling) {
            if (bo.player == player) {
              bowling = bo;
              break;
            }
          }
        }

        matchModel.stats?.manOfTheMatch = ManOfTheMatchModel(
          player: player,
          batting: batting,
          bowling: bowling,
        );

        if (previousInningModel.totalRuns > inningModel.totalRuns) {
          matchModel.wonBy = previousInningModel.currentBattingTeam - 1;
        } else {
          matchModel.wonBy = inningModel.currentBattingTeam - 1;
        }

        seriesModel.matches[matchIndex] = matchModel;
      }
    } else {
      int currentBattingTeam = inningModel.currentBattingTeam == 1 ? 2 : 1;
      List<BattingModel> batting = [];
      List<BowlingModel> bowling = [];

      if (currentBattingTeam == 1) {
        for (var player in matchModel.team1) {
          batting.add(
            BattingModel(
              player: player,
              runs: 0,
              balls: 0,
              fours: 0,
              sixes: 0,
              strikeRate: 0,
              out: false,
            ),
          );
        }
        for (var player in matchModel.team2) {
          bowling.add(
            BowlingModel(
              player: player,
              runs: 0,
              balls: 0,
              wickets: 0,
              wides: 0,
              noBalls: 0,
            ),
          );
        }
      } else {
        for (var player in matchModel.team2) {
          batting.add(
            BattingModel(
              player: player,
              runs: 0,
              balls: 0,
              fours: 0,
              sixes: 0,
              strikeRate: 0,
              out: false,
            ),
          );
        }
        for (var player in matchModel.team1) {
          bowling.add(
            BowlingModel(
              player: player,
              runs: 0,
              balls: 0,
              wickets: 0,
              wides: 0,
              noBalls: 0,
            ),
          );
        }
      }

      matchModel.innings.add(
        InningModel(
          currentBattingTeam: currentBattingTeam,
          currentBatsman: 999,
          currentBowler: 999,
          totalRuns: 0,
          totalWickets: 0,
          totalBalls: 0,
          overs: [OverModel(bowlers: [], over: [])],
          batting: batting,
          bowling: bowling,
          superOver: false,
        ),
      );

      updateLineup = true;
      inningsIndex += 1;
      overIndex = 0;
    }

    emit(
      state.copyWith(
        series: seriesModel,
        matchIndex: matchIndex,
        inningsIndex: inningsIndex,
        overIndex: 0,
        updateLineup: updateLineup,
      ),
    );

    event.context.read<HomeScreenBloc>().add(
      UpdateAndStoreDataEvent(series: seriesModel, seriesId: state.seriesIndex),
    );
  }

  void addNewMatch(AddNewMatchEvent event, Emitter<MatchScreenState> emit) {
    SeriesModel seriesModel = state.series!;

    int maxBalls = seriesModel?.team1.length ?? 0;
    if ((seriesModel?.team2.length ?? 0) > maxBalls) {
      maxBalls = seriesModel?.team2.length ?? 0;
    }

    seriesModel?.matches.add(
      MatchModel(
        team1: seriesModel.team1,
        team2: seriesModel.team2,
        innings: [],
        toss: 999,
        batOrBowl: 999,
        wonBy: 999,
        maxBalls: maxBalls * 6,
        stats: MatchStatsModel(),
      ),
    );

    emit(
      state.copyWith(
        series: seriesModel,
        matchIndex: state.matchIndex + 1,
        inningsIndex: 0,
        overIndex: 0,
        updateLineup: false,
      ),
    );

    event.context.read<HomeScreenBloc>().add(
      UpdateAndStoreDataEvent(series: seriesModel, seriesId: state.seriesIndex),
    );
  }
}
