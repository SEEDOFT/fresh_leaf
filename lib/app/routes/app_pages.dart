import 'package:fresh_leaf/app/middlewares/auth_middleware.dart';
import 'package:fresh_leaf/app/middlewares/onboarding_middleware.dart';
import 'package:fresh_leaf/app/middlewares/profile_sync_middleware.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/bindings/ai_assistant_binding.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/views/ai_assistant_view.dart';
import 'package:fresh_leaf/app/modules/cart/bindings/cart_binding.dart';
import 'package:fresh_leaf/app/modules/cart/views/cart_view.dart';
import 'package:fresh_leaf/app/modules/checkout/bindings/checkout_binding.dart';
import 'package:fresh_leaf/app/modules/checkout/views/checkout_view.dart';
import 'package:fresh_leaf/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:fresh_leaf/app/modules/dashboard/views/dashboard_view.dart';
import 'package:fresh_leaf/app/modules/home/bindings/home_binding.dart';
import 'package:fresh_leaf/app/modules/home/views/home_view.dart';
import 'package:fresh_leaf/app/modules/login/bindings/login_binding.dart';
import 'package:fresh_leaf/app/modules/login/views/login_view.dart';
import 'package:fresh_leaf/app/modules/network_check/bindings/network_check_binding.dart';
import 'package:fresh_leaf/app/modules/network_check/views/network_check_view.dart';
import 'package:fresh_leaf/app/modules/notifications/bindings/notification_detail_binding.dart';
import 'package:fresh_leaf/app/modules/notifications/bindings/notifications_binding.dart';
import 'package:fresh_leaf/app/modules/notifications/views/notification_detail_view.dart';
import 'package:fresh_leaf/app/modules/notifications/views/notifications_view.dart';
import 'package:fresh_leaf/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:fresh_leaf/app/modules/onboarding/views/onboarding_view.dart';
import 'package:fresh_leaf/app/modules/order_detail/bindings/order_detail_binding.dart';
import 'package:fresh_leaf/app/modules/order_detail/views/order_detail_view.dart';
import 'package:fresh_leaf/app/modules/order_external_payment/bindings/order_external_payment_binding.dart';
import 'package:fresh_leaf/app/modules/order_external_payment/views/order_external_payment_view.dart';
import 'package:fresh_leaf/app/modules/order_wallet_payment/bindings/order_wallet_payment_binding.dart';
import 'package:fresh_leaf/app/modules/order_wallet_payment/views/order_wallet_payment_view.dart';
import 'package:fresh_leaf/app/modules/orders/bindings/orders_binding.dart';
import 'package:fresh_leaf/app/modules/orders/views/orders_view.dart';
import 'package:fresh_leaf/app/modules/payment_qr/bindings/payment_qr_binding.dart';
import 'package:fresh_leaf/app/modules/payment_qr/views/payment_qr_view.dart';
import 'package:fresh_leaf/app/modules/product_detail/views/product_detail_view.dart';
import 'package:fresh_leaf/app/modules/product_list/bindings/product_list_binding.dart';
import 'package:fresh_leaf/app/modules/product_list/views/product_list_view.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/pin_verification_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_address_edit_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_addresses_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_help_center_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_payment_add_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_payment_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_personal_details_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_pin_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_pin_password_verify_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_privacy_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_security_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_settings_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_wishlist_binding.dart';
import 'package:fresh_leaf/app/modules/profile/views/pin_verification_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_address_edit_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_addresses_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_help_center_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_payment_add_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_payment_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_personal_details_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_pin_password_verify_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_pin_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_privacy_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_security_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_settings_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_wishlist_view.dart';
import 'package:fresh_leaf/app/modules/register/bindings/register_binding.dart';
import 'package:fresh_leaf/app/modules/register/views/register_view.dart';
import 'package:fresh_leaf/app/modules/search/bindings/search_binding.dart';
import 'package:fresh_leaf/app/modules/search/views/search_view.dart';
import 'package:fresh_leaf/app/modules/splash/bindings/splash_binding.dart';
import 'package:fresh_leaf/app/modules/splash/views/splash_view.dart';
import 'package:fresh_leaf/app/modules/support_chat/bindings/support_chat_binding.dart';
import 'package:fresh_leaf/app/modules/support_chat/views/support_chat_view.dart';
import 'package:fresh_leaf/app/modules/support_tickets/bindings/support_tickets_binding.dart';
import 'package:fresh_leaf/app/modules/support_tickets/views/support_tickets_view.dart';
import 'package:fresh_leaf/app/modules/vendor_profile/bindings/vendor_profile_binding.dart';
import 'package:fresh_leaf/app/modules/vendor_profile/views/vendor_profile_view.dart';
import 'package:fresh_leaf/app/modules/wallet/bindings/wallet_binding.dart';
import 'package:fresh_leaf/app/modules/wallet/views/wallet_view.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/bindings/wallet_top_up_binding.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/views/wallet_top_up_view.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up_payment/bindings/wallet_top_up_payment_binding.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up_payment/views/wallet_top_up_payment_view.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up_success/bindings/wallet_top_up_success_binding.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up_success/views/wallet_top_up_success_view.dart';
import 'package:fresh_leaf/app/modules/wallet_transactions/views/wallet_transactions_view.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:get/get.dart';

final class AppPages {
  AppPages._();

  static final List<GetMiddleware> _authOnly = <GetMiddleware>[
    AuthMiddleware(priorityValue: 1),
    ProfileSyncMiddleware(priorityValue: 2),
  ];
  static final List<GetMiddleware> _onboardingOnly = <GetMiddleware>[
    OnboardingMiddleware(priorityValue: 1),
  ];

  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      middlewares: _onboardingOnly,
    ),
    GetPage(
      name: AppRoutes.networkCheck,
      page: () => const NetworkCheckView(),
      binding: NetworkCheckBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
      binding: CartBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.aiAssistant,
      page: () => const AiAssistantView(),
      binding: AiAssistantBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.supportTickets,
      page: () => const SupportTicketsView(),
      binding: SupportTicketsBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.supportChat,
      page: () => const SupportChatView(),
      binding: SupportChatBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersView(),
      binding: OrdersBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.orderDetail,
      page: () => const OrderDetailView(),
      binding: OrderDetailBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.orderWalletPayment,
      page: () => const OrderWalletPaymentView(),
      binding: OrderWalletPaymentBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.orderExternalPayment,
      page: () => const OrderExternalPaymentView(),
      binding: OrderExternalPaymentBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.personalDetails,
      page: () => const ProfilePersonalDetailsView(),
      binding: ProfilePersonalDetailsBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const ProfileSettingsView(),
      binding: ProfileSettingsBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.securitySettings,
      page: () => const SecuritySettingsView(),
      binding: ProfileSecurityBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.addresses,
      page: () => const AddressesView(),
      binding: ProfileAddressesBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.addressesEdit,
      page: () => const ProfileAddressEditView(),
      binding: ProfileAddressEditBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.pinSecurity,
      page: () => const ProfilePinView(),
      binding: ProfilePinBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.pinPasswordVerification,
      page: () => const ProfilePinPasswordVerifyView(),
      binding: ProfilePinPasswordVerifyBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.pinVerification,
      page: () => const PinVerificationView(),
      binding: PinVerificationBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () => const ProfileWishlistView(),
      binding: ProfileWishlistBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.paymentMethods,
      page: () => const ProfilePaymentView(),
      binding: ProfilePaymentBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.paymentMethodsAdd,
      page: () => const ProfilePaymentAddView(),
      binding: ProfilePaymentAddBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.helpCenter,
      page: () => const ProfileHelpCenterView(),
      binding: ProfileHelpCenterBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.privacyTerms,
      page: () => const ProfilePrivacyView(),
      binding: ProfilePrivacyBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailView(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.productList,
      page: () => const ProductListView(),
      binding: ProductListBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.vendorProfile,
      page: () => const VendorProfileView(),
      binding: VendorProfileBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.notificationDetail,
      page: () => const NotificationDetailView(),
      binding: NotificationDetailBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.wallet,
      page: () => const WalletView(),
      binding: WalletBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.walletTopUp,
      page: () => const WalletTopUpView(),
      binding: WalletTopUpBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.walletTopUpPayment,
      page: () => const WalletTopUpPaymentView(),
      binding: WalletTopUpPaymentBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.walletTopUpSuccess,
      page: () => const WalletTopUpSuccessView(),
      binding: WalletTopUpSuccessBinding(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.walletTransactions,
      page: () => const WalletTransactionsView(),
      middlewares: _authOnly,
    ),
    GetPage(
      name: AppRoutes.paymentQr,
      page: () => const PaymentQrView(),
      binding: PaymentQrBinding(),
      middlewares: _authOnly,
    ),
  ];
}
