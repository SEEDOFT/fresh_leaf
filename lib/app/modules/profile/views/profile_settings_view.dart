import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_settings_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_settings_widget.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:get/get.dart';

class ProfileSettingsView extends GetView<ProfileSettingsController> {
  const ProfileSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: ProfileAppBar(title: 'settings'.tr),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsSectionTitle(
                title: 'general_settings'.tr,
                subtitle: 'manage_app_pref'.tr,
              ),
              const SizedBox(height: 12),
              SettingsCard(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('theme'.tr),
                    subtitle: Text('choose_theme'.tr),
                    trailing: DropdownButton<ThemeMode>(
                      value: controller.themeMode.value,
                      underline: const SizedBox.shrink(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.changeTheme(value);
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('system'.tr),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('light'.tr),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('dark'.tr),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('app_language'.tr),
                    subtitle: Text('current'.tr),
                    trailing: DropdownButton<String>(
                      value: controller.locale.value.languageCode,
                      underline: const SizedBox.shrink(),
                      onChanged: (value) {
                        if (value == 'km') {
                          controller.changeLanguage(const Locale('km'));
                        } else if (value == 'en') {
                          controller.changeLanguage(const Locale('en'));
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('english'.tr),
                        ),
                        DropdownMenuItem(value: 'km', child: Text('khmer'.tr)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: controller.notificationsEnabled.value,
                    contentPadding: EdgeInsets.zero,
                    title: Text('notifications'.tr),
                    activeColor: scheme.primary,
                    onChanged: (value) =>
                        controller.toggleNotification(enabled: value),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SettingsSectionTitle(
                title: 'utilities'.tr,
                subtitle: 'other'.tr,
              ),
              const SizedBox(height: 12),
              SettingsCard(
                children: [
                  SettingsActionTile(
                    icon: Icons.cleaning_services_outlined,
                    title: 'clear_ai_chat'.tr,
                    subtitle: 'remove_old_ai'.tr,
                    onTap: controller.clearAiHistory,
                  ),
                  const Divider(height: 1),
                  SettingsActionTile(
                    icon: Icons.settings_applications_outlined,
                    title: 'open_system_settings'.tr,
                    subtitle: 'manage_permission'.tr,
                    onTap: controller.openDeviceSettings,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: screenWidth,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text(
                    'FreshLeaf v1.0.0',
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
