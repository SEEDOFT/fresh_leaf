import 'package:flutter/material.dart';

class SplashPulsingDotWidget extends StatefulWidget {
  const SplashPulsingDotWidget({
    required this.delay,
    required this.color,
    super.key,
  });

  final Duration delay;
  final Color color;

  @override
  State<SplashPulsingDotWidget> createState() => _SplashPulsingDotWidgetState();
}

class _SplashPulsingDotWidgetState extends State<SplashPulsingDotWidget>
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
    // Tween<double> requires double type for animation values
    // ignore: prefer_int_literals
    _scale = Tween(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );

    Future.delayed(widget.delay, () async {
      if (mounted) await _ctrl.repeat(reverse: true);
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
            color: widget.color.withValues(alpha: 0.7),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
