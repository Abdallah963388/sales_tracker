import 'package:flutter/material.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title = '',
    this.canBack = false,
    this.actions,
    this.bottom,
    this.titleWidget,
    this.toolbarHeight,
  });

  final String title;
  final bool canBack;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Widget? titleWidget;
  final double? toolbarHeight;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
      foregroundColor: Colors.transparent,
      toolbarHeight: toolbarHeight,
      elevation: 0,
      backgroundColor: AppColors.whiteColor,
    
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: AppTextStyle.style16Bold.copyWith(
          color: AppColors.blackColor.withAlpha(200),
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
