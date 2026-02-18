import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/../core/cache_helper/cache_helper.dart';
import '/../core/cache_helper/cache_values.dart';
import '/../core/resources/assets/app_images.dart';
import '/../core/responsive/responsive_config.dart';
import '/../core/routing/app_routes.dart';

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
      context.go(AppRoutes.loginScreen);
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
              AppImages.appLogo,
              fit: BoxFit.cover,
              width: SizeConfig.screenWidth * 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
