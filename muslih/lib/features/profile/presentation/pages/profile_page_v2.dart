import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:muslih/core/theme/app_theme_v2.dart';
import 'package:muslih/l10n/app_localizations.dart';

// --- Settings / Profile V2 ------------------------------------------------
class ProfilePageV2 extends ConsumerWidget {
  const ProfilePageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme.primary;
    final themeMode = ref.watch(themeModeProvider);
    final lang = const S();

    return Scaffold(
      appBar: AppBar(title: Text(lang.profile)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Avatar + Info card
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: color.withValues(alpha: 0.1),
                  child: Icon(Icons.person, size: 44, color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  'اسم المستخدم',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'user@example.com',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Menu items
          _MenuItem(
            icon: Icons.settings,
            title: lang.settings,
            subtitle: lang.language,
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.palette,
            title: lang.theme,
            subtitle: themeMode == ThemeMode.dark
                ? lang.darkTheme
                : lang.lightTheme,
            trailingWidget: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (_) {
                ref.read(themeModeProvider.notifier).state =
                    themeMode == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light;
              },
            ),
          ),
          _MenuItem(
            icon: Icons.translate,
            title: lang.language,
            subtitle: 'العربية',
            onTap: () {},
          ),
          const Divider(height: 40),
          _MenuItem(
            icon: Icons.logout,
            title: lang.logout,
            titleColor: Colors.red,
            onTap: () {},
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '${lang.appName} v2.0.0',
              style: TextStyle(
                  color: Colors.grey.shade500, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailingWidget;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailingWidget,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: titleColor ?? color),
        title: Text(title,
            style: TextStyle(
                color: titleColor ??
                    Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500)),
        subtitle: subtitle != null
            ? Text(subtitle!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant))
            : null,
        trailing: trailingWidget,
        onTap: onTap,
      ),
    );
  }
}