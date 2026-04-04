import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_payment_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';
import 'package:get/get.dart';

class ProfilePaymentView extends GetView<ProfilePaymentController> {
  const ProfilePaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ProfileAppBar(title: 'payment_methods'.tr),
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: controller.refreshPaymentMethods,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              children: [
                ProfilePaymentHeader(
                  onAddTap: controller.openAddPaymentMethod,
                  isLoading: controller.isLoading.value,
                ),
                const SizedBox(height: 12),
                _buildContent(
                  context: context,
                  isLoading: controller.isLoading.value,
                  methods: controller.methods,
                  processingId: controller.processingId.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required bool isLoading,
    required List<PaymentMethod> methods,
    required String processingId,
  }) {
    final media = MediaQuery.of(context);

    if (isLoading && methods.isEmpty) {
      return SizedBox(
        height: media.size.height * 0.3,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (methods.isEmpty) {
      return const ProfilePaymentEmptyState();
    }

    return Column(
      children: methods
          .map<Widget>(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ProfilePaymentMethodCard(
                paymentMethod: item,
                isProcessing: processingId == item.id.toString(),
                onEdit: () => controller.openEditPaymentMethod(item),
                onSetDefault: () => controller.setDefault(item),
                onRemove: () => controller.remove(item),
              ),
            ),
          )
          .toList(),
    );
  }
}
