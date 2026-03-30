import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/app/app.dart';
import 'package:fresh_leaf/core/bootstrap/app_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  final initialRoute = await AppBootstrap.initialize();
  runApp(FreshLeafApp(initialRoute: initialRoute));
}
