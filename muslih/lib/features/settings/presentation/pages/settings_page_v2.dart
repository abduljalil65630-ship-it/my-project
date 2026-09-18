import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:muslih/core/theme/app_theme_v2.dart';
import 'package:muslih/l10n/app_localizations.dart';

// --- Settings Page v2 -------------------------------
class SettingsPageV2 extends ConsumerWidget {
  const SettingsPageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme.primary;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _settingsTile(
            icon: Icons.translate,
            title: 'اللغة',
            subtitle: 'العربية',
            trailing: Icon(Icons.arrow_back_ios, size: 16),
            onTap: () {},
            color: color,
          ),
          _settingsTile(
            icon: Icons.palette,
            title: 'المظهر',
            subtitle: themeMode == ThemeMode.dark ? 'داكن' : 'فاتح',
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (_) {
                ref.read(themeModeProvider.notifier).state =
                    themeMode == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light;
              },
            ),
            color: color,
          ),
          _settingsTile(
            icon: Icons.notifications,
            title: 'التنبيهات',
            subtitle: 'مفعّلة',
            trailing: Icon(Icons.arrow_back_ios, size: 16),
            onTap: () {},
            color: color,
          ),
          _settingsTile(
            icon: Icons.security,
            title: 'الأمان',
            subtitle: 'بصمة الإصبع',
            trailing: Icon(Icons.arrow_back_ios, size: 16),
            onTap: () {},
            color: color,
          ),
          _settingsTile(
            icon: Icons.help_outline,
            title: 'المساعدة',
            subtitle: 'اتصل بنا',
            trailing: Icon(Icons.arrow_back_ios, size: 16),
            onTap: () {},
            color: color,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('تسجيل الخروج', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _settingsTile({
  required IconData icon,
  required String title,
  required String subtitle,
  required Widget? trailing,
  required VoidCallback onTap,
  required Color color,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
    ),
  );
}