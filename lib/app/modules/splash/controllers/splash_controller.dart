import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/services/launch_route_service.dart';
import 'package:get/get.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animController;

  late Animation<double> logoScale;
  late Animation<double> logoOpacity;
  late Animation<double> leafRotate;
  late Animation<double> textFade;
  late Animation<Offset> textSlide;
  late Animation<double> taglineFade;
  late Animation<double> dotsPulse;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
  }

  void _setupAnimations() {
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    logoScale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          // Tween<double> requires double type for animation values
          // ignore: prefer_int_literals
          begin: 0.0,
          end: 1.12,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 55,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.12,
          // Tween<double> requires double type for animation values
          // ignore: prefer_int_literals
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      // Tween<double> requires double type for animation values
      // ignore: prefer_int_literals
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 25),
    ]).animate(animController);

    // Tween<double> requires double type for animation values
    // ignore: prefer_int_literals
    logoOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animController,
        // Tween<double> requires double type for animation values
        // ignore: prefer_int_literals
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    // Tween<double> requires double type for animation values
    // ignore: prefer_int_literals
    leafRotate = Tween(begin: -0.15, end: 0.0).animate(
      CurvedAnimation(
        parent: animController,
        // Tween<double> requires double type for animation values
        // ignore: prefer_int_literals
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );

    // Tween<double> requires double type for animation values
    // ignore: prefer_int_literals
    textFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.45, 0.72, curve: Curves.easeIn),
      ),
    );

    textSlide = Tween(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.45, 0.72, curve: Curves.easeOut),
      ),
    );

    // Tween<double> requires double type for animation values
    // ignore: prefer_int_literals
    taglineFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.62, 0.85, curve: Curves.easeIn),
      ),
    );

    // Tween<double> requires double type for animation values
    // ignore: prefer_int_literals
    dotsPulse = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animController,
        // Tween<double> requires double type for animation values
        // ignore: prefer_int_literals
        curve: const Interval(0.82, 1.0, curve: Curves.easeInOut),
      ),
    );

    animController
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await _startFlow();
        }
      })
      ..forward();
  }

  Future<void> _startFlow() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final launch = Get.find<LaunchRouteService>();
    await Get.offAllNamed<void>(launch.targetRoute);
  }

  @override
  void onClose() {
    animController.dispose();
    super.onClose();
  }
}
