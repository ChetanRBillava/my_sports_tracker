import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:my_sports_tracker/core/constants/app_bools.dart';
import 'package:my_sports_tracker/core/constants/app_images.dart';
import 'package:ui_utility_package/enums.dart';
import 'package:ui_utility_package/ui_utility_package.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../logics/cubits/app_theme_cubit.dart';
import '../../../router/app_router.dart';
import '../../home/widgets/player_tile_widget.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  static final UiUtilityPackage uiUtilityPackage = UiUtilityPackage();

  String getImage() {
    return AppBools.forceUpdate ? AppImages.update : AppImages.maintenance;
  }

  String getMessage() {
    return AppBools.forceUpdate
        ? AppStrings.forceUpdateMessage
        : AppStrings.maintenanceScreenMessage;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeState>(
      builder: (context, appThemeState) {
        return Scaffold(
          backgroundColor: appThemeState.themeClass.backgroundColor,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: appThemeState.themeClass.appbarBackgroundColor,
            title: uiUtilityPackage.customText(
              text: AppStrings.maintenanceScreenTitle,
              fontSize: TextSize.title,
              overrideColor: appThemeState.themeClass.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  getImage(),
                  width: MediaQuery.sizeOf(context).width * .75,
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: uiUtilityPackage.customText(
                    text: getMessage(),
                    fontSize: TextSize.normal,
                    overrideColor: appThemeState.themeClass.textColor_1,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
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
