import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/app/modules/splash/controllers/splash_controller.dart';
import 'package:fresh_leaf/app/modules/splash/widgets/splash_widget.dart';
import 'package:get/get.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final navColor = isDark ? const Color(0xFF111713) : const Color(0xFFF0F7EE);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: navColor,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    return Scaffold(
      body: AnimatedBuilder(
        animation: controller.animationController,
        builder: (context, _) => SplashBodyWidget(
          c: controller,
          isDark: isDark,
          scheme: Theme.of(context).colorScheme,
        ),
      ),
    );
  }
}
