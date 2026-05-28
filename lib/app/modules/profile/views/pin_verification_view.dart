import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/pin_verification_controller.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:fresh_leaf/shared/widgets/dialpad_widget.dart';
import 'package:fresh_leaf/shared/widgets/pin_display_widget.dart';
import 'package:get/get.dart';

class PinVerificationView extends GetView<PinVerificationController> {
  const PinVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'pin_verification'.tr,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'enter_your_pin'.tr,
                    style: TextStyle(
                      fontSize: 22.scaled,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.scaled),
                  Text(
                    'enter_pin_to_continue'.tr,
                    style: TextStyle(
                      fontSize: 14.scaled,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 32.scaled),
                  Obx(
                    () => controller.isLoading.value
                        ? SizedBox(
                            height: 16.scaled,
                            width: 16.scaled,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5.scaled,
                              color: scheme.primary,
                            ),
                          )
                        : PinDisplayWidget(
                            pinLength: controller.pin.value.length,
                            hasError: controller.hasError.value,
                          ),
                  ),
                ],
              ),
            ),
            DialpadWidget(
              onKeyPressed: controller.onKeyPressed,
              onDeletePressed: controller.onDeletePressed,
            ),
            SizedBox(height: 32.scaled),
          ],
        ),
      ),
    );
  }
}
