import 'package:flutter/material.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/theme/app_colors.dart';

class CustomJourneyDot extends StatelessWidget {
  const CustomJourneyDot({
    required this.activeIndex,
    required this.count,
    super.key,
  });
  final int activeIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 10.h,
              width: activeIndex == index ? 22.w : 12.w,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(15.w),
              ),
            ),
          );
        },
      ),
    );
  }
}
