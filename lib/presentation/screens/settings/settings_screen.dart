import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sports_tracker/logics/cubits/app_theme_cubit.dart';
import 'package:my_sports_tracker/presentation/screens/home/logic/home_screen_bloc.dart';
import 'package:my_sports_tracker/presentation/screens/home/logic/home_screen_event.dart';
import 'package:my_sports_tracker/presentation/utils/custom_print.dart';
import 'package:my_sports_tracker/presentation/utils/data_transfer_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/constants/app_strings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UiUtilityPackage uiUtilityPackage = UiUtilityPackage();
  CustomPrint customPrint = CustomPrint();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeState>(
      builder: (context, appThemeState) {
        return Scaffold(
          backgroundColor: appThemeState.themeClass.backgroundColor,
          appBar: AppBar(
            backgroundColor: appThemeState.themeClass.appbarBackgroundColor,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                color: appThemeState.themeClass.white,
              ),
            ),
            title: uiUtilityPackage.customText(
              text: AppStrings.settingsScreenTitle,
              fontSize: TextSize.title,
              overrideColor: appThemeState.themeClass.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ///Import Players
                uiUtilityPackage.customCard(
                  color: appThemeState.themeClass.cardBackgroundColor,
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      uiUtilityPackage.customText(
                        text: AppStrings.importPlayers,
                        fontSize: TextSize.subTitle,
                        overrideColor: appThemeState.themeClass.white,
                        fontWeight: FontWeight.bold,
                      ),
                      uiUtilityPackage.customButton(
                        onTap: () async {
                          // File picker or manual path
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['json'],
                          );

                          if (result != null) {
                            customPrint.print(
                              message: 'File name: ${result.files.single.name}',
                            );
                            if (result.files.single.name.toLowerCase().contains(
                              'series',
                            )) {
                              uiUtilityPackage.showCustomSnackBar(
                                context: context,
                                backgroundColor:
                                    appThemeState.themeClass.warningColor,
                                content: uiUtilityPackage.customText(
                                  text: AppStrings.wrongFile,
                                  fontSize: TextSize.subTitle,
                                  overrideColor: appThemeState.themeClass.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              String resp =
                                  await DataTransferService.importPlayers(
                                    result.files.single.path!,
                                  );
                              if (resp.isNotEmpty) {
                                context.read<HomeScreenBloc>().add(
                                  ImportDataEvent(
                                    importString: resp,
                                    isPlayerData: true,
                                  ),
                                );
                              }
                              uiUtilityPackage.showCustomSnackBar(
                                context: context,
                                backgroundColor:
                                    resp.isNotEmpty
                                        ? appThemeState.themeClass.successColor
                                        : appThemeState.themeClass.dangerColor,
                                content: uiUtilityPackage.customText(
                                  text:
                                      resp.isNotEmpty
                                          ? AppStrings.playersImported
                                          : AppStrings.importFailed,
                                  fontSize: TextSize.subTitle,
                                  overrideColor: appThemeState.themeClass.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                        },
                        type: ButtonType.icon,
                        icon: Icons.download,
                        iconColor: appThemeState.themeClass.white,
                      ),
                    ],
                  ),
                ),

                ///Export Players
                uiUtilityPackage.customCard(
                  color: appThemeState.themeClass.cardBackgroundColor,
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      uiUtilityPackage.customText(
                        text: AppStrings.exportPlayers,
                        fontSize: TextSize.subTitle,
                        overrideColor: appThemeState.themeClass.white,
                        fontWeight: FontWeight.bold,
                      ),
                      uiUtilityPackage.customButton(
                        onTap: () async {
                          final filePath =
                              await DataTransferService.exportData();
                          if (filePath != null) {
                            uiUtilityPackage.showCustomSnackBar(
                              context: context,
                              content: uiUtilityPackage.customText(
                                text: '${AppStrings.exportedTo}: $filePath',
                                fontSize: TextSize.subTitle,
                                overrideColor: appThemeState.themeClass.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                            await Share.shareXFiles(
                              [XFile(filePath)],
                              text: 'Sports Tracker - Players Data',
                              subject: 'Sports Tracker - Players Data',
                            );
                          } else {
                            uiUtilityPackage.showCustomSnackBar(
                              context: context,
                              content: uiUtilityPackage.customText(
                                text: AppStrings.noPlayerExportMessage,
                                fontSize: TextSize.subTitle,
                                overrideColor: appThemeState.themeClass.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        },
                        type: ButtonType.icon,
                        icon: Icons.upload,
                        iconColor: appThemeState.themeClass.white,
                      ),
                    ],
                  ),
                ),

                ///Import Series
                uiUtilityPackage.customCard(
                  color: appThemeState.themeClass.cardBackgroundColor,
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      uiUtilityPackage.customText(
                        text: AppStrings.importSeries,
                        fontSize: TextSize.subTitle,
                        overrideColor: appThemeState.themeClass.white,
                        fontWeight: FontWeight.bold,
                      ),
                      uiUtilityPackage.customButton(
                        onTap: () async {
                          // File picker or manual path
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['json'],
                          );

                          if (result != null) {
                            customPrint.print(
                              message: 'File name: ${result.files.single.name}',
                            );
                            if (result.files.single.name.toLowerCase().contains(
                              'players',
                            )) {
                              uiUtilityPackage.showCustomSnackBar(
                                context: context,
                                backgroundColor:
                                    appThemeState.themeClass.warningColor,
                                content: uiUtilityPackage.customText(
                                  text: AppStrings.wrongFile,
                                  fontSize: TextSize.subTitle,
                                  overrideColor: appThemeState.themeClass.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              String resp =
                                  await DataTransferService.importPlayers(
                                    result.files.single.path!,
                                  );
                              if (resp.isNotEmpty) {
                                context.read<HomeScreenBloc>().add(
                                  ImportDataEvent(
                                    importString: resp,
                                    isPlayerData: false,
                                  ),
                                );
                              }
                              uiUtilityPackage.showCustomSnackBar(
                                context: context,
                                backgroundColor:
                                    resp.isNotEmpty
                                        ? appThemeState.themeClass.successColor
                                        : appThemeState.themeClass.dangerColor,
                                content: uiUtilityPackage.customText(
                                  text:
                                      resp.isNotEmpty
                                          ? AppStrings.seriesImported
                                          : AppStrings.importFailed,
                                  fontSize: TextSize.subTitle,
                                  overrideColor: appThemeState.themeClass.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                        },
                        type: ButtonType.icon,
                        icon: Icons.download,
                        iconColor: appThemeState.themeClass.white,
                      ),
                    ],
                  ),
                ),

                ///Export Series
                uiUtilityPackage.customCard(
                  color: appThemeState.themeClass.cardBackgroundColor,
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      uiUtilityPackage.customText(
                        text: AppStrings.exportSeries,
                        fontSize: TextSize.subTitle,
                        overrideColor: appThemeState.themeClass.white,
                        fontWeight: FontWeight.bold,
                      ),
                      uiUtilityPackage.customButton(
                        onTap: () async {
                          final filePath = await DataTransferService.exportData(
                            isSeries: true,
                          );
                          if (filePath != null) {
                            uiUtilityPackage.showCustomSnackBar(
                              context: context,
                              content: uiUtilityPackage.customText(
                                text: '${AppStrings.exportedTo}: $filePath',
                                fontSize: TextSize.subTitle,
                                overrideColor: appThemeState.themeClass.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                            await Share.shareXFiles(
                              [XFile(filePath)],
                              text: 'Sports Tracker - Series Data',
                              subject: 'Sports Tracker - Series Data',
                            );
                          } else {
                            uiUtilityPackage.showCustomSnackBar(
                              context: context,
                              content: uiUtilityPackage.customText(
                                text: AppStrings.noSeriesExportMessage,
                                fontSize: TextSize.subTitle,
                                overrideColor: appThemeState.themeClass.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        },
                        type: ButtonType.icon,
                        icon: Icons.upload,
                        iconColor: appThemeState.themeClass.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
