import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/core/cache_helper/cache_helper.dart';
import 'package:sit/core/cache_helper/cache_values.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/routing/app_routes.dart';
import 'package:sit/core/theme/app_images.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool _hasRedirected = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _redirect();
    });
  }

  Future<void> _redirect() async {
    if (_hasRedirected || !mounted) return;
    _hasRedirected = true;
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final hasSeenOnboarding = CacheHelper.get<bool>(CacheKeys.isFirstOpen);
    if (hasSeenOnboarding == null) {
      context.go(AppRoutes.onBoardingScreen);
    } else {
      context.go(AppRoutes.mainlayout);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              AppImages.salesAppLogo,
              fit: BoxFit.cover,
              height: 190.h,
              width: 190.w,
            ),
          ),
        ],
      ),
    );
  }
}
