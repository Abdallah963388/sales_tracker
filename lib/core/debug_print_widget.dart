// ignore_for_file: strict_top_level_inference

import 'dart:developer';

import 'package:flutter/foundation.dart';

void debugPrintWidget(dynamic text) {
  if (kDebugMode) {
    log(text.toString());
  }
}
