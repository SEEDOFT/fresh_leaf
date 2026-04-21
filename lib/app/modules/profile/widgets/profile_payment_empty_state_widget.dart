import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_empty_state.dart';
import 'package:get/get.dart';

class ProfilePaymentEmptyState extends StatelessWidget {
  const ProfilePaymentEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.credit_card_off_outlined,
      title: 'no_payment_methods_yet'.tr,
      subtitle: 'add_card_wallet_speed_checkout'.tr,
    );
  }
}
