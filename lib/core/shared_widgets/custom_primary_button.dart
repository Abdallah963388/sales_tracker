import 'package:flutter/material.dart';
import 'package:sit/core/constants.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';

class CustomPrimaryButton extends StatelessWidget {
  const CustomPrimaryButton({
    required this.text,
    super.key,
    this.onPressed,
    this.width,
    this.height,
    this.icon,
  });
  final void Function()? onPressed;
  final String text;
  final double? width;
  final double? height;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.primaryColor),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: WidgetStateProperty.all(
            Size(width ?? 300.w, height ?? 52.h),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadus)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppTextStyle.style16W700.copyWith(
                color: AppColors.scaffoldBackgroundLightColor,
              ),
            ),
        if (icon!=null) Icon(
              icon,
              color: AppColors.whiteColor,
              size: 24.r,
            ) else const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
