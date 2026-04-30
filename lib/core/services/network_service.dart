import 'dart:io';

final class NetworkService {
  NetworkService._();

  static Future<bool> hasInternetConnection() async {
    try {
      // Fast path: direct socket test (does not rely on DNS resolution).
      final socket = await Socket.connect(
        '1.1.1.1',
        53,
        timeout: const Duration(seconds: 3),
      );
      socket.destroy();
      return true;
    } on SocketException {
      // Fall through to DNS-based check.
    } on Exception {
      // Fall through to DNS-based check.
    }

    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException {
      return false;
    } on Exception {
      return false;
    }

    return false;
  }
}
