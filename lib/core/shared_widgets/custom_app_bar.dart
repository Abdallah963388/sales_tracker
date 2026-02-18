import 'package:flutter/material.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title = '',
    this.canBack = true,
    this.actions,
    this.bottom,
    this.toolbarHeight,
  });

  final String title;
  final bool canBack;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double? toolbarHeight;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
      foregroundColor: Colors.transparent,
      toolbarHeight: toolbarHeight,
      elevation: 0,
      backgroundColor: AppColors.whiteColor,
      leading: canBack
          ? IconButton(
              icon: Icon(
                size: SizeConfig.responsiveValue(phone: 16.sp, tablet: 24.sp),
                Icons.arrow_back_ios_new,
                color: AppColors.primaryDarkColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : const SizedBox(),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: AppTextStyle.style16Bold.copyWith(
          color: AppColors.primaryDarkColor,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15.r),
          bottomLeft: Radius.circular(15.r),
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    SizeConfig.responsiveValue(
      phone: toolbarHeight ?? 56.h,
      tablet: toolbarHeight ?? 100.h,
    ),
  );
}
