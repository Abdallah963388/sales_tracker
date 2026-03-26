// ignore_for_file: unreachable_switch_default

import 'package:flutter/cupertino.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';

import '../constants.dart';

/// ===============================
/// Font base sizes
/// ===============================
const double size9 = 9;
const double size12 = 12;
const double size14 = 14;
const double size16 = 16;
const double size18 = 18;
const double size20 = 20;

/// ===============================
/// Font scale configuration
/// ===============================
class FontScaleConfig {
  static double scale = 1.0;
}

/// ===============================
/// App Text Styles
/// ===============================
abstract class AppTextStyle {
  static String get _fontFamily => latinLang ? kPrimaryEnFont : kPrimaryArFont;

  // ================= size 9 =================
  static TextStyle get style9W300 =>
      _base(phone: size9, tablet: 14, weight: FontWeight.w300);

  static TextStyle get style9W400 =>
      style9W300.copyWith(fontWeight: FontWeight.w400);
  static TextStyle get style9W500 =>
      style9W300.copyWith(fontWeight: FontWeight.w500);
  static TextStyle get style9W600 =>
      style9W300.copyWith(fontWeight: FontWeight.w600);
  static TextStyle get style9W700 =>
      style9W300.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get style9W800 =>
      style9W300.copyWith(fontWeight: FontWeight.w800);
  static TextStyle get style9W900 =>
      style9W300.copyWith(fontWeight: FontWeight.w900);
  static TextStyle get style9Bold =>
      style9W300.copyWith(fontWeight: FontWeight.bold);

  // ================= size 12 =================
  static TextStyle get style12W300 =>
      _base(phone: size12, tablet: 17, weight: FontWeight.w300);

  static TextStyle get style12W400 =>
      style12W300.copyWith(fontWeight: FontWeight.w400);
  static TextStyle get style12W500 =>
      style12W300.copyWith(fontWeight: FontWeight.w500);
  static TextStyle get style12W600 =>
      style12W300.copyWith(fontWeight: FontWeight.w600);
  static TextStyle get style12W700 =>
      style12W300.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get style12W800 =>
      style12W300.copyWith(fontWeight: FontWeight.w800);
  static TextStyle get style12W900 =>
      style12W300.copyWith(fontWeight: FontWeight.w900);
  static TextStyle get style12Bold =>
      style12W300.copyWith(fontWeight: FontWeight.bold);

  // ================= size 14 =================
  static TextStyle get style14W300 =>
      _base(phone: size14, tablet: 19, weight: FontWeight.w300);

  static TextStyle get style14W400 =>
      style14W300.copyWith(fontWeight: FontWeight.w400);
  static TextStyle get style14W500 =>
      style14W300.copyWith(fontWeight: FontWeight.w500);
  static TextStyle get style14W600 =>
      style14W300.copyWith(fontWeight: FontWeight.w600);
  static TextStyle get style14W700 =>
      style14W300.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get style14W800 =>
      style14W300.copyWith(fontWeight: FontWeight.w800);
  static TextStyle get style14W900 =>
      style14W300.copyWith(fontWeight: FontWeight.w900);
  static TextStyle get style14Bold =>
      style14W300.copyWith(fontWeight: FontWeight.bold);

  // ================= size 16 =================
  static TextStyle get style16W300 =>
      _base(phone: size16, tablet: 21, weight: FontWeight.w300);

  static TextStyle get style16W400 =>
      style16W300.copyWith(fontWeight: FontWeight.w400);
  static TextStyle get style16W500 =>
      style16W300.copyWith(fontWeight: FontWeight.w500);
  static TextStyle get style16W600 =>
      style16W300.copyWith(fontWeight: FontWeight.w600);
  static TextStyle get style16W700 =>
      style16W300.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get style16W800 =>
      style16W300.copyWith(fontWeight: FontWeight.w800);
  static TextStyle get style16W900 =>
      style16W300.copyWith(fontWeight: FontWeight.w900);
  static TextStyle get style16Bold =>
      style16W300.copyWith(fontWeight: FontWeight.bold);

  // ================= size 18 =================
  static TextStyle get style18W300 =>
      _base(phone: size18, tablet: 23, weight: FontWeight.w300);

  static TextStyle get style18W400 =>
      style18W300.copyWith(fontWeight: FontWeight.w400);
  static TextStyle get style18W500 =>
      style18W300.copyWith(fontWeight: FontWeight.w500);
  static TextStyle get style18W600 =>
      style18W300.copyWith(fontWeight: FontWeight.w600);
  static TextStyle get style18W700 =>
      style18W300.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get style18W800 =>
      style18W300.copyWith(fontWeight: FontWeight.w800);
  static TextStyle get style18W900 =>
      style18W300.copyWith(fontWeight: FontWeight.w900);
  static TextStyle get style18Bold =>
      style18W300.copyWith(fontWeight: FontWeight.bold);

  // ================= size 20 =================
  static TextStyle get style20W300 =>
      _base(phone: size20, tablet: 25, weight: FontWeight.w300);

  static TextStyle get style20W400 =>
      style20W300.copyWith(fontWeight: FontWeight.w400);
  static TextStyle get style20W500 =>
      style20W300.copyWith(fontWeight: FontWeight.w500);
  static TextStyle get style20W600 =>
      style20W300.copyWith(fontWeight: FontWeight.w600);
  static TextStyle get style20W700 =>
      style20W300.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get style20W800 =>
      style20W300.copyWith(fontWeight: FontWeight.w800);
  static TextStyle get style20W900 =>
      style20W300.copyWith(fontWeight: FontWeight.w900);
  static TextStyle get style20Bold =>
      style20W300.copyWith(fontWeight: FontWeight.bold);

  // ================= base builder =================
  static TextStyle _base({
    required double phone,
    required double tablet,
    required FontWeight weight,
  }) {
    return TextStyle(
      fontSize: SizeConfig.responsiveValue(
        phone: (phone * FontScaleConfig.scale).sp,
        tablet: (tablet * FontScaleConfig.scale).sp,
      ),
      fontWeight: weight,
      fontFamily: _fontFamily,
    );
  }
}
