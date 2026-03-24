part of 'onboarding_view.dart';

class OnboardingBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
  }
}