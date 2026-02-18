import 'package:flutter/material.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';

class CustomWidget extends StatelessWidget {
  const CustomWidget({required this.text, required this.onTap, super.key});
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: 200.h,
        child: InkWell(
          onTap: onTap,
          child: Card(
            color: AppColors.whiteColor,
            // width: 100.w,
            // height: 100.h,
            // decoration: BoxDecoration(
            //   color: AppColors.whiteColor,
            //   borderRadius: BorderRadius.circular(16),
            //   border: Border.all(
            //     color: AppColors.primaryColor,
            //   ),
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                ),
                12.verticalSpace,
                Text(
                  text,
                  style: AppTextStyle.style14W900.copyWith(
                    color: AppColors.blackColor.withAlpha(
                      150,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
