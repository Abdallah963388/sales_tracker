import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/../core/cache_helper/cache_helper.dart';
import '/../core/cache_helper/cache_values.dart';
import '/../core/localization/s.dart';
import '/../core/responsive/responsive_config.dart';
import '/../core/routing/app_routes.dart';
import '/../core/theme/app_colors.dart';
import '/../core/theme/app_text_style.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushReplacementNamed(AppRoutes.loginScreen);
        CacheHelper.set(CacheKeys.isFirstOpen, true);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Align(
          alignment: Alignment.topRight,
          child: Text(
            S.of(context)!.skip,
            style: AppTextStyle.style16W500.copyWith(
              color: AppColors.scaffoldBackgroundLightColor,
              fontSize: SizeConfig.responsiveValue(phone: 12.sp, tablet: 16.sp),
            ),
          ),
        ),
      ),
    );
  }
}
