import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/'
    'profile_payment_add_controller.dart';
import 'package:fresh_leaf/shared/widgets/app_badge.dart';
import 'package:fresh_leaf/shared/widgets/app_text_field.dart';
import 'package:get/get.dart';

class ProfilePaymentAddForm extends StatelessWidget {
  const ProfilePaymentAddForm({
    required this.controller,
    super.key,
  });

  static const double _gap12 = 12;

  final ProfilePaymentAddController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context);

    return Container(
      width: media.size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  controller.isEditMode
                      ? 'edit_card_details'.tr
                      : 'card_details'.tr,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              Obx(
                () => _CardTypeBadge(
                  cardType: controller.cardType.value,
                  logoAsset: controller.cardLogoAsset,
                ),
              ),
            ],
          ),
          const SizedBox(height: _gap12),
          AppTextField(
            label: 'card_holder_name'.tr,
            hintText: 'placeholder_name'.tr,
            controller: controller.holderNameController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: _gap12),
          Obx(
            () => AppTextField(
              label: controller.isEditMode
                  ? 'card_number_optional'.tr
                  : 'card_number'.tr,
              hintText: controller.isEditMode
                  ? 'card_number_optional_hint'.tr
                  : '4242 4242 4242 4242',
              controller: controller.cardNumberController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onChanged: controller.onCardNumberChanged,
              inputFormatters: controller.cardNumberInputFormatters,
            ),
          ),
          Obx(
            () => controller.cardValidationMessage.value.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: _gap12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        controller.cardValidationMessage.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: scheme.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: _gap12),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'expiry'.tr,
                  hintText: 'MM/YY',
                  controller: controller.expiryController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onChanged: controller.onExpiryChanged,
                  inputFormatters: controller.expiryInputFormatters,
                ),
              ),
              const SizedBox(width: _gap12),
              Expanded(
                child: AppTextField(
                  label: 'cvv'.tr,
                  hintText: controller.isEditMode ? 'optional'.tr : '123',
                  controller: controller.cvvController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: controller.cvvInputFormatters,
                ),
              ),
            ],
          ),
          const SizedBox(height: _gap12),
          AppTextField(
            label: 'billing_address'.tr,
            hintText: 'placeholder_billing_address'.tr,
            controller: controller.billingAddressController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: _gap12),
          AppTextField(
            label: 'city'.tr,
            hintText: 'placeholder_city'.tr,
            controller: controller.billingCityController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: _gap12),
          AppTextField(
            label: 'province'.tr,
            hintText: 'placeholder_province'.tr,
            controller: controller.billingStateController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: _gap12),
          AppTextField(
            label: 'postal_code'.tr,
            hintText: 'placeholder_postal_code'.tr,
            controller: controller.billingZipCodeController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: _gap12),
          Obx(
            () => SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: controller.setAsDefault.value,
              onChanged: controller.canSetAsDefault.value
                  ? (value) => controller.setAsDefault.value = value
                  : null,
              title: Text('set_default_payment_method'.tr),
              subtitle: controller.canSetAsDefault.value
                  ? null
                  : Text('default_payment_exists'.tr),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardTypeBadge extends StatelessWidget {
  const _CardTypeBadge({
    required this.cardType,
    required this.logoAsset,
  });

  final String cardType;
  final String? logoAsset;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (logoAsset != null) {
      return Container(
        width: 88,
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SvgPicture.asset(logoAsset!),
      );
    }

    return AppBadge(
      label: cardType,
      backgroundColor: scheme.primary.withValues(alpha: 0.12),
      foregroundColor: scheme.primary,
    );
  }
}
