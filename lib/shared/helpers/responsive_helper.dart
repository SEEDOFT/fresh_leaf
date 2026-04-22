import 'package:get/get.dart';

extension ResponsiveExtension on num {
  /// Returns a proportionally scaled value based on the current screen width.
  ///
  /// The scale factor is calculated as `(Get.width / 390).clamp(0.85, 1.1)`.
  /// This ensures that elements scale down gracefully on smaller screens
  /// (~360px - 375px) while maintaining original design proportions on
  /// common and large screens (390px - 430px+).
  double get scaled {
    final scaleFactor = (Get.width / 390).clamp(0.85, 1.1);
    return this * scaleFactor;
  }
}
