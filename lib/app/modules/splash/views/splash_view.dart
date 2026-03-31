import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

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
        animation: controller.animController,
        builder: (context, _) => _SplashBody(
          c: controller,
          isDark: isDark,
          scheme: Theme.of(context).colorScheme,
        ),
      ),
    );
  }
}

class _SplashBody extends StatelessWidget {
  final SplashController c;
  final bool isDark;
  final ColorScheme scheme;
  const _SplashBody({
    required this.c,
    required this.isDark,
    required this.scheme,
  });

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
          child: _Blob(
            diameter: size.width * 0.72,
            color: (isDark ? scheme.primary : const Color(0xFF4CAF50))
                .withOpacity(0.08),
          ),
        ),
        Positioned(
          bottom: -size.width * 0.2,
          left: -size.width * 0.15,
          child: _Blob(
            diameter: size.width * 0.58,
            color: (isDark ? scheme.secondary : const Color(0xFF81C784))
                .withOpacity(0.10),
          ),
        ),
        Positioned(
          bottom: size.width * 0.06,
          right: size.width * 0.06,
          child: _Blob(
            diameter: size.width * 0.22,
            color: (isDark ? scheme.primaryContainer : const Color(0xFFA5D6A7))
                .withOpacity(0.18),
          ),
        ),
        Positioned(
          top: size.width * 0.14,
          left: size.width * 0.04,
          child: _Blob(
            diameter: size.width * 0.16,
            color:
                (isDark ? scheme.secondaryContainer : const Color(0xFF66BB6A))
                    .withOpacity(0.12),
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
                  color: const Color(0xFF2E7D32).withOpacity(0.18),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.10),
                  blurRadius: 60,
                  spreadRadius: 8,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: CustomPaint(
                painter: _LogoMarkPainter(isDark: isDark, scheme: scheme),
                child: const SizedBox.expand(),
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
                  height: 1.0,
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
                  height: 1.0,
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
        'Fresh. Organic. Delivered.',
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
          color: (isDark ? scheme.primary : const Color(0xFF388E3C))
              .withOpacity(0.75),
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
          return _PulsingDot(
            delay: Duration(milliseconds: i * 160),
            color: isDark ? scheme.primary : const Color(0xFF4CAF50),
          );
        }),
      ),
    );
  }
}

class _LeafIcon extends StatelessWidget {
  final double size;
  const _LeafIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _LeafPainter(),
    );
  }
}

class _LeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final leafPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(w * 0.5, h * 0.08)
      ..cubicTo(w * 0.88, h * 0.08, w * 0.92, h * 0.5, w * 0.5, h * 0.88)
      ..cubicTo(w * 0.08, h * 0.5, w * 0.12, h * 0.08, w * 0.5, h * 0.08)
      ..close();

    canvas.drawPath(path, leafPaint);

    final veinPaint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..strokeWidth = w * 0.03
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(w * 0.5, h * 0.2),
      Offset(w * 0.5, h * 0.78),
      veinPaint,
    );

    final thinVein = Paint()
      ..color = Colors.white.withOpacity(0.22)
      ..strokeWidth = w * 0.018
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 3; i++) {
      final t = 0.28 + i * 0.13;
      canvas.drawLine(
        Offset(w * 0.5, h * t),
        Offset(w * (0.5 + 0.22), h * (t - 0.08)),
        thinVein,
      );
      canvas.drawLine(
        Offset(w * 0.5, h * t),
        Offset(w * (0.5 - 0.22), h * (t - 0.08)),
        thinVein,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _LogoMarkPainter extends CustomPainter {
  _LogoMarkPainter({required this.isDark, required this.scheme});
  final bool isDark;
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: const [Color(0xFFF9FFF8), Color(0xFFEDF7E9)],
        stops: const [0.2, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // leaf overlay
    final leaf = _LeafPainter();
    canvas.save();
    canvas.translate(w * 0.19, h * 0.19);
    leaf.paint(canvas, Size(w * 0.62, h * 0.62));
    canvas.restore();

    // monogram
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'FL',
        style: TextStyle(
          fontFamily: 'NotoSansKhmer',
          fontWeight: FontWeight.w900,
          fontSize: 30,
          color: isDark ? scheme.onSurface : const Color(0xFF1B5E20),
          letterSpacing: -1.1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(w * 0.32, h * 0.35),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Blob extends StatelessWidget {
  final double diameter;
  final Color color;
  const _Blob({required this.diameter, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Duration delay;
  final Color color;
  const _PulsingDot({required this.delay, required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scale = Tween(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
