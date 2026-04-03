import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_payment_add_controller.dart';
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
                  controller.isEditMode ? 'Edit card details' : 'Card details',
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
          _PaymentInput(
            label: 'Card holder name',
            hint: 'John Doe',
            controller: controller.holderNameController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: _gap12),
          _PaymentInput(
            label: controller.isEditMode
                ? 'Card number (optional)'
                : 'Card number',
            hint: controller.isEditMode
                ? 'Enter only if replacing card'
                : '4242 4242 4242 4242',
            controller: controller.cardNumberController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: controller.onCardNumberChanged,
            inputFormatters: controller.cardNumberInputFormatters,
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
                child: _PaymentInput(
                  label: 'Expiry',
                  hint: 'MM/YY',
                  controller: controller.expiryController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onChanged: controller.onExpiryChanged,
                  inputFormatters: controller.expiryInputFormatters,
                ),
              ),
              const SizedBox(width: _gap12),
              Expanded(
                child: _PaymentInput(
                  label: 'CVV',
                  hint: controller.isEditMode ? 'Optional' : '123',
                  controller: controller.cvvController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: controller.cvvInputFormatters,
                ),
              ),
            ],
          ),
          const SizedBox(height: _gap12),
          _PaymentInput(
            label: 'billing_address'.tr,
            hint: '123 Main St',
            controller: controller.billingAddressController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: _gap12),
          _PaymentInput(
            label: 'city'.tr,
            hint: 'placeholder_city'.tr,
            controller: controller.billingAddressController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: _gap12),
          _PaymentInput(
            label: 'province'.tr,
            hint: 'placeholder_province'.tr,
            controller: controller.billingAddressController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: _gap12),
          Obx(
            () => SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: controller.setAsDefault.value,
              onChanged: (value) => controller.setAsDefault.value = value,
              title: const Text('Set as default payment method'),
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

    return Container(
      width: 88,
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: logoAsset == null
          ? Text(
              cardType,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            )
          : SvgPicture.asset(logoAsset!),
    );
  }
}

class _PaymentInput extends StatelessWidget {
  const _PaymentInput({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.inputFormatters,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            filled: true,
            fillColor: scheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
