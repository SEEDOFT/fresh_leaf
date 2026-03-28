import 'package:fresh_leaf/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:fresh_leaf/app/modules/dashboard/views/dashboard_view.dart';
import 'package:fresh_leaf/app/modules/home/bindings/home_binding.dart';
import 'package:fresh_leaf/app/modules/home/views/home_view.dart';
import 'package:fresh_leaf/app/modules/login/bindings/login_binding.dart';
import 'package:fresh_leaf/app/modules/login/views/login_view.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/bindings/ai_assistant_binding.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/views/ai_assistant_view.dart';
import 'package:fresh_leaf/app/modules/orders/bindings/orders_binding.dart';
import 'package:fresh_leaf/app/modules/orders/views/orders_view.dart';
import 'package:fresh_leaf/app/modules/order_detail/bindings/order_detail_binding.dart';
import 'package:fresh_leaf/app/modules/order_detail/views/order_detail_view.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_binding.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_addresses_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_personal_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_security_view.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_addresses_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_personal_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_security_binding.dart';
import 'package:fresh_leaf/app/modules/product_detail/bindings/product_detail_binding.dart';
import 'package:fresh_leaf/app/modules/product_detail/views/product_detail_view.dart';
import 'package:fresh_leaf/app/modules/product_list/bindings/product_list_binding.dart';
import 'package:fresh_leaf/app/modules/product_list/views/product_list_view.dart';
import 'package:fresh_leaf/app/modules/register/bindings/register_binding.dart';
import 'package:fresh_leaf/app/modules/register/views/register_view.dart';
import 'package:fresh_leaf/app/modules/cart/bindings/cart_binding.dart';
import 'package:fresh_leaf/app/modules/cart/views/cart_view.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:fresh_leaf/app/modules/onboarding/views/onboarding_view.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
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
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRoutes.aiAssistant,
      page: () => const AiAssistantView(),
      binding: AiAssistantBinding(),
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersView(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: AppRoutes.orderDetail,
      page: () => const OrderDetailView(),
      binding: OrderDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.personalDetails,
      page: () => const PersonalDetailsView(),
      binding: ProfilePersonalBinding(),
    ),
    GetPage(
      name: AppRoutes.securitySettings,
      page: () => const SecuritySettingsView(),
      binding: ProfileSecurityBinding(),
    ),
    GetPage(
      name: AppRoutes.addresses,
      page: () => const AddressesView(),
      binding: ProfileAddressesBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.productList,
      page: () => const ProductListView(),
      binding: ProductListBinding(),
    ),
  ];
}
