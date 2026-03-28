import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  PermissionService._();

  static Future<bool> requestNotification() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      status = await Permission.notification.request();
    }
    return status.isGranted;
  }

  static Future<bool> requestLocation() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied || status.isRestricted || status.isLimited) {
      status = await Permission.locationWhenInUse.request();
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return status.isGranted;
  }

  static Future<void> requestAll() async {
    await [
      Permission.notification,
      Permission.locationWhenInUse,
    ].request();
  }
}
