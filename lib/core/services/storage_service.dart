import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';

class StorageService extends GetxService {
  StorageService({GetStorage? box}) : _box = box ?? GetStorage();

  final GetStorage _box;
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_profile';
  static const _onboardingSeenKey = 'onboarding_seen';

  String? _token;
  UserProfile? _user;
  bool _onboardingSeen = false;

  String? get token => _token;
  UserProfile? get user => _user;
  bool get onboardingSeen => _onboardingSeen;

  Future<void> init() async {
    _token = _box.read<String?>(_tokenKey);
    final storedUser = _box.read<Map<String, dynamic>?>(_userKey);
    if (storedUser != null) {
      _user = UserProfile.fromMap(storedUser);
    }
    _onboardingSeen = _box.read<bool>(_onboardingSeenKey) ?? false;
  }

  Future<void> saveToken(String? token) async {
    _token = token;
    if (token == null) {
      await _box.remove(_tokenKey);
    } else {
      await _box.write(_tokenKey, token);
    }
  }

  Future<void> saveUser(UserProfile? user) async {
    _user = user;
    if (user == null) {
      await _box.remove(_userKey);
    } else {
      await _box.write(_userKey, user.toMap());
    }
  }

  Future<void> clear() async {
    _token = null;
    _user = null;
    _onboardingSeen = false;
    await _box.remove(_tokenKey);
    await _box.remove(_userKey);
    await _box.remove(_onboardingSeenKey);
  }

  Future<void> saveOnboardingSeen(bool seen) async {
    _onboardingSeen = seen;
    await _box.write(_onboardingSeenKey, seen);
  }
}
