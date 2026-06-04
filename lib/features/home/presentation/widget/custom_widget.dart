import 'package:flutter/material.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';


class CustomWidget extends StatelessWidget {
  const CustomWidget({required this.text, required this.onTap, super.key});
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withAlpha(30),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],

          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(24.r),
        ),
        width: double.infinity,
        height: 80.h,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 30.r,
                color: AppColors.whiteColor,
              ),
              12.verticalSpace,
              Text(
                text,
                style: AppTextStyle.style14W800.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
