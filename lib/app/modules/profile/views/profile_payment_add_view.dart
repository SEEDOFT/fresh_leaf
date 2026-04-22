import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_payment_add_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class ProfilePaymentAddView extends GetView<ProfilePaymentAddController> {
  const ProfilePaymentAddView({super.key});

  static const double _gap12 = 12;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final keyboardBottomInset = media.viewInsets.bottom;
    final bottomSafeArea = media.padding.bottom;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: CustomAppBar(
        title: controller.isEditMode
            ? 'edit_payment_method'.tr
            : 'add_payment_method'.tr,
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, _gap12, 16, _gap12),
          children: [
            Container(
              width: media.size.width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: scheme.primary.withValues(alpha: 0.18),
                ),
              ),
              child: Obx(
                () => Text(
                  controller.requiresDetails
                      ? (controller.isEditMode
                            ? 'payment_edit_hint'.tr
                            : 'payment_security_hint'.tr)
                      : 'bank_channel_payment_hint'.tr,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ),
            ),
            const SizedBox(height: _gap12),
            ProfilePaymentAddForm(controller: controller),
            const SizedBox(height: 88),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: EdgeInsets.fromLTRB(
          16,
          10,
          16,
          keyboardBottomInset > 0
              ? keyboardBottomInset + 10
              : bottomSafeArea + 10,
        ),
        child: Obx(
          () => ProfilePrimaryActionButton(
            label: controller.isEditMode
                ? 'update_payment_method'.tr
                : 'save_payment_method'.tr,
            onPressed: controller.submit,
            isLoading: controller.isSaving.value,
          ),
        ),
      ),
    );
  }
}
