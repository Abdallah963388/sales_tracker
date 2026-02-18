import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../responsive/responsive_config.dart';

void customToast({required String msg, required Color color, int? time}) =>
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: time ?? 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0.sp,
    );
