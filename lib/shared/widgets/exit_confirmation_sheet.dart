import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:get/get.dart';

Future<bool> showExitConfirmationSheet(BuildContext context) {
  final scheme = Theme.of(context).colorScheme;
  return showModalBottomSheet<bool>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.scaled)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 24.scaled,
          right: 24.scaled,
          top: 12.scaled,
          bottom: 32.scaled,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.scaled,
              height: 4.scaled,
              decoration: BoxDecoration(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2.scaled),
              ),
            ),
            SizedBox(height: 24.scaled),
            Container(
              padding: EdgeInsets.all(16.scaled),
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.exit_to_app_rounded,
                color: scheme.primary,
                size: 28.scaled,
              ),
            ),
            SizedBox(height: 20.scaled),
            Text(
              'exit_app_title'.tr,
              style: TextStyle(
                fontSize: 20.scaled,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            SizedBox(height: 8.scaled),
            Text(
              'exit_app_message'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.scaled,
                color: scheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            SizedBox(height: 28.scaled),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 52.scaled,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(sheetContext, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.scaled),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'exit'.tr,
                  style: TextStyle(
                    fontSize: 16.scaled,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.scaled),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 52.scaled,
              child: TextButton(
                onPressed: () => Navigator.pop(sheetContext, false),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.scaled),
                  ),
                ),
                child: Text(
                  'cancel'.tr,
                  style: TextStyle(
                    fontSize: 16.scaled,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  ).then((result) => result ?? false);
}
