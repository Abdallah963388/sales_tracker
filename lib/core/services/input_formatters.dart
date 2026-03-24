import 'package:flutter/services.dart';

class AppInputFormatters {
  static final name = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z\u0600-\u06FF0-9\s,.\-]'),
  );

  static final TextInputFormatter phone =
      FilteringTextInputFormatter.digitsOnly;

  static final email = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9@._\-]'),
  );

  static final password = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9!@#\$%^&*()_\-+=.?]'),
  );

  static final businessName = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z\u0600-\u06FF0-9\s]'),
  );

  static final address = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z\u0600-\u06FF0-9\s,.\-]'),
  );
}
