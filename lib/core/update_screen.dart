import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sales_tracker/core/debug_print_widget.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  static const String siteUrl = 'https://sitksa-eg.com/';
  // static const String iosUrl =
  //     'https://apps.apple.com/sa/app/sit-hr/id6756722521';

  Future<void> _launchUpdateUrl(BuildContext context) async {
    final url = Uri.parse(
      Theme.of(context).platform == TargetPlatform.android ? siteUrl : siteUrl,
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrintWidget('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child:
                      Icon(
                            Icons.system_update_rounded,
                            size: 120.w,
                            color: Theme.of(context).primaryColor,
                          )
                          .animate()
                          .scale(duration: 600.ms, curve: Curves.bounceOut)
                          .shake(delay: 800.ms),
                ),

                40.verticalSpace,

                Text(
                  'newUpdateAvailable',
                  style: AppTextStyle.style20Bold.copyWith(fontSize: 24.sp),
                ).animate().fadeIn(delay: 200.ms),
                15.verticalSpace,

                Text(
                  'updateAppMessage',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.style16W500.copyWith(
                    color: Colors.grey[600],
                  ),
                ).animate().fadeIn(delay: 400.ms),

                50.verticalSpace,

                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(
                    onPressed: () => _launchUpdateUrl(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'updateNow',
                      style: AppTextStyle.style18Bold.copyWith(),
                    ),
                  ),
                ).animate().slideY(begin: 0.5, duration: 500.ms).fadeIn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
