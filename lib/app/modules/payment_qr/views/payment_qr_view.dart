import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/payment_qr/controllers/payment_qr_controller.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class PaymentQrView extends GetView<PaymentQrController> {
  const PaymentQrView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(title: 'scan_qr_to_pay'.tr),
      body: Obx(() {
        final session = controller.session.value;
        if (session == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: scheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    if ((session.qrImageUrl ?? '').isNotEmpty)
                      Image.network(
                        session.qrImageUrl!,
                        height: 220,
                        width: 220,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) =>
                            _qrFallback(session.qrPayload),
                      )
                    else
                      _qrFallback(session.qrPayload),
                    const SizedBox(height: 12),
                    Text(
                      'check_payment_status'.tr,
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: controller.isExpired
                      ? scheme.errorContainer.withValues(alpha: 0.7)
                      : scheme.primaryContainer.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  controller.isExpired
                      ? 'payment_session_expired'.tr
                      : '${'expires_in'.tr}:'
                            ' ${controller.remainingSeconds.value}s',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: controller.isExpired
                        ? scheme.onErrorContainer
                        : scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: controller.isChecking.value || controller.isExpired
                      ? null
                      : controller.refreshStatus,
                  child: controller.isChecking.value
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('i_have_paid_check_status'.tr),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _qrFallback(String? payload) {
    return Container(
      width: 220,
      height: 220,
      alignment: Alignment.center,
      child: SelectableText(
        (payload ?? '').isEmpty ? 'scan_qr_to_pay'.tr : payload!,
        textAlign: TextAlign.center,
      ),
    );
  }
}
