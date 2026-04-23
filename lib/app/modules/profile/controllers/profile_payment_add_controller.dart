import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/constants/payment_method_status_constants.dart';
import 'package:fresh_leaf/core/constants/payment_method_type_codes.dart';
import 'package:fresh_leaf/core/constants/svg_assets.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';
import 'package:fresh_leaf/core/models/payment_method_type.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class ProfilePaymentAddController extends GetxController {
  final holderNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final billingAddressController = TextEditingController();
  final billingCityController = TextEditingController();
  final billingStateController = TextEditingController();
  final billingZipCodeController = TextEditingController();
  final RxBool isSaving = false.obs;
  final RxString cardType = 'Unknown'.obs;
  final RxString cardValidationMessage = ''.obs;
  final RxList<PaymentMethodType> paymentMethodTypes =
      <PaymentMethodType>[].obs;
  final Rxn<PaymentMethodType> selectedPaymentMethodType =
      Rxn<PaymentMethodType>();
  final RxBool isLoadingPaymentMethodTypes = false.obs;
  bool _excludeWalletType = false;
  String? _preferredPaymentMethodTypeCode;
  Set<String>? _allowedPaymentMethodTypeCodes = <String>{
    PaymentMethodTypeCodes.creditDebit,
  };

  PaymentMethod? _editingMethod;

  bool get isEditMode => _editingMethod != null;
  bool get requiresDetails {
    final rule = resolvePaymentMethodFlowRule(
      selectedPaymentMethodType.value?.code,
    );
    return rule.requiresDetails;
  }

  bool get isBankChannelType {
    final code = (selectedPaymentMethodType.value?.code ?? '').toLowerCase();
    return code == PaymentMethodTypeCodes.aba ||
        code == PaymentMethodTypeCodes.acleda;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    _bindEditArgument();
    await fetchPaymentMethodTypes();
  }

  List<TextInputFormatter> get cardNumberInputFormatters =>
      <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(19),
      ];

  List<TextInputFormatter> get expiryInputFormatters => <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(4),
  ];

  List<TextInputFormatter> get cvvInputFormatters => <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(4),
  ];

  void onCardNumberChanged(String value) {
    final digits = _digitsOnly(value);
    cardType.value = _detectCardType(digits);
    cardValidationMessage.value = '';

    final formatted = _formatCardNumber(digits);
    if (formatted == cardNumberController.text) return;
    cardNumberController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void onExpiryChanged(String value) {
    final digits = _digitsOnly(value);
    final formatted = digits.length <= 2
        ? digits
        : '${digits.substring(0, 2)}/${digits.substring(2)}';
    if (formatted == expiryController.text) return;
    expiryController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> submit() async {
    if (isSaving.value) return;

    final holder = holderNameController.text.trim();
    final cardDigits = _digitsOnly(cardNumberController.text);
    final expiryDigits = _digitsOnly(expiryController.text);
    final enteredCvv = _digitsOnly(cvvController.text);
    final billingAddress = billingAddressController.text.trim();
    final billingCity = billingCityController.text.trim();
    final billingState = billingStateController.text.trim();
    final billingZipCode = billingZipCodeController.text.trim();
    final isKeepingExistingCard = isEditMode && cardDigits.isEmpty;
    final selectedType = selectedPaymentMethodType.value;

    final rule = resolvePaymentMethodFlowRule(selectedType?.code);
    final validationError = _validate(
      holder: holder,
      cardDigits: cardDigits,
      expiryDigits: expiryDigits,
      enteredCvv: enteredCvv,
      billingAddress: billingAddress,
      billingCity: billingCity,
      billingState: billingState,
      billingZipCode: billingZipCode,
      isKeepingExistingCard: isKeepingExistingCard,
      selectedType: selectedType,
      requiresDetails: rule.requiresDetails,
    );

    if (validationError.isNotEmpty) {
      Get.snackbar('invalid_payment'.tr, validationError);
      return;
    }

    isSaving.value = true;
    try {
      final apiClient = Get.find<ApiClient>();
      final expiryMonth = rule.requiresDetails
          ? int.parse(expiryDigits.substring(0, 2))
          : 0;
      final expiryYear = rule.requiresDetails
          ? 2000 + int.parse(expiryDigits.substring(2))
          : 0;
      final cvv = rule.requiresDetails
          ? (isKeepingExistingCard ? _editingMethod?.cvv : enteredCvv)
          : '';
      final label = rule.requiresDetails
          ? (isKeepingExistingCard
                ? (_editingMethod?.label ?? 'Unknown')
                : _detectCardType(cardDigits))
          : (selectedType?.name ?? selectedType?.code ?? 'Payment');
      final paymentMethodTypeId = selectedType?.id ?? 0;
      final cardNumber = rule.requiresDetails
          ? (isKeepingExistingCard
                ? (_editingMethod?.cardNumber ?? '')
                : cardDigits)
          : '';

      final created = PaymentMethod(
        label: label,
        cardNumber: cardNumber,
        cvv: cvv ?? '',
        paymentMethodTypeId: paymentMethodTypeId,
        paymentMethodStatusId: PaymentMethodStatusConstants.active,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        cardHolderName: holder,
        billingAddress: billingAddress,
        billingCity: billingCity,
        billingState: billingState,
        billingZipCode: billingZipCode,
        isDefault: false,
      );

      final payload = {
        'label': created.label,
        'card_number': created.cardNumber,
        'cvv': created.cvv,
        'payment_method_type_id': created.paymentMethodTypeId,
        'expiry_month': created.expiryMonth,
        'expiry_year': created.expiryYear,
        'card_holder_name': created.cardHolderName,
        'billing_address': created.billingAddress,
        'billing_city': created.billingCity,
        'billing_state': created.billingState,
        'billing_zip_code': created.billingZipCode,
        'is_default': false,
      };

      final response = await apiClient.postRequest(
        ApiEndpoints.userPaymentMethods,
        data: payload,
      );

      final apiResponse = ApiResponse.parseMap(response.data);
      final statusCode = response.statusCode ?? 0;
      final isSuccessCode = statusCode == 200 || statusCode == 201;
      if (!apiResponse.status.success || !isSuccessCode) {
        Get.snackbar(
          'save_failed'.tr,
          apiResponse.status.message.isNotEmpty
              ? apiResponse.status.message
              : 'unable_save_payment_method'.tr,
        );
        return;
      }

      final savedMethod = apiResponse.data.isEmpty
          ? created
          : PaymentMethod.fromMap(apiResponse.data);
      Get.back<PaymentMethod>(result: savedMethod);
    } on DioException catch (error) {
      Get.snackbar(
        'save_failed'.tr,
        parseApiErrorMessage(
          error,
          fallback: 'unable_save_payment_method'.tr,
        ),
      );
    } on FormatException catch (_) {
      Get.snackbar(
        'save_failed'.tr,
        'unable_save_payment_method'.tr,
      );
    } on Exception catch (_) {
      Get.snackbar(
        'save_failed'.tr,
        'unable_save_payment_method'.tr,
      );
    } finally {
      isSaving.value = false;
    }
  }

  String _validate({
    required String holder,
    required String cardDigits,
    required String expiryDigits,
    required String enteredCvv,
    required String billingAddress,
    required String billingCity,
    required String billingState,
    required String billingZipCode,
    required bool isKeepingExistingCard,
    required PaymentMethodType? selectedType,
    required bool requiresDetails,
  }) {
    if (selectedType == null || (selectedType.id ?? 0) <= 0) {
      return 'payment_method_type_required'.tr;
    }

    if (requiresDetails) {
      if (holder.isEmpty) {
        return 'card_holder_required'.tr;
      }

      if (!isKeepingExistingCard) {
        if (cardDigits.length < 12) {
          return 'card_number_invalid'.tr;
        }
        if (enteredCvv.length < 3 || enteredCvv.length > 4) {
          return 'cvv_invalid'.tr;
        }
      } else if ((_editingMethod?.cvv ?? '').isEmpty) {
        if (enteredCvv.length < 3 || enteredCvv.length > 4) {
          return 'cvv_invalid'.tr;
        }
      }

      if (expiryDigits.length != 4) {
        return 'expiry_format_invalid'.tr;
      }

      final month = int.tryParse(expiryDigits.substring(0, 2)) ?? 0;
      final year = int.tryParse(expiryDigits.substring(2)) ?? -1;
      if (month < 1 || month > 12) {
        return 'expiry_month_invalid'.tr;
      }

      final fullYear = 2000 + year;
      final now = DateTime.now();
      final currentMonthStart = DateTime(now.year, now.month);
      final expiryMonthStart = DateTime(fullYear, month);
      if (expiryMonthStart.isBefore(currentMonthStart)) {
        return 'card_expired'.tr;
      }

      if (billingAddress.isEmpty) {
        return 'enter_address_line_1'.tr;
      }
      if (billingCity.isEmpty) {
        return 'enter_city'.tr;
      }
      if (billingState.isEmpty) {
        return 'enter_province'.tr;
      }
      if (billingZipCode.isEmpty) {
        return 'enter_postal_code'.tr;
      }
    }

    return '';
  }

  Future<void> fetchPaymentMethodTypes() async {
    if (isLoadingPaymentMethodTypes.value) return;

    isLoadingPaymentMethodTypes.value = true;
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(
        ApiEndpoints.userPaymentMethodTypes,
      );
      final apiResponse = ApiResponse.parseList(response.data);
      final statusCode = response.statusCode ?? 0;
      final isSuccessCode = statusCode == 200 || statusCode == 201;

      if (!apiResponse.status.success || !isSuccessCode) {
        paymentMethodTypes.clear();
        selectedPaymentMethodType.value = null;
        Get.snackbar(
          'fetch_failed'.tr,
          apiResponse.status.message.isNotEmpty
              ? apiResponse.status.message
              : 'unable_load_payment_method_types'.tr,
        );
        return;
      }

      final types = apiResponse.data.map(PaymentMethodType.fromMap).toList();
      var filteredTypes = _excludeWalletType
          ? types
                .where(
                  (type) => (type.code ?? '').trim().toLowerCase() != 'wallet',
                )
                .toList()
          : types;
      final allowedCodes = _allowedPaymentMethodTypeCodes;
      if (allowedCodes != null && allowedCodes.isNotEmpty) {
        filteredTypes = filteredTypes
            .where(
              (type) =>
                  allowedCodes.contains((type.code ?? '').trim().toLowerCase()),
            )
            .toList();
      }
      paymentMethodTypes.assignAll(filteredTypes);
      _selectDefaultPaymentMethodType();
    } on DioException catch (error) {
      paymentMethodTypes.clear();
      selectedPaymentMethodType.value = null;
      Get.snackbar(
        'fetch_failed'.tr,
        parseApiErrorMessage(
          error,
          fallback: 'unable_load_payment_method_types'.tr,
        ),
      );
    } on Exception catch (_) {
      paymentMethodTypes.clear();
      selectedPaymentMethodType.value = null;
      Get.snackbar('fetch_failed'.tr, 'unable_load_payment_method_types'.tr);
    } finally {
      isLoadingPaymentMethodTypes.value = false;
    }
  }

  void onPaymentMethodTypeChanged(PaymentMethodType? value) {
    if (value == null) return;
    selectedPaymentMethodType.value = value;
    if (!requiresDetails) {
      cardValidationMessage.value = '';
      cardType.value = value.name ?? value.code ?? 'Unknown';
    }
  }

  String _digitsOnly(String value) {
    return value.replaceAll(RegExp('[^0-9]'), '');
  }

  String _detectCardType(String number) {
    if (number.startsWith('4')) return 'Visa';
    final two = number.length >= 2 ? int.tryParse(number.substring(0, 2)) : -1;
    final four = number.length >= 4 ? int.tryParse(number.substring(0, 4)) : -1;
    if (two != null && two >= 51 && two <= 55) return 'Mastercard';
    if (four != null && four >= 2221 && four <= 2720) return 'Mastercard';
    if (_isUnionPayPrefix(number)) return 'UnionPay';
    return 'Unknown';
  }

  bool _isUnionPayPrefix(String digits) {
    return _prefixInRange(digits, min: 62, max: 62, width: 2);
  }

  bool _prefixInRange(
    String digits, {
    required int min,
    required int max,
    required int width,
  }) {
    final paddedMin = min.toString().padLeft(width, '0');
    final paddedMax = max.toString().padLeft(width, '0');

    if (digits.length <= width) {
      final prefixMin = paddedMin.substring(0, digits.length);
      final prefixMax = paddedMax.substring(0, digits.length);
      return digits.compareTo(prefixMin) >= 0 &&
          digits.compareTo(prefixMax) <= 0;
    }

    final prefix = digits.substring(0, width);
    final prefixNumber = int.tryParse(prefix);
    if (prefixNumber == null) return false;
    return prefixNumber >= min && prefixNumber <= max;
  }

  String _formatCardNumber(String digits) {
    final groups = <String>[];
    for (var i = 0; i < digits.length; i += 4) {
      final end = (i + 4 <= digits.length) ? i + 4 : digits.length;
      groups.add(digits.substring(i, end));
    }
    return groups.join(' ');
  }

  String? get cardLogoAsset {
    final type = cardType.value;
    if (type == 'Visa') return SvgAssets.visa;
    if (type == 'Mastercard') return SvgAssets.mastercard;
    if (type == 'UnionPay') return SvgAssets.unionPay;
    return null;
  }

  void _bindEditArgument() {
    final args = Get.arguments;
    final argMap = _toStringDynamicMap(args);
    if (argMap != null) {
      _excludeWalletType = argMap['exclude_wallet_type'] == true;
      _preferredPaymentMethodTypeCode = formatToString(
        argMap['preferred_payment_method_type_code'],
      ).trim().toLowerCase();
      final allowedCodes = _extractAllowedTypeCodes(
        argMap['allowed_payment_method_type_codes'],
      );
      if (allowedCodes.isNotEmpty) {
        _allowedPaymentMethodTypeCodes = allowedCodes;
      }
    }

    final method = _mapToPaymentMethod(args);
    if (method == null) return;

    _editingMethod = method;
    holderNameController.text = method.cardHolderName;
    if (method.expiryMonth > 0 && method.expiryYear > 0) {
      final shortYear = (method.expiryYear % 100).toString().padLeft(2, '0');
      expiryController.text =
          '${method.expiryMonth.toString().padLeft(2, '0')}/$shortYear';
    }
    billingAddressController.text = method.billingAddress;
    billingCityController.text = method.billingCity;
    billingStateController.text = method.billingState;
    billingZipCodeController.text = method.billingZipCode;
    cardType.value = method.label ?? _detectCardType(method.cardNumber);
  }

  void _selectDefaultPaymentMethodType() {
    final types = paymentMethodTypes;
    if (types.isEmpty) {
      selectedPaymentMethodType.value = null;
      return;
    }

    if (isEditMode) {
      final existing = types
          .where((type) => type.id == _editingMethod?.paymentMethodTypeId)
          .toList();
      if (existing.isNotEmpty) {
        selectedPaymentMethodType.value = existing.first;
        return;
      }
    }

    if ((_preferredPaymentMethodTypeCode ?? '').isNotEmpty) {
      final preferred = types
          .where(
            (type) =>
                (type.code ?? '').trim().toLowerCase() ==
                _preferredPaymentMethodTypeCode,
          )
          .toList();
      if (preferred.isNotEmpty) {
        selectedPaymentMethodType.value = preferred.first;
        return;
      }
    }

    final creditDebit = types
        .where((type) => (type.code ?? '').toLowerCase() == 'credit_debit')
        .toList();
    if (creditDebit.isNotEmpty) {
      selectedPaymentMethodType.value = creditDebit.first;
      return;
    }

    selectedPaymentMethodType.value = types.first;
  }

  PaymentMethod? _mapToPaymentMethod(dynamic value) {
    if (value is PaymentMethod) {
      return value;
    }
    if (value is Map<String, dynamic> && value['seed'] is PaymentMethod) {
      return value['seed'] as PaymentMethod;
    }
    if (value is Map && value['seed'] is PaymentMethod) {
      return value['seed'] as PaymentMethod;
    }
    if (value is Map<String, dynamic>) {
      final hasSeed = value['seed'] != null;
      final hasPaymentId = value['id'] != null;
      if (!hasSeed && !hasPaymentId) {
        return null;
      }
      return PaymentMethod.fromMap(value);
    }
    if (value is Map) {
      final mapped = value.map<String, dynamic>(
        (key, dynamic item) => MapEntry<String, dynamic>(key.toString(), item),
      );
      return PaymentMethod.fromMap(mapped);
    }
    return null;
  }

  Set<String> _extractAllowedTypeCodes(dynamic raw) {
    if (raw is List) {
      return raw
          .map((item) => formatToString(item).trim().toLowerCase())
          .where((item) => item.isNotEmpty)
          .toSet();
    }
    return <String>{};
  }

  Map<String, dynamic>? _toStringDynamicMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map<String, dynamic>(
        (key, dynamic item) => MapEntry<String, dynamic>(key.toString(), item),
      );
    }
    return null;
  }

  @override
  void onClose() {
    holderNameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    billingAddressController.dispose();
    billingCityController.dispose();
    billingStateController.dispose();
    billingZipCodeController.dispose();
    super.onClose();
  }
}
