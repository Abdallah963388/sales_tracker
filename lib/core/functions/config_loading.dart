import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sit/core/constants.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/shared_widgets/custom_progress_indicator.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';

void configLoading(BuildContext context) {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..contentPadding = EdgeInsets.all(16.r)
    ..radius = 10.r
    // ..indicatorSize = 65.r
    ..indicatorWidget = SizedBox(
      width: 60.w,
      child: const LoadingWidget(color: AppColors.whiteColor),
    )
    ..backgroundColor = AppColors.primaryColor
    ..indicatorColor = AppColors.whiteColor
    ..textColor = AppColors.whiteColor
    ..maskColor = AppColors.primaryDarkColor.withAlpha(120)
    ..dismissOnTap = false
    ..textStyle = AppTextStyle.style14W800.copyWith(color: AppColors.whiteColor)
    ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = false;
}

/// Show loading indicator
void showLoading() {
  EasyLoading.show(status: S.of(navigatorKey.currentContext!)!.loading);
}

void hideLoading() {
  EasyLoading.dismiss();
}
