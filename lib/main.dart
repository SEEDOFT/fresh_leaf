import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/app/app.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/bootstrap/app_bootstrap.dart';
import 'package:fresh_leaf/core/services/deep_link_service.dart';
import 'package:fresh_leaf/core/services/launch_route_service.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  Get.put<LaunchRouteService>(
    LaunchRouteService(await AppBootstrap.initialize()),
    permanent: true,
  );

  runApp(const FreshLeafApp(initialRoute: AppRoutes.splash));

  unawaited(
    Get.find<DeepLinkService>().handleInitialLink(),
  );
}
