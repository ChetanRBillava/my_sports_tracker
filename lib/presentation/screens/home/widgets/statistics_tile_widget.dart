import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sports_tracker/logics/cubits/app_theme_cubit.dart';
import 'package:my_sports_tracker/presentation/screens/home/logic/home_screen_bloc.dart';
import 'package:my_sports_tracker/presentation/screens/home/logic/home_screen_event.dart';
import 'package:my_sports_tracker/presentation/screens/home/logic/home_screen_state.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../core/constants/enums.dart';
import '../../../../data/models/player_model.dart';
import '../models/statistics_tile_model.dart';

UiUtilityPackage uiUtilityPackage = UiUtilityPackage();
Widget statisticsTileWidget({
  required StatisticsTileModel statisticsTileModel,
}) {
  String getLabel({required StatTileEnums type, required PlayerModel player}) {
    switch (type) {
      case StatTileEnums.wins:
        String text =
            '${player.name} - ${player.stats?.match?.won ?? 0}(${player.stats?.match?.played ?? 0})';
        return text;
      case StatTileEnums.motm:
        String text =
            '${player.name} - ${player.stats?.match?.motm ?? 0}(${player.stats?.match?.played ?? 0})';
        return text;
      case StatTileEnums.runs:
        String text = '${player.name} - ${player.stats?.batting?.runs ?? 0}';
        return text;
      case StatTileEnums.sixes:
        String text = '${player.name} - ${player.stats?.batting?.sixes ?? 0}';
        return text;
      case StatTileEnums.fours:
        String text = '${player.name} - ${player.stats?.batting?.fours ?? 0}';
        return text;
      case StatTileEnums.sr:
        String text =
            '${player.name} - ${(((player.stats?.batting?.runs ?? 0) / (player.stats?.batting?.balls ?? 0)) * 100).toStringAsFixed(2)}';
        return text;
      case StatTileEnums.wickets:
        String text = '${player.name} - ${player.stats?.bowling?.wickets ?? 0}';
        return text;
      case StatTileEnums.economy:
        String text =
            '${player.name} - ${(((player.stats?.bowling?.runs ?? 0) / (player.stats?.bowling?.balls ?? 0)) * 6).toStringAsFixed(2)}';
        return text;
    }
  }

  return BlocBuilder<AppThemeCubit, AppThemeState>(
    builder: (context, appThemeState) {
      return uiUtilityPackage.customCard(
        color: appThemeState.themeClass.cardBackgroundColorSecondary,
        onDoubleTap:
            () => context.read<HomeScreenBloc>().add(
              UpdateMainFlagEvent(
                flag: statisticsTileModel.title.toLowerCase().replaceAll(
                  ' ',
                  '_',
                ),
              ),
            ),
        widget: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (context, homeScreenState) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  uiUtilityPackage.customText(
                    text: statisticsTileModel.title!.toUpperCase(),
                    fontSize: TextSize.title,
                    overrideColor: appThemeState.themeClass.white,
                  ),

                  !(homeScreenState.mainStatTileFlags[statisticsTileModel.title
                              .toLowerCase()
                              .replaceAll(' ', '_')] ??
                          true)
                      ? SizedBox.shrink()
                      : ListView.builder(
                        itemCount: statisticsTileModel.stats?.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, statIndex) {
                          return uiUtilityPackage.customCard(
                            color: appThemeState.themeClass.cardBackgroundColor,
                            onDoubleTap:
                                () => context.read<HomeScreenBloc>().add(
                                  UpdateSubFlagEvent(
                                    flag:
                                        statisticsTileModel
                                            .stats![statIndex]
                                            .type,
                                  ),
                                ),
                            widget: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  uiUtilityPackage.customText(
                                    text:
                                        statisticsTileModel
                                            .stats![statIndex]
                                            .title!
                                            .toUpperCase(),
                                    fontSize: TextSize.title,
                                    overrideColor:
                                        appThemeState.themeClass.white,
                                  ),

                                  homeScreenState
                                              .subStatTileFlags[statisticsTileModel
                                              .stats![statIndex]
                                              .type] ==
                                          true
                                      ? statisticsTileModel
                                              .stats![statIndex]
                                              .players!
                                              .isEmpty
                                          ? uiUtilityPackage.customText(
                                            text: 'statistics not available',
                                            fontSize: TextSize.normal,
                                            overrideColor:
                                                appThemeState.themeClass.white,
                                          )
                                          : ListView.separated(
                                            padding: EdgeInsets.all(16),
                                            itemCount:
                                                statisticsTileModel
                                                            .stats![statIndex]
                                                            .players!
                                                            .length <
                                                        5
                                                    ? statisticsTileModel
                                                        .stats![statIndex]
                                                        .players!
                                                        .length
                                                    : 5,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (
                                              context,
                                              playerIndex,
                                            ) {
                                              return uiUtilityPackage.customText(
                                                text:
                                                    '${playerIndex + 1}. ${getLabel(type: statisticsTileModel.stats![statIndex].type!, player: statisticsTileModel.stats![statIndex].players![playerIndex])}',
                                                fontSize:
                                                    playerIndex == 0
                                                        ? TextSize.title
                                                        : TextSize.label,
                                                overrideColor:
                                                    appThemeState
                                                        .themeClass
                                                        .white,
                                              );
                                            },
                                            separatorBuilder:
                                                (context, index) => Divider(),
                                          )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
