import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';

class StorageService extends GetxService {
  StorageService({GetStorage? box}) : _box = box ?? GetStorage();

  final GetStorage _box;
  static const _tokenKey = 'access_token';
  static const _onboardingSeenKey = 'onboarding_seen';
  static const _securityPinKey = 'security_pin';
  static const _pinOrderVerificationKey = 'pin_order_verification';
  static const _themeModeKey = 'theme_mode';
  static const _languageCodeKey = 'language_code';
  static const _countryCodeKey = 'country_code';
  static const _notificationsEnabledKey = 'notifications_enabled';

  String? _token;
  bool _onboardingSeen = false;
  UserProfile? _userProfile;
  String? _securityPin;
  bool _pinOrderVerification = false;
  String _themeMode = 'system';
  String? _languageCode = 'en';
  String? _countryCode;
  bool _notificationsEnabled = true;

  String? get token => _token;
  bool get onboardingSeen => _onboardingSeen;
  UserProfile? get userProfile => _userProfile;
  String? get securityPin => _securityPin;
  bool get pinOrderVerification => _pinOrderVerification;
  String get themeMode => _themeMode;
  String? get languageCode => _languageCode;
  String? get countryCode => _countryCode;
  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> init() async {
    _token = _box.read<String?>(_tokenKey);
    _onboardingSeen = _box.read<bool>(_onboardingSeenKey) ?? false;
    _securityPin = _box.read<String?>(_securityPinKey);
    _pinOrderVerification = _box.read<bool>(_pinOrderVerificationKey) ?? false;
    _themeMode = _box.read<String>(_themeModeKey) ?? 'system';
    _languageCode = _box.read<String>(_languageCodeKey) ?? 'en';
    _countryCode = _box.read<String?>(_countryCodeKey);
    _notificationsEnabled = _box.read<bool>(_notificationsEnabledKey) ?? true;
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
    _securityPin = null;
    _pinOrderVerification = false;
    await _box.remove(_tokenKey);
    await _box.remove(_onboardingSeenKey);
    await _box.remove(_securityPinKey);
    await _box.remove(_pinOrderVerificationKey);
  }

  Future<void> saveOnboardingSeen(bool seen) async {
    _onboardingSeen = seen;
    await _box.write(_onboardingSeenKey, seen);
  }

  Future<void> saveSecurityPin(String? pin) async {
    _securityPin = pin;
    if (pin == null || pin.isEmpty) {
      await _box.remove(_securityPinKey);
    } else {
      await _box.write(_securityPinKey, pin);
    }
  }

  Future<void> savePinOrderVerification(bool enabled) async {
    _pinOrderVerification = enabled;
    await _box.write(_pinOrderVerificationKey, enabled);
  }

  Future<void> saveThemeMode(String themeMode) async {
    _themeMode = themeMode;
    await _box.write(_themeModeKey, themeMode);
  }

  Future<void> saveLocale(String languageCode, String? countryCode) async {
    _languageCode = languageCode;
    _countryCode = countryCode;
    await _box.write(_languageCodeKey, languageCode);
    if (countryCode == null || countryCode.isEmpty) {
      await _box.remove(_countryCodeKey);
    } else {
      await _box.write(_countryCodeKey, countryCode);
    }
  }

  Future<void> saveNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _box.write(_notificationsEnabledKey, enabled);
  }
}
