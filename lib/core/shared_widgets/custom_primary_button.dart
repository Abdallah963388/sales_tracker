import 'package:flutter/material.dart';

import '../responsive/responsive_config.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';

class CustomPrimaryButton extends StatelessWidget {
  const CustomPrimaryButton({
    required this.text,
    this.icon,
    super.key,
    this.onPressed,
    this.width,
    this.height,
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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            Icon(
              icon,
              color: AppColors.whiteColor,
              size: 24.r,
            ),
          ],
        ),
      ),
    );
  }
}
