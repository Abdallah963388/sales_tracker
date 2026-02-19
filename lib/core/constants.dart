import 'package:flutter/material.dart';

import '../core/responsive/responsive_config.dart';
import './cache_helper/cache_helper.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final double radius = 30.r;
const kPrimaryEnFont = 'Almarai';
const kPrimaryArFont = 'Almarai';
final bool latinLang = (CacheHelper.getLanguage() == 'en');
