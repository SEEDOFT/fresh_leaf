import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class SupportChatBuildAttachmentPreviewWidget extends StatelessWidget {
  const SupportChatBuildAttachmentPreviewWidget({
    required this.filePath,
    required this.isDark,
    super.key,
  });

  final String filePath;
  final bool isDark;

  bool get isImage =>
      filePath.endsWith('.jpg') ||
      filePath.endsWith('.jpeg') ||
      filePath.endsWith('.png');

  @override
  Widget build(BuildContext context) {
    if (isImage) {
      return GestureDetector(
        onTap: () => _showFullScreenImage(context, filePath),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            filePath,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: const Icon(Icons.error, color: Colors.red),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _downloadFile(filePath),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.insert_drive_file,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                filePath.split('/').last,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFullScreenImage(
    BuildContext context,
    String filePath,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: Image.network(
                  filePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadFile(String filePath) async {
    try {
      await SharePlus.instance.share(ShareParams(uri: Uri.parse(filePath)));
    } on Exception {
      Get.snackbar('Error', 'Could not open file');
    }
  }
}
