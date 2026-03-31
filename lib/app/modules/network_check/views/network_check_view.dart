import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/network_check/controllers/network_check_controller.dart';
import 'package:fresh_leaf/app/modules/network_check/widgets/network_check_widget.dart';
import 'package:get/get.dart';

class NetworkCheckView extends GetView<NetworkCheckController> {
  const NetworkCheckView({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Obx(
              () => Container(
                width: media.size.width,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: scheme.outline.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NetworkStatusIcon(
                      isOnline: controller.isOnline.value,
                      isChecking: controller.isChecking.value,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      controller.isOnline.value
                          ? 'internet_connected'.tr
                          : 'no_internet_connection'.tr,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.isOnline.value
                          ? 'ready_to_continue_login'.tr
                          : 'connect_internet_to_continue'.tr,
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 14,
                        height: 1.35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: media.size.width,
                      child: ElevatedButton.icon(
                        onPressed: controller.isChecking.value
                            ? null
                            : controller.checkConnection,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text('check_again'.tr),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(media.size.width, 50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: media.size.width,
                      child: OutlinedButton(
                        onPressed: controller.isOnline.value
                            ? controller.continueToLogin
                            : null,
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(media.size.width, 50),
                        ),
                        child: Text('continue_to_login'.tr),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
