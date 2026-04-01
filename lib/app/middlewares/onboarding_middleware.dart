import 'package:flutter/widgets.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class OnboardingMiddleware extends GetMiddleware {
  OnboardingMiddleware({this.priorityValue = 0});

  final int priorityValue;

  @override
  int? get priority => priorityValue;

  @override
  RouteSettings? redirect(String? route) {
    final storage = Get.find<StorageService>();
    if (!storage.onboardingSeen) return null;

    final hasToken = storage.token?.isNotEmpty ?? false;
    return RouteSettings(
      name: hasToken ? AppRoutes.dashboard : AppRoutes.login,
    );
  }
}
