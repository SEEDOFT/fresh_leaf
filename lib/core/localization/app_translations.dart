import 'package:get/get.dart';

final class AppTranslations extends Translations {
  static final Map<String, String> _en = {
    'settings': 'Settings',
    'theme': 'Theme',
    'language': 'Language',
    'utilities': 'Utilities',
    'system': 'System',
    'light': 'Light',
    'dark': 'Dark',
    'english': 'English',
    'khmer': 'Khmer',
    'notifications': 'Push Notifications',
    'clear_ai_chat': 'Clear AI Chat History',
    'open_system_settings': 'Open System Settings',
    'remove_old_ai': 'Remove old AI conversations',
    'manage_permission': 'Manage location and notification permission',
    'chat_history_cleared': 'Chat history cleared',
    'appearance': 'Appearance',
    'preferences': 'Preferences',
    'app_language': 'App Language',
    'choose_theme': 'Choose your theme mode',
    'other': 'Other',
    'current': 'Current',
    'general_settings': 'General Settings',
    'manage_app_pref': 'Manage app preference and utility options',
  };

  static final Map<String, String> _km = {
    'settings': 'ការកំណត់',
    'theme': 'រូបរាង',
    'language': 'ភាសា',
    'utilities': 'ឧបករណ៍',
    'system': 'ប្រព័ន្ធ',
    'light': 'ភ្លឺ',
    'dark': 'ងងឹត',
    'english': 'អង់គ្លេស',
    'khmer': 'ខ្មែរ',
    'notifications': 'ការជូនដំណឹង',
    'clear_ai_chat': 'សម្អាតប្រវត្តិ AI Chat',
    'open_system_settings': 'បើកការកំណត់ប្រព័ន្ធ',
    'remove_old_ai': 'លុបប្រវត្តិជជែក AI ចាស់ៗ',
    'manage_permission': 'គ្រប់គ្រងការអនុញ្ញាតទីតាំង និងការជូនដំណឹង',
    'chat_history_cleared': 'បានសម្អាតប្រវត្តិជជែករួចរាល់',
    'appearance': 'រូបរាង',
    'preferences': 'ចំណូលចិត្ត',
    'app_language': 'ភាសាកម្មវិធី',
    'choose_theme': 'ជ្រើសរើសរបៀបរូបរាង',
    'other': 'ផ្សេងៗ',
    'current': 'បច្ចុប្បន្ន',
    'general_settings': 'ការកំណត់ទូទៅ',
    'manage_app_pref': 'គ្រប់គ្រងចំណូលចិត្ត និងឧបករណ៍កម្មវិធី',
  };

  @override
  Map<String, Map<String, String>> get keys => {
    'en': _en,
    'en_US': _en,
    'km': _km,
    'km_KH': _km,
  };
}
