import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';

class StorageService extends GetxService {
  StorageService({GetStorage? box}) : _box = box ?? GetStorage();

  final GetStorage _box;
  static const _tokenKey = 'access_token';
  static const _onboardingSeenKey = 'onboarding_seen';

  String? _token;
  bool _onboardingSeen = false;
  UserProfile? _userProfile;

  String? get token => _token;
  bool get onboardingSeen => _onboardingSeen;
  UserProfile? get userProfile => _userProfile;

  Future<void> init() async {
    _token = _box.read<String?>(_tokenKey);
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

  // In-memory only user profile (not persisted)
  void setUserProfile(UserProfile? profile) {
    _userProfile = profile;
  }

  Future<void> clear() async {
    _token = null;
    _onboardingSeen = false;
    _userProfile = null;
    await _box.remove(_tokenKey);
    await _box.remove(_onboardingSeenKey);
  }

  Future<void> saveOnboardingSeen(bool seen) async {
    _onboardingSeen = seen;
    await _box.write(_onboardingSeenKey, seen);
  }
}
