import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/../core/responsive/responsive_config.dart';
import '/../core/routing/app_routes.dart';
import '/../core/theme/app_colors.dart';
import '/../core/theme/app_text_style.dart';
import '/../features/my_app/maintenance/cubit/maintenance_cubit.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MaintenanceCubit, MaintenanceState>(
        listener: (context, state) {
          if (state is MaintenanceResolved) {
            // السيرفر عاد للعمل! وجه المستخدم للرئيسية أو Login حسب المنطق
            // GoRouter.of(context).goNamed(AppRoutes.homeScreen);
            // أو ببساطة العودة للخلف إذا كان الـ Navigation Stack يسمح
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(
                AppRoutes.mainLayoutScreen,
              );
            }
          }

          if (state is MaintenanceStillActive) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.settings_suggest_rounded,
                  size: 100.r,
                  color: AppColors.primaryColor,
                ),
                32.verticalSpace,
                Text(
                  'تحت الصيانة',
                  style: AppTextStyle.style20Bold.copyWith(fontSize: 24.sp),
                ),
                16.verticalSpace,
                Text(
                  'نواجه حالياً بعض التحديثات في السيرفر لتحسين الخدمة.\nيرجى المحاولة مرة أخرى بعد قليل.',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.style14W500.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
                48.verticalSpace,

                if (state is MaintenanceLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MaintenanceCubit>().checkServerStatus();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'تحديث الحالة',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.w,
                        vertical: 15.h,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
