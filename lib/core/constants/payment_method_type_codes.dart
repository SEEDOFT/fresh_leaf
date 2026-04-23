final class PaymentMethodTypeCodes {
  PaymentMethodTypeCodes._();

  static const creditDebit = 'credit_debit';
  static const aba = 'aba';
  static const acleda = 'acleda';
}

class PaymentMethodFlowRule {
  const PaymentMethodFlowRule({
    required this.requiresDetails,
    required this.supportsSavedMethod,
    required this.redirectFlow,
  });

  final bool requiresDetails;
  final bool supportsSavedMethod;
  final bool redirectFlow;
}

PaymentMethodFlowRule resolvePaymentMethodFlowRule(String? typeCode) {
  final code = (typeCode ?? '').trim().toLowerCase();
  switch (code) {
    case PaymentMethodTypeCodes.creditDebit:
      return const PaymentMethodFlowRule(
        requiresDetails: true,
        supportsSavedMethod: true,
        redirectFlow: false,
      );
    case PaymentMethodTypeCodes.aba:
    case PaymentMethodTypeCodes.acleda:
      return const PaymentMethodFlowRule(
        requiresDetails: false,
        supportsSavedMethod: true,
        redirectFlow: true,
      );
    default:
      return const PaymentMethodFlowRule(
        requiresDetails: false,
        supportsSavedMethod: true,
        redirectFlow: false,
      );
  }
}
