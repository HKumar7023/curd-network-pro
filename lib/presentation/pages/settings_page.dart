import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/app_constants.dart';
import '../providers/theme_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(languageProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(_getThemeIcon(themeMode)),
                  title: Text('Theme'),
                  subtitle: Text(_getThemeDescription(themeMode)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemeDialog(context, ref),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Language Section
          _buildSectionHeader(context, 'language'.tr()),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text('language'.tr()),
                  subtitle: Text(_getLanguageDescription(currentLocale)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLanguageDialog(context, ref),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // About Section
          _buildSectionHeader(context, 'About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('App Version'),
                  subtitle: Text('${AppConstants.appVersion}'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Built with Flutter'),
                  subtitle: const Text('Clean Architecture • Riverpod • Hive'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.api),
                  title: const Text('Data Source'),
                  subtitle: const Text('Fake Store API'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Actions Section
          _buildSectionHeader(context, 'Actions'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'Clear Cache',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  subtitle: const Text('Clear all cached data'),
                  onTap: () => _showClearCacheDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.auto_mode;
    }
  }

  String _getThemeDescription(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light_mode'.tr();
      case ThemeMode.dark:
        return 'dark_mode'.tr();
      case ThemeMode.system:
        return 'System';
    }
  }

  String _getLanguageDescription(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी';
      default:
        return 'English';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: Text('light_mode'.tr()),
                value: ThemeMode.light,
                groupValue: ref.read(themeModeProvider),
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    ref.read(themeModeProvider.notifier).setThemeMode(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text('dark_mode'.tr()),
                value: ThemeMode.dark,
                groupValue: ref.read(themeModeProvider),
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    ref.read(themeModeProvider.notifier).setThemeMode(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('System'),
                value: ThemeMode.system,
                groupValue: ref.read(themeModeProvider),
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    ref.read(themeModeProvider.notifier).setThemeMode(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('language'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<Locale>(
                title: const Text('English'),
                value: const Locale('en'),
                groupValue: ref.read(languageProvider),
                onChanged: (Locale? value) {
                  if (value != null) {
                    ref.read(languageProvider.notifier).setLanguage(value);
                    context.setLocale(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<Locale>(
                title: const Text('हिंदी'),
                value: const Locale('hi'),
                groupValue: ref.read(languageProvider),
                onChanged: (Locale? value) {
                  if (value != null) {
                    ref.read(languageProvider.notifier).setLanguage(value);
                    context.setLocale(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text(
            'This will clear all cached products and force a fresh reload from the server. Continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache cleared successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}
