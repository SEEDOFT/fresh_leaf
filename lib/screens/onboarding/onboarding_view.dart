import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'onboarding_binding.dart';
part 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding View'),
      ),
      body: const Center(
        child: Text('This is the Onboarding view'),
      ),
    );
  }
}