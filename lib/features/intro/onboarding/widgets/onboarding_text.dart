import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/../core/localization/s.dart';
import '/../core/responsive/responsive_config.dart';
import '/../core/theme/app_colors.dart';
import '/../core/theme/app_text_style.dart';
import '/../features/intro/onboarding/cubit/onboarding_cubit.dart';

class OnBoardingText extends StatelessWidget {
  const OnBoardingText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.topCenter,
          child: Text(
            textAlign: TextAlign.center,
            context.read<OnboardingCubit>().onBoardingIndex == 0
                ? S.of(context)!.onboard1Title
                : context.read<OnboardingCubit>().onBoardingIndex == 1
                ? S.of(context)!.onboard2Title
                : S.of(context)!.onboard3Title,
            style: AppTextStyle.style20W700.copyWith(
              color: AppColors.forthColor,
              fontSize: SizeConfig.responsiveValue(
                phone: 20.sp,
                tablet: 22.sp,
              ),
            ),
          ),
        );
      },
    );
  }
}
