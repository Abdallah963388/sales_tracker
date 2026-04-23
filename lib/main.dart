import 'package:flutter/material.dart';

import 'package:sit/core/init/initializer.dart';
import 'package:sit/features/my_app/my_app.dart';

void main() async {
  await initializeApp();
  runApp(const MyApp());
}
