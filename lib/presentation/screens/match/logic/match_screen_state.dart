import 'package:my_sports_tracker/data/models/match_models/series/series_model.dart';

class MatchScreenState {
  final int seriesIndex, matchIndex, inningsIndex, overIndex;
  final SeriesModel? series;
  final bool updateLineup, animate;
  final String lottieImage;

  const MatchScreenState({
    required this.seriesIndex,
    required this.matchIndex,
    required this.inningsIndex,
    required this.overIndex,
    required this.updateLineup,
    this.animate = false,
    this.lottieImage = '',
    this.series,
  });

  MatchScreenState copyWith({
    int? seriesIndex,
    int? matchIndex,
    int? inningsIndex,
    int? overIndex,
    SeriesModel? series,
    bool? updateLineup,
    String? lottieImage,
    bool? animate,
  }) {
    return MatchScreenState(
      matchIndex: matchIndex ?? this.matchIndex,
      seriesIndex: seriesIndex ?? this.seriesIndex,
      inningsIndex: inningsIndex ?? this.inningsIndex,
      overIndex: overIndex ?? this.overIndex,
      series: series ?? this.series,
      updateLineup: updateLineup ?? this.updateLineup,
      lottieImage: lottieImage ?? this.lottieImage,
      animate: animate ?? this.animate,
    );
  }

  List<Object?> get props => [
    seriesIndex,
    matchIndex,
    inningsIndex,
    overIndex,
    series,
    updateLineup,
    lottieImage,
    animate,
  ];
}
