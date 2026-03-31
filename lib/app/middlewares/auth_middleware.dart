import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';

class AuthMiddleware extends GetMiddleware {
  AuthMiddleware({this.priorityValue = 0});

  final int priorityValue;

  @override
  int? get priority => priorityValue;

  @override
  RouteSettings? redirect(String? route) {
    final storage = Get.find<StorageService>();
    final hasToken = storage.token?.isNotEmpty == true;
    if (hasToken) return null;
    return const RouteSettings(name: AppRoutes.login);
  }
}
