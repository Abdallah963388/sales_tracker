import 'package:flutter/material.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';

class CustomDropdownField<T> extends StatelessWidget {
  const CustomDropdownField({
    required this.items,
    super.key,
    this.label,
    this.hint,
    this.value,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.prefix,
    this.suffix,
  });

  final String? label;
  final String? hint;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final T? initialValue;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final Widget? prefix;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyle.style14W600.copyWith(
              color: AppColors.blackColor.withAlpha(100),
            ),
          ),
          6.verticalSpace,
        ],
        DropdownButtonFormField<T>(
          initialValue: initialValue,
          items: items,
          onChanged: enabled ? onChanged : null,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint ?? '',
            hintStyle: AppTextStyle.style14W500.copyWith(
              color: AppColors.blackColor.withAlpha(50),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            prefixIcon: prefix,
            suffixIcon: suffix,
          ),
          style: AppTextStyle.style14W600.copyWith(color: AppColors.blackColor),
        ),
      ],
    );
  }
}
