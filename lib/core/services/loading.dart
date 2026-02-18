import 'package:flutter_easyloading/flutter_easyloading.dart';

import '/../core/constants.dart';
import '/../core/localization/s.dart';

void showLoading() {
  EasyLoading.show(
    status: S.of(navigatorKey.currentContext!)?.localeName ?? 'Loading...',
  );
}

void hideLoading() {
  EasyLoading.dismiss();
}
