import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_tracker/core/localization/s.dart';

import '/../core/responsive/responsive_config.dart';
import '/../core/theme/app_colors.dart';
import '/../core/theme/app_text_style.dart';
import '/../features/my_app/controller/localization_cubit/localization_cubit.dart';

class AppSettingsView extends StatefulWidget {
  const AppSettingsView({super.key});

  @override
  State<AppSettingsView> createState() => _AppSettingsViewState();
}

class _AppSettingsViewState extends State<AppSettingsView> {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return Scaffold(
      // استخدام CustomAppBar الخاص بك
      appBar: AppBar(
        title: Text(s.appLanguage),
        centerTitle: true,
        toolbarHeight: 60.h,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Text(
                s.changeLanguage,
                style: AppTextStyle.style16W600,
              ),
              20.verticalSpace,

              // تغيير BlocBuilder ليتعامل مع LocalizationCubit
              BlocBuilder<LocalizationCubit, LocalizationState>(
                builder: (context, state) {
                  return Directionality(
                    textDirection:
                        TextDirection.ltr, // ليبقى ترتيب الكروت ثابتاً
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // كارت اللغة الإنجليزية
                        _buildLanguageCard(
                          context: context,
                          label: 'English',
                          langCode: 'en',
                          currentLang: state.locale.languageCode,
                          imagePath: 'assets/images/en_l.png',
                        ),
                        16.horizontalSpace,
                        // كارت اللغة العربية
                        _buildLanguageCard(
                          context: context,
                          label: 'عربي',
                          langCode: 'ar',
                          currentLang: state.locale.languageCode,
                          imagePath: 'assets/images/ar_l.png',
                        ),
                      ],
                    ),
                  );
                },
              ),

              30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت بناء كارت اللغة لتقليل تكرار الكود
  Widget _buildLanguageCard({
    required BuildContext context,
    required String label,
    required String langCode,
    required String currentLang,
    required String imagePath,
  }) {
    final isSelected = currentLang == langCode;

    return Expanded(
      child: InkWell(
        onTap: () {
          // استدعاء الكوبيت لتغيير اللغة وحفظها في الكاش
          context.read<LocalizationCubit>().changeLanguage(Locale(langCode));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              width: 1.5,
            ),
            color: isSelected
                ? AppColors.primaryColor.withAlpha(20)
                : AppColors.secondaryColor.withAlpha(20),
          ),
          child: Column(
            children: [
              // هنا يمكنك وضع منطق الـ Stack والصور كما في كودك الأصلي
              Icon(
                Icons.language,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor,
                size: 40.r,
              ),
              10.verticalSpace,
              Text(
                label,
                style: AppTextStyle.style14W700.copyWith(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.forthColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
