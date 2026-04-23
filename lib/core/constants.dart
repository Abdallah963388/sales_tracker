import 'package:flutter/material.dart';
import 'package:sit/core/cache_helper/cache_helper.dart';
import 'package:sit/core/responsive/responsive_config.dart';

int mainLayoutIntitalScreenIndex = 0;

final navigatorKey = GlobalKey<NavigatorState>();
// const kPrimaryFont = 'Almarai';
final double kRadus = 15.r;

final double radius = 30.r;
const kPrimaryEnFont = 'Almarai';
const kPrimaryArFont = 'Almarai';
final bool latinLang = (CacheHelper.getLanguage() == 'en');
