import 'package:flutter/material.dart';
import 'package:sit/core/theme/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.size, this.color});
  final double? size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? AppColors.primaryColor, //.withAlpha(100),
      ),
    );
  }
}
