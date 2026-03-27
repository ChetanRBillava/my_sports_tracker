import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:my_sports_tracker/core/constants/enums.dart';
import 'package:my_sports_tracker/data/models/player_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../data/models/player_mini_model.dart';
import '../../../../data/models/series_model.dart';
import '../../../../data/models/stat_filter_model.dart';
import '../../../utils/custom_print.dart';
import '../models/statistics_tile_model.dart';
import 'home_screen_event.dart';
import 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  CustomPrint customPrint = CustomPrint();
  UiUtilityPackage uiUtilityPackage = UiUtilityPackage();

  HomeScreenBloc()
    : super(
        HomeScreenState(
          selectedBottomBarIndex: 1,
          players: [],
          statFilters: [],
          series: [],
          selectedFilterIndex: 0,
          statTiles: [],
          subStatTileFlags: {},
          mainStatTileFlags: {},
        ),
      ) {
    on<InitEvent>(_init);
    on<ToggleBottomBarEvent>(toggleBottomBar);
    on<ToggleFilterEvent>(toggleFilter);
    on<UpdateMainFlagEvent>(updateMainFlag);
    on<UpdateSubFlagEvent>(updateSubFlag);
    on<AddPlayerEvent>(addPlayer);
    on<AddSeriesEvent>(addSeries);
    on<UpdatePlayerStatsEvent>(updatePlayerStats);
    on<UpdateAndStoreDataEvent>(updateAndStoreData);

    add(InitEvent());
  }

  void _init(InitEvent event, Emitter<HomeScreenState> emit) async {
    emit(state.init());

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String playerImport = '', seriesImport = '';

      playerImport = prefs.getString('players') ?? '';
      seriesImport = prefs.getString('series') ?? '';

      // Read from assets
      // playerImport = await rootBundle.loadString(
      //   'assets/imports/player_data.json',
      // );
      // seriesImport = await rootBundle.loadString(
      //   'assets/imports/series_data.json',
      // );

      final List<dynamic> playersData = jsonDecode(playerImport);
      final List<dynamic> seriesData = jsonDecode(seriesImport);

      // Save to SharedPreferences
      await prefs.setString('players', playerImport);
      await prefs.setString('series', seriesImport);

      List<PlayerModel> tempPlayers = [];
      // Update app state
      tempPlayers =
          playersData.map((json) => PlayerModel.fromMap(json)).toList();
      customPrint.print(
        message: '✅ Loaded ${playersData.length} players from assets!',
      );

      List<SeriesModel> tempSeries = [];
      // Update app state
      tempSeries = seriesData.map((json) => SeriesModel.fromMap(json)).toList();
      customPrint.print(
        message: '✅ Loaded ${seriesData.length} series from assets!',
      );

      ///Setup Filters
      List<StatFilterModel> filters = [
        StatFilterModel(month: '0', monthName: 'All time Stats', year: '2026'),
      ];
      for (var s in tempSeries) {
        List<String> dates = s.date.split('-');
        customPrint.print(
          message: 'Getting month name: ${getMonthName(int.parse(dates[1]))}',
        );

        if (filters[filters.length - 1].month != dates[1]) {
          filters.add(
            StatFilterModel(
              month: dates[1],
              monthName: getMonthName(int.parse(dates[1])),
              year: dates[0],
            ),
          );
        }
        customPrint.print(message: 'Filters: $filters');
      }

      ///Setup Statistics
      List<StatisticsTileModel> stats = [
        StatisticsTileModel(
          title: 'Match Statistics',
          stats: [
            Stat(
              title: 'Most Wins',
              type: StatTileEnums.wins,
              players: tempPlayers.toList(),
            ),
            Stat(
              title: 'Most MOTM',
              type: StatTileEnums.motm,
              players: tempPlayers.toList(),
            ),
          ],
        ),
        StatisticsTileModel(
          title: 'Batting Statistics',
          stats: [
            Stat(
              title: 'Most Runs',
              type: StatTileEnums.runs,
              players: tempPlayers.toList(),
            ),
            Stat(
              title: 'Most 6s',
              type: StatTileEnums.sixes,
              players: tempPlayers.toList(),
            ),
            Stat(
              title: 'Most 4s',
              type: StatTileEnums.fours,
              players: tempPlayers.toList(),
            ),
            Stat(
              title: 'Best Strike Rate',
              type: StatTileEnums.sr,

              players: tempPlayers.toList(),
            ),
          ],
        ),
        StatisticsTileModel(
          title: 'Bowling Statistics',
          stats: [
            Stat(
              title: 'Most Wickets',
              type: StatTileEnums.wickets,

              players: tempPlayers.toList(),
            ),
            Stat(
              title: 'Best Economy',
              type: StatTileEnums.economy,

              players: tempPlayers.toList(),
            ),
          ],
        ),
      ];

      Map<String, bool> tempMainFlags = {};
      for (var s in stats) {
        bool val = false;
        if (tempMainFlags.isEmpty) {
          val = true;
        }
        tempMainFlags[s.title.toLowerCase().replaceAll(' ', '_')] = val;
      }

      Map<StatTileEnums, bool> tempSubFlags = {};
      for (var flag in StatTileEnums.values) {
        if (flag == StatTileEnums.wins ||
            flag == StatTileEnums.runs ||
            flag == StatTileEnums.wickets) {
          tempSubFlags[flag] = true;
        } else {
          tempSubFlags[flag] = false;
        }
      }

      emit(
        HomeScreenState(
          selectedBottomBarIndex: 1,
          selectedFilterIndex: 0,
          players: tempPlayers.toList(),
          series: tempSeries.toList(),
          statFilters: filters,
          statTiles: stats,
          subStatTileFlags: tempSubFlags,
          mainStatTileFlags: tempMainFlags,
        ),
      );

      add(ToggleFilterEvent(index: 0));

      updateGameStats(emit);
    } catch (e) {
      customPrint.print(
        message: 'Exception caught while loading players from assets: $e',
      );
    }
  }

  void updateGameStats(Emitter<HomeScreenState> emit) {
    List<PlayerModel> players = state.players.map((p) => p.copyWith()).toList();
    List<SeriesModel> series = state.series.map((p) => p.copyWith()).toList();

    for (var players in players) {
      players.stats = Stats(
        batting: BattingStats(runs: 0, balls: 0, dots: 0, fours: 0, sixes: 0),
        bowling: BowlingStats(wickets: 0, runs: 0, dots: 0, balls: 0, wides: 0),
        match: MatchStats(
          played: 0,
          won: 0,
          superOvers: 0,
          superOversWon: 0,
          motm: 0,
        ),
      );
    }

    for (var s in series) {
      for (var m in s.matches) {
        for (var i in m.innings) {
          for (var b in i.batting) {
            for (var p in players) {
              if (b.player.id == p.id) {
                p.stats?.batting?.runs = (p.stats?.batting?.runs ?? 0) + b.runs;
                p.stats?.batting?.balls =
                    (p.stats?.batting?.balls ?? 0) + b.balls;
                p.stats?.batting?.sixes =
                    (p.stats?.batting?.sixes ?? 0) + b.sixes;
                p.stats?.batting?.fours =
                    (p.stats?.batting?.fours ?? 0) + b.fours;
              }
            }
          }
          for (var b in i.bowling) {
            for (var p in players) {
              if (b.player.id == p.id) {
                p.stats?.bowling?.wickets =
                    (p.stats?.bowling?.wickets ?? 0) + b.wickets;
                p.stats?.bowling?.balls =
                    (p.stats?.bowling?.balls ?? 0) + b.balls;
                p.stats?.bowling?.runs = (p.stats?.bowling?.runs ?? 0) + b.runs;
                p.stats?.bowling?.wides =
                    (p.stats?.bowling?.wides ?? 0) + b.wides;
                p.stats?.bowling?.noBalls =
                    (p.stats?.bowling?.noBalls ?? 0) + b.noBalls;
              }
            }
          }
        }
        if (m.wonBy != 999) {
          for (var t in m.team1) {
            for (var p in players) {
              if (t.id == p.id) {
                p.stats?.match?.played = (p.stats?.match?.played ?? 0) + 1;
                if (m.wonBy == 0) {
                  p.stats?.match?.won = (p.stats?.match?.won ?? 0) + 1;
                }
              }
            }
          }
          for (var t in m.team2) {
            for (var p in players) {
              if (t.id == p.id) {
                p.stats?.match?.played = (p.stats?.match?.played ?? 0) + 1;
                if (m.wonBy == 1) {
                  p.stats?.match?.won = (p.stats?.match?.won ?? 0) + 1;
                }
              }
            }
          }
          for (var p in players) {
            if (m.stats?.manOfTheMatch?.player?.id == p.id) {
              p.stats?.match?.motm = (p.stats?.match?.motm ?? 0) + 1;
            }
          }
        }
      }
    }

    emit(state.copyWith(series: series, players: players));
  }

  String getMonthName(int month) =>
      DateFormat('MMMM').format(DateTime(2023, month, 1));

  void toggleBottomBar(
    ToggleBottomBarEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    customPrint.print(message: 'Toggling bottom bar to index: ${event.index}');
    emit(state.copyWith(selectedBottomBarIndex: event.index));
  }

  void toggleFilter(
    ToggleFilterEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    List<StatisticsTileModel> temp =
        state.statTiles.map((p) => p.copyWith()).toList();
    List<PlayerModel> tempPlayers =
        state.players.map((p) => p.copyWith()).toList();
    customPrint.print(
      message:
          'Toggling filter to index: ${event.index} - ${state.statFilters[event.index].month} : ${state.statFilters[event.index].monthName}',
    );
    if (event.index != 0) {
      for (var player in tempPlayers) {
        player.stats = Stats(
          batting: BattingStats(runs: 0, balls: 0, dots: 0, fours: 0, sixes: 0),
          bowling: BowlingStats(
            wickets: 0,
            runs: 0,
            dots: 0,
            balls: 0,
            wides: 0,
          ),
          match: MatchStats(
            played: 0,
            won: 0,
            superOvers: 0,
            superOversWon: 0,
            motm: 0,
          ),
        );
      }

      for (var s in state.series) {
        List<String> dates = s.date.split('-');
        if (dates[0] == state.statFilters[event.index].year &&
            dates[1] == state.statFilters[event.index].month) {
          for (var m in s.matches) {
            if (m.wonBy != 999) {
              for (var t in m.team1) {
                for (var p in tempPlayers) {
                  if (t.id == p.id) {
                    p.stats?.match?.played = (p.stats?.match?.played ?? 0) + 1;
                    if (m.wonBy == 0) {
                      p.stats?.match?.won = (p.stats?.match?.won ?? 0) + 1;
                    }
                  }
                }
              }
              for (var t in m.team2) {
                for (var p in tempPlayers) {
                  if (t.id == p.id) {
                    p.stats?.match?.played = (p.stats?.match?.played ?? 0) + 1;
                    if (m.wonBy == 1) {
                      p.stats?.match?.won = (p.stats?.match?.won ?? 0) + 1;
                    }
                  }
                }
              }
              for (var p in tempPlayers) {
                if (m.stats?.manOfTheMatch?.player?.id == p.id) {
                  p.stats?.match?.motm = (p.stats?.match?.motm ?? 0) + 1;
                }
              }

              for (var i in m.innings) {
                for (var b in i.batting) {
                  for (var p in tempPlayers) {
                    if (b.player.id == p.id) {
                      p.stats?.batting?.runs =
                          (p.stats?.batting?.runs ?? 0) + b.runs;
                      p.stats?.batting?.balls =
                          (p.stats?.batting?.balls ?? 0) + b.balls;
                      p.stats?.batting?.sixes =
                          (p.stats?.batting?.sixes ?? 0) + b.sixes;
                      p.stats?.batting?.fours =
                          (p.stats?.batting?.fours ?? 0) + b.fours;
                    }
                  }
                }
                for (var b in i.bowling) {
                  for (var p in tempPlayers) {
                    if (b.player.id == p.id) {
                      p.stats?.bowling?.wickets =
                          (p.stats?.bowling?.wickets ?? 0) + b.wickets;
                      p.stats?.bowling?.balls =
                          (p.stats?.bowling?.balls ?? 0) + b.balls;
                      p.stats?.bowling?.runs =
                          (p.stats?.bowling?.runs ?? 0) + b.runs;
                      p.stats?.bowling?.wides =
                          (p.stats?.bowling?.wides ?? 0) + b.wides;
                      p.stats?.bowling?.noBalls =
                          (p.stats?.bowling?.noBalls ?? 0) + b.noBalls;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    for (var t in temp) {
      t.stats?.forEach((s) {
        s.players = tempPlayers.map((p) => p.copyWith()).toList();
      });
    }

    for (var i in temp) {
      i.stats?.forEach((j) {
        customPrint.print(message: 'Current enum: ${j.type}');
        switch (j.type) {
          case StatTileEnums.wins:
            j.players?.sort(
              (a, b) => (b.stats?.match?.won ?? 0).compareTo(
                a.stats?.match?.won ?? 0,
              ),
            );
            break;
          case StatTileEnums.motm:
            j.players?.sort(
              (a, b) => (b.stats?.match?.motm ?? 0).compareTo(
                a.stats?.match?.motm ?? 0,
              ),
            );
            break;
          case StatTileEnums.runs:
            j.players?.sort(
              (a, b) => (b.stats?.batting?.runs ?? 0).compareTo(
                a.stats?.batting?.runs ?? 0,
              ),
            );
            break;
          case StatTileEnums.sixes:
            j.players?.sort(
              (a, b) => (b.stats?.batting?.sixes ?? 0).compareTo(
                a.stats?.batting?.sixes ?? 0,
              ),
            );
            break;
          case StatTileEnums.fours:
            j.players?.sort(
              (a, b) => (b.stats?.batting?.fours ?? 0).compareTo(
                a.stats?.batting?.fours ?? 0,
              ),
            );
            break;
          case StatTileEnums.sr:
            j.players?.sort((a, b) {
              final matchesA = a.stats?.match?.played ?? 0;
              final matchesB = b.stats?.match?.played ?? 0;

              // matches > 10 always come first
              if (matchesA > 10 && matchesB <= 10) return -1;
              if (matchesB > 10 && matchesA <= 10) return 1;

              // Same runs threshold: compare strike rates
              final srA = _safeStrikeRate(a);
              final srB = _safeStrikeRate(b);
              return srB.compareTo(srA); // Highest SR first
            });
            break;
          case StatTileEnums.wickets:
            j.players?.sort(
              (a, b) => (b.stats?.bowling?.wickets ?? 0).compareTo(
                a.stats?.bowling?.wickets ?? 0,
              ),
            );
            break;
          case StatTileEnums.economy:
            j.players?.sort((a, b) {
              final matchesA = a.stats?.match?.played ?? 0;
              final matchesB = b.stats?.match?.played ?? 0;

              // matches > 10 always come first
              if (matchesA > 10 && matchesB <= 10) return -1;
              if (matchesB > 10 && matchesA <= 10) return 1;

              // Same runs threshold: compare economy (LOWER is better)
              final econA = _safeEconomy(a);
              final econB = _safeEconomy(b);
              return econA.compareTo(econB); // Lowest economy first (ascending)
            });
            break;
          default:
            break;
        }
      });
    }

    emit(state.copyWith(selectedFilterIndex: event.index, statTiles: temp));
  }

  double _safeStrikeRate(PlayerModel player) {
    final runs = player.stats?.batting?.runs ?? 0;
    final balls = player.stats?.batting?.balls ?? 0;
    return balls > 0 ? (runs / balls) : 0.0;
  }

  double _safeEconomy(PlayerModel player) {
    final runs = player.stats?.bowling?.runs ?? 0;
    final balls = player.stats?.bowling?.balls ?? 0;
    return balls > 0 ? (runs / balls) : 999.0; // High default for no overs
  }

  void updateMainFlag(
    UpdateMainFlagEvent event,
    Emitter<HomeScreenState> emit,
  ) {
    Map<String, bool>? temp = state.mainStatTileFlags;

    temp[event.flag] = !(temp[event.flag] ?? true);

    customPrint.print(
      message: 'Updating flag: ${event.flag} - ${temp[event.flag]}',
    );

    emit(state.copyWith(mainStatTileFlags: temp));
  }

  void updateSubFlag(UpdateSubFlagEvent event, Emitter<HomeScreenState> emit) {
    Map<StatTileEnums, bool>? statTileFlags = state.subStatTileFlags;

    statTileFlags[event.flag] = !(statTileFlags[event.flag] ?? true);

    customPrint.print(
      message: 'Updating flag: ${event.flag} - ${statTileFlags[event.flag]}',
    );

    emit(state.copyWith(subStatTileFlags: statTileFlags));
  }

  void addPlayer(AddPlayerEvent event, Emitter<HomeScreenState> emit) {
    String idPrefix = 'player_';
    String generatedId =
        idPrefix + DateTime.now().millisecondsSinceEpoch.toString();
    customPrint.print(message: 'Adding player: ${event.name}}');

    List<PlayerModel> tempPlayers =
        state.players.map((p) => p.copyWith()).toList();

    tempPlayers.add(
      PlayerModel(
        id: generatedId,
        name: event.name,
        stats: Stats(
          batting: BattingStats(runs: 0, balls: 0, dots: 0, fours: 0, sixes: 0),
          bowling: BowlingStats(
            wickets: 0,
            runs: 0,
            dots: 0,
            balls: 0,
            wides: 0,
          ),
          match: MatchStats(
            played: 0,
            won: 0,
            superOvers: 0,
            superOversWon: 0,
            motm: 0,
          ),
        ),
      ),
    );

    emit(state.copyWith(players: tempPlayers));
  }

  Future<List<PlayerModel>> getPlayers() async {
    return state.players;
  }

  void addSeries(AddSeriesEvent event, Emitter<HomeScreenState> emit) {
    List<SeriesModel> tempSeries =
        state.series.map((p) => p.copyWith()).toList();
    List<PlayerMiniModel> players = [];

    String idPrefix = 'series_';
    String generatedId =
        idPrefix + DateTime.now().millisecondsSinceEpoch.toString();
    String matchName = 'Series ${tempSeries.length + 1}';
    String date = DateTime.now().toString().split(' ')[0];

    for (var p in event.players) {
      players.add(PlayerMiniModel(id: p.id, name: p.name));
    }

    tempSeries.add(
      SeriesModel(
        id: generatedId,
        name: matchName,
        players: players,
        date: date,
        team1: [],
        team2: [],
        matches: [],
      ),
    );

    emit(state.copyWith(series: tempSeries));
  }

  Future<void> updatePlayerStats(
    UpdatePlayerStatsEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<PlayerModel> players = state.players;

    int playerIndex = players.indexWhere((p) => p.id == event.player.id);

    if (event.type == PlayerType.batter) {
      if (['0', '2', '4', '6'].contains(event.activity)) {
        if (event.revert) {
          players[playerIndex].stats?.batting?.runs =
              (players[playerIndex].stats?.batting?.runs ?? 0) -
              int.parse(event.activity);
          players[playerIndex].stats?.batting?.balls =
              (players[playerIndex].stats?.batting?.balls ?? 0) - 1;

          if (event.activity == '0') {
            players[playerIndex].stats?.batting?.dots =
                (players[playerIndex].stats?.batting?.dots ?? 0) - 1;
          } else if (event.activity == '4') {
            players[playerIndex].stats?.batting?.fours =
                (players[playerIndex].stats?.batting?.fours ?? 0) - 1;
          } else if (event.activity == '6') {
            players[playerIndex].stats?.batting?.sixes =
                (players[playerIndex].stats?.batting?.sixes ?? 0) - 1;
          }
        } else {
          players[playerIndex].stats?.batting?.runs =
              (players[playerIndex].stats?.batting?.runs ?? 0) +
              int.parse(event.activity);
          players[playerIndex].stats?.batting?.balls =
              (players[playerIndex].stats?.batting?.balls ?? 0) + 1;

          if (event.activity == '0') {
            players[playerIndex].stats?.batting?.dots =
                (players[playerIndex].stats?.batting?.dots ?? 0) + 1;
          } else if (event.activity == '4') {
            players[playerIndex].stats?.batting?.fours =
                (players[playerIndex].stats?.batting?.fours ?? 0) + 1;
          } else if (event.activity == '6') {
            players[playerIndex].stats?.batting?.sixes =
                (players[playerIndex].stats?.batting?.sixes ?? 0) + 1;
          }
        }
      } else if (event.activity.contains('NB')) {
        List<String> scores = event.activity.split('+');
        int score = int.parse(scores[1]);

        if (event.revert) {
          players[playerIndex].stats?.batting?.runs =
              (players[playerIndex].stats?.batting?.runs ?? 0) - score;

          if (scores[1] == '4') {
            players[playerIndex].stats?.batting?.fours =
                (players[playerIndex].stats?.batting?.fours ?? 0) - 1;
          } else if (scores[1] == '6') {
            players[playerIndex].stats?.batting?.sixes =
                (players[playerIndex].stats?.batting?.sixes ?? 0) - 1;
          }
        } else {
          players[playerIndex].stats?.batting?.runs =
              (players[playerIndex].stats?.batting?.runs ?? 0) + score;

          if (scores[1] == '4') {
            players[playerIndex].stats?.batting?.fours =
                (players[playerIndex].stats?.batting?.fours ?? 0) + 1;
          } else if (scores[1] == '6') {
            players[playerIndex].stats?.batting?.sixes =
                (players[playerIndex].stats?.batting?.sixes ?? 0) + 1;
          }
        }
      } else {
        players[playerIndex].stats?.batting?.balls =
            (players[playerIndex].stats?.batting?.balls ?? 0) + 1;
      }
    } else {
      if (['0', '2', '4', '6'].contains(event.activity)) {
        if (event.revert) {
          if (event.activity == '0') {
            players[playerIndex].stats?.bowling?.dots =
                (players[playerIndex].stats?.bowling?.dots ?? 0) - 1;
          } else {
            players[playerIndex].stats?.bowling?.runs =
                (players[playerIndex].stats?.bowling?.runs ?? 0) -
                int.parse(event.activity);
          }

          players[playerIndex].stats?.bowling?.balls =
              (players[playerIndex].stats?.bowling?.balls ?? 0) - 1;
        } else {
          if (event.activity == '0') {
            players[playerIndex].stats?.bowling?.dots =
                (players[playerIndex].stats?.bowling?.dots ?? 0) + 1;
          } else {
            players[playerIndex].stats?.bowling?.runs =
                (players[playerIndex].stats?.bowling?.runs ?? 0) +
                int.parse(event.activity);
          }

          players[playerIndex].stats?.bowling?.balls =
              (players[playerIndex].stats?.bowling?.balls ?? 0) + 1;
        }
      } else if (event.activity == 'WD') {
        if (event.revert) {
          players[playerIndex].stats?.bowling?.runs =
              (players[playerIndex].stats?.bowling?.runs ?? 0) - 1;
          players[playerIndex].stats?.bowling?.wides =
              (players[playerIndex].stats?.bowling?.wides ?? 0) - 1;
        } else {
          players[playerIndex].stats?.bowling?.runs =
              (players[playerIndex].stats?.bowling?.runs ?? 0) + 1;
          players[playerIndex].stats?.bowling?.wides =
              (players[playerIndex].stats?.bowling?.wides ?? 0) + 1;
        }
      } else if (event.activity.contains('NB')) {
        List<String> scores = event.activity.split('+');
        int score = int.parse(scores[1]);

        if (event.revert) {
          players[playerIndex].stats?.bowling?.runs =
              (players[playerIndex].stats?.bowling?.runs ?? 0) - score + 1;

          players[playerIndex].stats?.bowling?.noBalls =
              (players[playerIndex].stats?.bowling?.noBalls ?? 0) - 1;
        } else {
          players[playerIndex].stats?.bowling?.runs =
              (players[playerIndex].stats?.bowling?.runs ?? 0) + score + 1;

          players[playerIndex].stats?.bowling?.noBalls =
              (players[playerIndex].stats?.bowling?.noBalls ?? 0) + 1;
        }
      } else {
        players[playerIndex].stats?.bowling?.wickets =
            (players[playerIndex].stats?.bowling?.wickets ?? 0) + 1;
        players[playerIndex].stats?.bowling?.balls =
            (players[playerIndex].stats?.bowling?.balls ?? 0) + 1;
      }
    }

    emit(state.copyWith(players: players));
    prefs.setString(
      'players',
      jsonEncode(players.map((p) => p.toMap()).toList()),
    );
  }

  Future<void> updateAndStoreData(
    UpdateAndStoreDataEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    customPrint.print(message: 'Updating data');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<SeriesModel> series = state.series;

    series[event.seriesId] = event.series;

    emit(state.copyWith(series: series));

    prefs.setString(
      'series',
      jsonEncode(series.map((p) => p.toMap()).toList()),
    );
  }
}
