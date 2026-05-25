import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';

class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    required this.width,
    required this.height,
    this.borderRadius,
    super.key,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    unawaited(_controller.repeat());

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final baseColor = scheme.surfaceContainerHighest;
    final highlightColor = scheme.surfaceContainerHigh;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius:
                widget.borderRadius ?? BorderRadius.circular(8.scaled),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.5, 1.0],
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              transform: _SlidingGradientTransform(
                slidePercent: _animation.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20.scaled),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10.scaled,
            offset: Offset(0, 5.scaled),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: SkeletonBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.scaled),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(12.scaled),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 120.scaled, height: 16.scaled),
                  SizedBox(height: 8.scaled),
                  SkeletonBox(width: 80.scaled, height: 12.scaled),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SkeletonBox(width: 60.scaled, height: 20.scaled),
                          SizedBox(height: 4.scaled),
                          SkeletonBox(width: 50.scaled, height: 12.scaled),
                        ],
                      ),
                      SkeletonBox(
                        width: 34.scaled,
                        height: 34.scaled,
                        borderRadius: BorderRadius.circular(17.scaled),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({
    this.itemCount = 8,
    super.key,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;

        final int crossAxisCount;
        final double itemHeight;
        if (screenWidth < 360) {
          crossAxisCount = 1;
          itemHeight = 260;
        } else if (screenWidth < 700) {
          crossAxisCount = 2;
          itemHeight = 285;
        } else if (screenWidth < 1024) {
          crossAxisCount = 3;
          itemHeight = 305;
        } else {
          crossAxisCount = 4;
          itemHeight = 320;
        }

        const double spacing = 16;
        const double horizontalPadding = 32; // 16 + 16
        final itemWidth =
            (constraints.maxWidth -
                horizontalPadding -
                (crossAxisCount - 1) * spacing) /
            crossAxisCount;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: itemWidth / itemHeight,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return const ProductCardSkeleton();
          },
        );
      },
    );
  }
}

class ProductHorizontalSkeleton extends StatelessWidget {
  const ProductHorizontalSkeleton({
    this.itemCount = 4,
    super.key,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.scaled,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 24.scaled),
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(width: 16.scaled),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 200.scaled,
            child: const ProductCardSkeleton(),
          );
        },
      ),
    );
  }
}

class ProductCardListSkeleton extends StatelessWidget {
  const ProductCardListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(18.scaled),
      child: Padding(
        padding: EdgeInsets.all(12.scaled),
        child: Row(
          children: [
            SkeletonBox(
              width: 72.scaled,
              height: 72.scaled,
              borderRadius: BorderRadius.circular(14.scaled),
            ),
            SizedBox(width: 12.scaled),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 150.scaled, height: 16.scaled),
                  SizedBox(height: 8.scaled),
                  SkeletonBox(width: 100.scaled, height: 12.scaled),
                  SizedBox(height: 12.scaled),
                  SkeletonBox(width: 60.scaled, height: 14.scaled),
                ],
              ),
            ),
            SkeletonBox(
              width: 34.scaled,
              height: 34.scaled,
              borderRadius: BorderRadius.circular(17.scaled),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductListSkeleton extends StatelessWidget {
  const ProductListSkeleton({
    this.itemCount = 6,
    super.key,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return const ProductCardListSkeleton();
      },
    );
  }
}
