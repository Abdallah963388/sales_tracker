import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/core/cache_helper/cache_helper.dart';
import 'package:sit/core/cache_helper/cache_values.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/routing/app_routes.dart';
import 'package:sit/core/shared_widgets/custom_primary_button.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_images.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/features/intro/onboarding/cubit/onboarding_cubit.dart';
import 'package:sit/features/intro/onboarding/widgets/app_journey_dot.dart';
import 'package:sit/features/intro/onboarding/widgets/onboarding_text.dart';
import 'package:sit/features/intro/onboarding/widgets/skip_button.dart';
import 'package:sit/features/sales_features/my_app/controller/localization_cubit/localization_cubit.dart';

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
          backgroundColor: AppColors.primaryColor,
          body: SafeArea(
            bottom: false,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: SizeConfig.screenHeight / 2.3,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: CacheHelper.getLanguage() == 'en'
                            ? Radius.circular(100.r)
                            : Radius.zero,
                        bottomLeft: CacheHelper.getLanguage() == 'ar'
                            ? Radius.circular(100.r)
                            : Radius.zero,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0.h,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    alignment: Alignment.topLeft,
                    AppImages.onboardLeftBG,
                  ),
                ),
                Positioned(
                  top: 0.h,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    alignment: Alignment.topRight,
                    AppImages.onboardRightBG,
                  ),
                ),
                PageView.builder(
                  controller: _pageController,
                  itemCount: 3,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: onboardingCubit.setOnBoardingIndex,
                  itemBuilder: (context, index) {
                    final images = [
                      AppImages.onboard1,
                      AppImages.onboard2,
                      AppImages.onboard3,
                    ];

                    return Stack(
                      children: [
                        // Image
                        Positioned(
                          bottom: SizeConfig.screenHeight / 2.4,
                          right: 0,
                          left: 0,
                          child: Image.asset(
                            // height: 340.h,
                            images[index],
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            height: SizeConfig.screenHeight / 2.3,
                            decoration: BoxDecoration(
                              color: AppColors.scaffoldBackgroundLightColor,
                              borderRadius: BorderRadius.only(
                                topLeft: CacheHelper.getLanguage() == 'en'
                                    ? Radius.circular(100.r)
                                    : Radius.zero,
                                topRight: CacheHelper.getLanguage() == 'ar'
                                    ? Radius.circular(100.r)
                                    : Radius.zero,
                              ),
                            ),
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
                        const OnBoardingText(),
                        50.verticalSpace,
                        SizedBox(
                          height: 15.h,
                          child: CustomJourneyDot(
                            activeIndex: onboardingCubit.onBoardingIndex,
                            count: 3,
                          ),
                        ),
                        30.verticalSpace,
                        CustomPrimaryButton(
                          text: onboardingCubit.onBoardingIndex == 2
                              ? s.exploreOurWork
                              : s.next,
                          onPressed: () {
                            if (onboardingCubit.onBoardingIndex == 2) {
                              CacheHelper.set(
                                CacheKeys.isFirstOpen,
                                true,
                              );
                              context.pushReplacementNamed(
                                AppRoutes.mainlayout,
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
