import 'package:fresh_leaf/screens/home/home_view.dart';
import 'package:fresh_leaf/screens/login/login_view.dart';
import 'package:fresh_leaf/screens/onboarding/onboarding_view.dart';
import 'package:fresh_leaf/routes/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

var appRoutes = [
  GetPage(
    name: Routes.onboarding,
    page: () => const OnboardingView(),
    binding: OnboardingBinding(),
  ),
  GetPage(
    name: Routes.login,
    page: () => const LoginView(),
    binding: LoginBinding(),
  ),
  GetPage(
    name: Routes.home,
    page: () => const HomeView(),
    binding: HomeBinding(),
  ),
];
