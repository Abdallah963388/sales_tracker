import 'package:flutter/material.dart';

import '/../core/init/initializer.dart';
import '/../features/my_app/my_app.dart';

void main() async {
  // await Hive.initFlutter();
  // Hive.registerAdapter(ClientModelAdapter());
  // await Hive.openBox<ClientModel>('clientsBox');
  await initializeApp();
  runApp(const MyApp());
}
