import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.height = 52,
    this.width,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: width ?? media.size.width,
      height: height.scaled,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? scheme.primary,
          foregroundColor: foregroundColor ?? scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 14.scaled),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 20.scaled,
                height: 20.scaled,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2.scaled,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? scheme.onPrimary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20.scaled),
                    SizedBox(width: 8.scaled),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.scaled,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
