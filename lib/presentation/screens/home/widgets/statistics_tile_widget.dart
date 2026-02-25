import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sports_tracker/logics/cubits/app_theme_cubit.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../models/statistics_tile_model.dart';

UiUtilityPackage uiUtilityPackage = UiUtilityPackage();
Widget statisticsTileWidget({
  required StatisticsTileModel statisticsTileModel,
}) {
  bool isOpen = false;
  Map<int, bool> openFlags = {};
  return BlocBuilder<AppThemeCubit, AppThemeState>(
    builder: (context, appThemeState) {
      return StatefulBuilder(
        builder: (context, setThisState) {
          return uiUtilityPackage.customCard(
            color: appThemeState.themeClass.cardBackgroundColorSecondary,
            onDoubleTap: () {
              setThisState(() {
                isOpen = !isOpen;
              });
            },
            widget: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  uiUtilityPackage.customText(
                    text: statisticsTileModel.title!.toUpperCase(),
                    fontSize: TextSize.title,
                    overrideColor: appThemeState.themeClass.white,
                  ),

                  !isOpen
                      ? SizedBox.shrink()
                      : ListView.builder(
                        itemCount: statisticsTileModel.stats?.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, statIndex) {
                          return uiUtilityPackage.customCard(
                            color: appThemeState.themeClass.cardBackgroundColor,
                            onDoubleTap: () {
                              setThisState(() {
                                if (openFlags[statIndex] == null) {
                                  openFlags[statIndex] = true;
                                } else {
                                  openFlags[statIndex] = !openFlags[statIndex]!;
                                }
                              });
                            },
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

                                  openFlags[statIndex] == true
                                      ? ListView.separated(
                                        padding: EdgeInsets.all(16),
                                        itemCount: 5,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, playerIndex) {
                                          return uiUtilityPackage.customText(
                                            text:
                                                '${playerIndex + 1}. ${statisticsTileModel.stats![0].players![playerIndex]} - 20(35)',
                                            fontSize:
                                                playerIndex == 0
                                                    ? TextSize.title
                                                    : TextSize.label,
                                            overrideColor:
                                                appThemeState.themeClass.white,
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
            ),
          );
        },
      );
    },
  );
}
