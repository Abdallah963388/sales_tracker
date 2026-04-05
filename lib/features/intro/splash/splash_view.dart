import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_tracker/core/cache_helper/cache_helper.dart';
import 'package:sales_tracker/core/cache_helper/cache_values.dart';

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
    final token = await CacheHelper.getSecured(CacheKeys.userToken);
    final isLogin = token?.toString();
    if (isLogin != null && isLogin.isNotEmpty) {
      context.go(AppRoutes.mainLayoutScreen);
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
              width: 200.w,
            ),
          ),
        ],
      ),
    );
  }
}
