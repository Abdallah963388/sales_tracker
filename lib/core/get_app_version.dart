import 'package:package_info_plus/package_info_plus.dart';
import 'package:sales_tracker/core/debug_print_widget.dart';

Future<String> getBuildNumber() async {
  final info = await PackageInfo.fromPlatform();
  debugPrintWidget('Version: ${info.version}');
  debugPrintWidget('Build: ${info.buildNumber}');
  return info.buildNumber;
}

Future<String> getAppVersion() async {
  final info = await PackageInfo.fromPlatform();
  debugPrintWidget('Version: ${info.version}');
  debugPrintWidget('Build: ${info.buildNumber}');
  return info.version;
}
