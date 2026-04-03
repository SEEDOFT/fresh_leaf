import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_payment_add_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:get/get.dart';

class ProfilePaymentAddView extends GetView<ProfilePaymentAddController> {
  const ProfilePaymentAddView({super.key});

  static const double _gap12 = 12;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: ProfileAppBar(
        title: controller.isEditMode
            ? 'Edit payment method'
            : 'Add payment method',
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
              child: Text(
                controller.isEditMode
                    ? 'Update the details below. '
                          'Leave card number empty to keep current card.'
                    : 'Your card data is used only for checkout '
                          'and secure payment processing.',
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(height: _gap12),
            ProfilePaymentAddForm(controller: controller),
            const SizedBox(height: _gap12),
            Obx(
              () => ProfilePrimaryActionButton(
                label: controller.isEditMode
                    ? 'Update payment method'
                    : 'Save payment method',
                onPressed: controller.submit,
                isLoading: controller.isSaving.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
