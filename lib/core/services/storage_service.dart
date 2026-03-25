import 'package:get/get.dart';

class StorageService extends GetxService {
  String? _token;

  String? get token => _token;

  Future<void> saveToken(String? token) async {
    _token = token;
  }

  Future<void> clear() async {
    _token = null;
  }
}
