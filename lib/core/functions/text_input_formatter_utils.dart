import 'package:flutter/services.dart';

class TextInputFormatterUtils {
  static List<TextInputFormatter> get numbersOnly => numersOnly;
}

List<TextInputFormatter> get numersOnly {
  return <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    TextInputFormatter.withFunction(
      (oldValue, newValue) =>
          newValue.copyWith(text: newValue.text.replaceAll('.', ',')),
    ),
  ];
}
