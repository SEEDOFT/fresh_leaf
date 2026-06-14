import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/'
    'profile_payment_add_controller.dart';
import 'package:fresh_leaf/core/models/payment_method_type.dart';
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
                child: Obx(
                  () => Text(
                    controller.requiresDetails
                        ? (controller.isEditMode
                              ? 'edit_card_details'.tr
                              : 'card_details'.tr)
                        : 'payment_method_type'.tr,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
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
          Obx(
            () => _PaymentMethodTypeDropdown(
              types: controller.paymentMethodTypes,
              selectedType: controller.selectedPaymentMethodType.value,
              isLoading: controller.isLoadingPaymentMethodTypes.value,
              onChanged: controller.onPaymentMethodTypeChanged,
            ),
          ),
          const SizedBox(height: _gap12),
          Obx(
            () => controller.requiresDetails
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        label: 'card_holder_name'.tr,
                        hintText: 'placeholder_name'.tr,
                        controller: controller.holderNameController,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: _gap12),
                      AppTextField(
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
                              hintText: 'expiry_hint'.tr,
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
                              hintText: controller.isEditMode
                                  ? 'optional'.tr
                                  : '123',
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
                    ],
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: scheme.primary.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Text(
                      'bank_channel_payment_hint'.tr,
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTypeDropdown extends StatelessWidget {
  const _PaymentMethodTypeDropdown({
    required this.types,
    required this.selectedType,
    required this.isLoading,
    required this.onChanged,
  });

  final List<PaymentMethodType> types;
  final PaymentMethodType? selectedType;
  final bool isLoading;
  final ValueChanged<PaymentMethodType?> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDisabled = isLoading || types.isEmpty;
    final selectedLabel = _typeLabel(selectedType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'payment_method_type'.tr.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isDisabled ? null : () => _openPicker(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.48),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selectedType != null
                    ? scheme.primary.withValues(alpha: 0.42)
                    : scheme.outline.withValues(alpha: 0.4),
              ),
              boxShadow: selectedType == null
                  ? null
                  : [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.payments_outlined,
                  size: 20,
                  color: isDisabled
                      ? scheme.onSurfaceVariant.withValues(alpha: 0.7)
                      : scheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isLoading
                        ? 'common_loading'.tr
                        : (selectedLabel.isNotEmpty
                              ? selectedLabel
                              : (types.isEmpty
                                    ? 'unable_load_payment_method_types'.tr
                                    : 'select_payment_method_type'.tr)),
                    style: TextStyle(
                      color: isDisabled
                          ? scheme.onSurfaceVariant.withValues(alpha: 0.75)
                          : scheme.onSurface,
                      fontSize: 15,
                      fontWeight: selectedType == null
                          ? FontWeight.w500
                          : FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isLoading)
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        scheme.primary,
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.expand_more_rounded,
                    color: scheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _typeLabel(PaymentMethodType? type) {
    if (type == null) return '';
    return type.name?.isNotEmpty ?? false ? type.name! : (type.code ?? '');
  }

  Future<void> _openPicker(BuildContext context) async {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS) {
      await _openCupertinoPicker(context);
      return;
    }
    await _openMaterialPicker(context);
  }

  Future<void> _openMaterialPicker(BuildContext context) async {
    final scheme = Theme.of(context).colorScheme;
    final selected = await showModalBottomSheet<PaymentMethodType>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                  child: Row(
                    children: [
                      Text(
                        'select_payment_method_type'.tr,
                        style: TextStyle(
                          color: scheme.onSurface,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(sheetContext).size.height * 0.55,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                    itemBuilder: (_, index) {
                      final type = types[index];
                      final isSelected = selectedType?.id == type.id;
                      final label = _typeLabel(type);
                      return ListTile(
                        onTap: () => Navigator.of(sheetContext).pop(type),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        tileColor: isSelected
                            ? scheme.primary.withValues(alpha: 0.12)
                            : scheme.surfaceContainerHighest.withValues(
                                alpha: 0.32,
                              ),
                        leading: Icon(
                          isSelected
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: isSelected
                              ? scheme.primary
                              : scheme.onSurfaceVariant,
                        ),
                        title: Text(
                          label,
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemCount: types.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (selected != null) onChanged(selected);
  }

  Future<void> _openCupertinoPicker(BuildContext context) async {
    final selected = await showCupertinoModalPopup<PaymentMethodType>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: Text('select_payment_method_type'.tr),
          actions: types
              .map(
                (type) => CupertinoActionSheetAction(
                  onPressed: () => Navigator.of(sheetContext).pop(type),
                  isDefaultAction: selectedType?.id == type.id,
                  child: Text(_typeLabel(type)),
                ),
              )
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            child: Text('cancel'.tr),
          ),
        );
      },
    );
    if (selected != null) onChanged(selected);
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
