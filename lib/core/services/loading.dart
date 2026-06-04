import 'package:flutter_easyloading/flutter_easyloading.dart';

void showLoading() {
  EasyLoading.show(
    status: 'جاري التحميل...',
  );
}

///navigatorKey.currentContext!
void hideLoading() {
  EasyLoading.dismiss();
}
