import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/splash/controllers/splash_controller.dart';
import 'package:fresh_leaf/app/modules/splash/widgets/splash_blob_widget.dart';
import 'package:fresh_leaf/app/modules/splash/widgets/splash_pulsing_dot_widget.dart';
import 'package:get/get.dart';

class SplashBodyWidget extends StatelessWidget {
  const SplashBodyWidget({
    required this.c,
    required this.isDark,
    required this.scheme,
    super.key,
  });

  final SplashController c;
  final bool isDark;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBackground(),
        _buildDecorativeBlobs(size),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            _buildLogo(),
            const SizedBox(height: 28),
            _buildAppName(),
            const SizedBox(height: 10),
            _buildTagline(),
            const Spacer(flex: 3),
            _buildLoadingDots(),
            const SizedBox(height: 48),
          ],
        ),
      ],
    );
  }

  Widget _buildBackground() {
    final colors = isDark
        ? [
            scheme.surface,
            scheme.primaryContainer.withValues(alpha: 0.55),
            scheme.surfaceContainerHighest.withValues(alpha: 0.9),
          ]
        : const [
            Color(0xFFF0F7EE),
            Color(0xFFE8F5E2),
            Color(0xFFD6EDD0),
          ];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
          stops: const [0.0, 0.52, 1.0],
        ),
      ),
    );
  }

  Widget _buildDecorativeBlobs(Size size) {
    return Stack(
      children: [
        Positioned(
          top: -size.width * 0.28,
          right: -size.width * 0.18,
          child: SplashBlobWidget(
            diameter: size.width * 0.72,
            color: (isDark ? scheme.primary : const Color(0xFF4CAF50))
                .withValues(alpha: 0.08),
          ),
        ),
        Positioned(
          bottom: -size.width * 0.2,
          left: -size.width * 0.15,
          child: SplashBlobWidget(
            diameter: size.width * 0.58,
            color: (isDark ? scheme.secondary : const Color(0xFF81C784))
                .withValues(alpha: 0.10),
          ),
        ),
        Positioned(
          bottom: size.width * 0.06,
          right: size.width * 0.06,
          child: SplashBlobWidget(
            diameter: size.width * 0.22,
            color: (isDark ? scheme.primaryContainer : const Color(0xFFA5D6A7))
                .withValues(alpha: 0.18),
          ),
        ),
        Positioned(
          top: size.width * 0.14,
          left: size.width * 0.04,
          child: SplashBlobWidget(
            diameter: size.width * 0.16,
            color:
                (isDark ? scheme.secondaryContainer : const Color(0xFF66BB6A))
                    .withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return ScaleTransition(
      scale: c.logoScale,
      child: FadeTransition(
        opacity: c.logoOpacity,
        child: RotationTransition(
          turns: c.leafRotate,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.18),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.10),
                  blurRadius: 60,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(
                'assets/logo/fresh_leaf.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppName() {
    return FadeTransition(
      opacity: c.textFade,
      child: SlideTransition(
        position: c.textSlide,
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Fresh',
                style: TextStyle(
                  fontFamily: 'NotoSansKhmer',
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B5E20),
                  letterSpacing: -0.5,
                  height: 1,
                ),
              ),
              TextSpan(
                text: 'Leaf',
                style: TextStyle(
                  fontFamily: 'NotoSansKhmer',
                  fontSize: 38,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF388E3C),
                  letterSpacing: -0.5,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return FadeTransition(
      opacity: c.taglineFade,
      child: Text(
        'splash_tagline'.tr,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
          color: (isDark ? scheme.primary : const Color(0xFF388E3C)).withValues(
            alpha: 0.75,
          ),
          letterSpacing: 2.4,
        ),
      ),
    );
  }

  Widget _buildLoadingDots() {
    return FadeTransition(
      opacity: c.dotsPulse,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return SplashPulsingDotWidget(
            delay: Duration(milliseconds: i * 160),
            color: isDark ? scheme.primary : const Color(0xFF4CAF50),
          );
        }),
      ),
    );
  }
}
