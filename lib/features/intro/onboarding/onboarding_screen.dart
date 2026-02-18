import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/../core/cache_helper/cache_helper.dart';
import '/../core/cache_helper/cache_values.dart';
import '/../core/localization/s.dart';
import '/../core/resources/assets/app_images.dart';
import '/../core/responsive/responsive_config.dart';
import '/../core/routing/app_routes.dart';
import '/../core/shared_widgets/custom_primary_button.dart';
import '/../core/theme/app_colors.dart';
import '/../core/theme/app_text_style.dart';
import '/../features/intro/onboarding/cubit/onboarding_cubit.dart';
import '/../features/intro/onboarding/widgets/app_journey_dot.dart';
import '/../features/intro/onboarding/widgets/onboarding_text.dart';
import '/../features/intro/onboarding/widgets/skip_button.dart';
import '/../features/my_app/controller/localization_cubit/localization_cubit.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizationCubit = context.read<LocalizationCubit>();
    final s = S.of(context)!;
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, state) {
        final onboardingCubit = context.read<OnboardingCubit>();
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: 3,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: onboardingCubit.setOnBoardingIndex,
                  itemBuilder: (context, index) {
                    final images = [
                      AppImages.onboarding1Image,
                      AppImages.onboarding2Image,
                      AppImages.onboarding3Image,
                    ];

                    return Stack(
                      children: [
                        // Image
                        Positioned(
                          bottom: SizeConfig.screenHeight / 2.4,
                          right: 20.w,
                          left: 20.w,
                          child: Image.asset(
                            // height: 340.h,
                            images[index],
                            fit: BoxFit.contain,
                            width: double.infinity,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // Top bar
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final newLang = CacheHelper.getLanguage() == 'ar'
                              ? 'en'
                              : 'ar';
                          await localizationCubit.changeLanguage(
                            Locale(newLang),
                          );
                        },
                        child: Text(
                          s.lang,
                          style: AppTextStyle.style16W500.copyWith(
                            color: AppColors.scaffoldBackgroundLightColor,
                            fontSize: SizeConfig.responsiveValue(
                              phone: 12.sp,
                              tablet: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      if (onboardingCubit.onBoardingIndex != 2)
                        const SkipButton(),
                    ],
                  ),
                ),
                // Bottom content
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        20.verticalSpace,
                        const IgnorePointer(
                          child: OnBoardingText(),
                        ),
                        50.verticalSpace,
                        SizedBox(
                          height: 15.h,
                          child: CustomJourneyDot(
                            onDotClicked: (int index) {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            activeIndex: onboardingCubit.onBoardingIndex,
                            count: 3,
                          ),
                        ),
                        30.verticalSpace,
                        CustomPrimaryButton(
                          text: onboardingCubit.onBoardingIndex == 2
                              ? s.skip
                              : s.next,
                          onPressed: () {
                            if (onboardingCubit.onBoardingIndex == 2) {
                              CacheHelper.set(
                                CacheKeys.isFirstOpen,
                                true,
                              );
                              context.pushReplacementNamed(
                                AppRoutes.loginScreen,
                              );
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                        32.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
