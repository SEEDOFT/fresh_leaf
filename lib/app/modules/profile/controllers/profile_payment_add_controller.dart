import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/core/constants/svg_assets.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';
import 'package:get/get.dart';

class ProfilePaymentAddController extends GetxController {
  final holderNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final billingAddressController = TextEditingController();
  final RxBool setAsDefault = false.obs;
  final RxBool isSaving = false.obs;
  final RxString cardType = 'Unknown'.obs;
  final RxString cardValidationMessage = ''.obs;

  String _lastAcceptedCardDigits = '';
  PaymentMethod? _editingMethod;

  bool get isEditMode => _editingMethod != null;

  @override
  void onInit() {
    super.onInit();
    _bindEditArgument();
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
    if (_shouldRejectCardInput(digits)) {
      final fallback = _formatCardNumber(_lastAcceptedCardDigits);
      cardNumberController.value = TextEditingValue(
        text: fallback,
        selection: TextSelection.collapsed(offset: fallback.length),
      );
      if (cardValidationMessage.value.isEmpty) {
        cardValidationMessage.value = 'Unsupported or invalid card number.';
      }
      return;
    }

    _lastAcceptedCardDigits = digits;
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
    final cvv = _digitsOnly(cvvController.text);
    final isKeepingExistingCard = isEditMode && cardDigits.isEmpty;

    final validationError = _validate(
      holder: holder,
      cardDigits: cardDigits,
      expiryDigits: expiryDigits,
      cvv: cvv,
      isKeepingExistingCard: isKeepingExistingCard,
    );

    if (validationError.isNotEmpty) {
      Get.snackbar('Invalid payment', validationError);
      return;
    }

    isSaving.value = true;
    try {
      final expiryMonth = int.parse(expiryDigits.substring(0, 2));
      final expiryYear = 2000 + int.parse(expiryDigits.substring(2));
      final last4 = isKeepingExistingCard
          ? (_editingMethod?.last4 ?? '')
          : cardDigits.substring(cardDigits.length - 4);
      final brand = isKeepingExistingCard
          ? (_editingMethod?.brand ?? 'Unknown')
          : _detectCardType(cardDigits);

      final created = PaymentMethod(
        id:
            _editingMethod?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        brand: brand,
        last4: last4,
        type: 'Card',
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        holderName: holder,
        isDefault: setAsDefault.value,
      );

      Get.back<PaymentMethod>(result: created);
    } finally {
      isSaving.value = false;
    }
  }

  String _validate({
    required String holder,
    required String cardDigits,
    required String expiryDigits,
    required String cvv,
    required bool isKeepingExistingCard,
  }) {
    if (holder.isEmpty) {
      return 'Card holder name is required.';
    }
    if (!isKeepingExistingCard) {
      final brand = _detectCardType(cardDigits);
      if (brand == 'Unknown') {
        return 'Only Visa, Mastercard, and UnionPay are supported.';
      }
      if (!_isSupportedLength(brand, cardDigits.length)) {
        return 'Card number is invalid.';
      }
      if (!_passesLuhn(cardDigits)) {
        return 'Card number is invalid.';
      }
      if (cvv.length < 3 || cvv.length > 4) {
        return 'CVV is invalid.';
      }
    }
    if (expiryDigits.length != 4) {
      return 'Expiry must be in MM/YY format.';
    }

    final month = int.tryParse(expiryDigits.substring(0, 2)) ?? 0;
    final year = int.tryParse(expiryDigits.substring(2)) ?? -1;
    if (month < 1 || month > 12) {
      return 'Expiry month is invalid.';
    }

    final fullYear = 2000 + year;
    final now = DateTime.now();
    final currentMonthStart = DateTime(now.year, now.month);
    final expiryMonthStart = DateTime(fullYear, month);
    if (expiryMonthStart.isBefore(currentMonthStart)) {
      return 'Card has expired.';
    }

    return '';
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

  bool _isSupportedLength(String brand, int length) {
    if (brand == 'Mastercard') return length == 16;
    if (brand == 'Visa') {
      return length == 13 || length == 16 || length == 19;
    }
    if (brand == 'UnionPay') {
      return length >= 16 && length <= 19;
    }
    return false;
  }

  bool _shouldRejectCardInput(String digits) {
    if (digits.isEmpty) return false;

    if (!_matchesAnySupportedPrefix(digits)) {
      return true;
    }

    final maxLen = _maxLengthForPrefix(digits);
    if (digits.length > maxLen) {
      return true;
    }

    final type = _detectCardType(digits);
    if (type == 'Unknown') {
      return false;
    }

    if (_isSupportedLength(type, digits.length) && !_passesLuhn(digits)) {
      return true;
    }

    return false;
  }

  bool _matchesAnySupportedPrefix(String digits) {
    return _isVisaPrefix(digits) ||
        _isMastercardPrefix(digits) ||
        _isUnionPayPrefix(digits);
  }

  int _maxLengthForPrefix(String digits) {
    final isVisa = _isVisaPrefix(digits);
    if (isVisa) return 19;

    final isMastercard = _isMastercardPrefix(digits);
    if (isMastercard) return 16;

    final isUnionPay = _isUnionPayPrefix(digits);
    if (isUnionPay) return 19;

    return 19;
  }

  bool _isVisaPrefix(String digits) {
    return '4'.startsWith(digits) || digits.startsWith('4');
  }

  bool _isMastercardPrefix(String digits) {
    final twoDigitRanges = <List<int>>[
      <int>[51, 55],
      <int>[22, 27],
    ];
    for (final range in twoDigitRanges) {
      if (_prefixInRange(digits, min: range[0], max: range[1], width: 2)) {
        return true;
      }
    }

    if (_prefixInRange(digits, min: 2221, max: 2720, width: 4)) {
      return true;
    }

    return false;
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

  bool _passesLuhn(String cardNumber) {
    var sum = 0;
    var doubleIt = false;
    for (var i = cardNumber.length - 1; i >= 0; i--) {
      var digit = int.parse(cardNumber[i]);
      if (doubleIt) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      sum += digit;
      doubleIt = !doubleIt;
    }
    return sum % 10 == 0;
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
    final method = _mapToPaymentMethod(args);
    if (method == null) return;

    _editingMethod = method;
    holderNameController.text = method.holderName;
    final shortYear = (method.expiryYear % 100).toString().padLeft(2, '0');
    expiryController.text =
        '${method.expiryMonth.toString().padLeft(2, '0')}/$shortYear';
    setAsDefault.value = method.isDefault;
    cardType.value = method.brand.isEmpty ? 'Unknown' : method.brand;
  }

  PaymentMethod? _mapToPaymentMethod(dynamic value) {
    if (value is PaymentMethod) {
      return value;
    }
    if (value is Map<String, dynamic>) {
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

  @override
  void onClose() {
    holderNameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.onClose();
  }
}
