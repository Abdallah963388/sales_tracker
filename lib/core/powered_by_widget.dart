import 'package:flutter/material.dart';
import 'package:sit/core/debug_print_widget.dart';
import 'package:sit/core/get_app_version.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/core/update_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class PoweredByWidget extends StatelessWidget {
  const PoweredByWidget({super.key});

  Future<void> _launchUpdateUrl(BuildContext context) async {
    final url = Uri.parse(
      // Theme.of(context).platform == TargetPlatform.iOS
      // ?
      UpdateScreen.siteUrl,
      // : UpdateScreen.androidUrl,
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrintWidget('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 30.h),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onLongPress: () => _launchUpdateUrl(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Powered by',
                    style: AppTextStyle.style9W700.copyWith(
                      fontSize: 9.sp,
                      color: AppColors.blackColor.withAlpha(150),
                    ),
                  ),
                  2.horizontalSpace,
                  Image.asset('assets/images/png/logo.png', height: 50.h),
                ],
              ),
              2.verticalSpace,
              FutureBuilder<String>(
                future: getAppVersion(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  } else if (snapshot.hasError) {
                    return const Text('');
                  } else {
                    return Text(
                      '${'Version number'}: ${snapshot.data}',
                      style: AppTextStyle.style9W600.copyWith(
                        fontSize: 9.sp,
                        color: AppColors.blackColor.withAlpha(150),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
