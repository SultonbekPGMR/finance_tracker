// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:finance_tracker/core/util/extension/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/data/model/user_model.dart';
import '../../data/model/user_preferences.dart';
import '../bloc/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          context.l10n.profile,
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: context.colorScheme.surface,
        elevation: 0,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileInitial() => const SizedBox(),
            ProfileLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ProfileError error => _buildErrorState(error.message),
            ProfileLoaded loaded => _buildContent(loaded, false),
            ProfileUpdating updating => _buildContent(updating, true),
          };
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: context.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            context.l10n.errorLoadingProfile,
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colorScheme.error,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<ProfileCubit>().loadProfile(),
            child: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(dynamic state, bool isLoading) {
    final user = state.user as UserModel;
    final preferences = state.preferences as UserPreferences;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildUserCard(user, isLoading),
          const SizedBox(height: 24),
          _buildPreferencesCard(preferences, isLoading),
          const SizedBox(height: 24),
          _buildActionsCard(),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserModel user, bool isLoading) {
    return Card(
      elevation: 0,
      color: context.colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: context.colorScheme.primary,
              child: Text(
                user.name.firstLetter,
                style: context.textTheme.headlineLarge?.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed:
                    isLoading ? null : () => _showEditNameDialog(user.name),
                icon: const Icon(Icons.edit, size: 18),
                label: Text(
                  user.name.isEmpty
                      ? context.l10n.setName
                      : context.l10n.editName
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesCard(UserPreferences preferences, bool isLoading) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.preferences,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildPreferenceItem(
              Icons.palette_outlined,
              context.l10n.theme,
              _getThemeDisplayName(preferences.themeMode),
              isLoading ? null : () => _showThemeDialog(preferences.themeMode),
            ),
            _buildPreferenceItem(
              Icons.language_outlined,
              context.l10n.language,
              _getLanguageDisplayName(preferences.language),
              isLoading
                  ? null
                  : () => _showLanguageDialog(preferences.language),
            ),
            _buildPreferenceItem(
              Icons.attach_money_outlined,
              context.l10n.currency,
              preferences.currency,
              isLoading
                  ? null
                  : () => _showCurrencyDialog(preferences.currency),
            ),
            _buildSwitchItem(
              Icons.notifications_outlined,
              context.l10n.notifications,
              preferences.notificationsEnabled,
              isLoading
                  ? null
                  : (value) =>
                      context.read<ProfileCubit>().updateNotifications(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItem(
    IconData icon,
    String title,
    String value,
    VoidCallback? onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(icon, color: context.colorScheme.primary, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.textTheme.bodyMedium),
                    Text(
                      value,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null) const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    IconData icon,
    String title,
    bool value,
    ValueChanged<bool>? onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: context.colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: context.textTheme.bodyMedium)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildActionsCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Export data
                },
                icon: const Icon(Icons.download_outlined),
                label: Text(context.l10n.exportData),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showSignOutDialog,
                icon: Icon(Icons.logout, color: context.colorScheme.error),
                label: Text(
                  context.l10n.signOut,
                  style: TextStyle(color: context.colorScheme.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: context.colorScheme.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeDisplayName(String theme) => switch (theme) {
    'light' => context.l10n.light,
    'dark' => context.l10n.dark,
    _ => context.l10n.system,
  };

  String _getLanguageDisplayName(String language) => switch (language) {
    'uz' => 'O\'zbek',
    _ => 'English',
  };

  void _showThemeDialog(String current) {
    final profileCubit =
        context.read<ProfileCubit>(); // Capture cubit reference

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(context.l10n.selectTheme),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRadioOption(
                  'system',
                  context.l10n.system,
                  current,
                  (value) => profileCubit.updateTheme(value!),
                ),
                _buildRadioOption(
                  'light',
                  context.l10n.light,
                  current,
                  (value) => profileCubit.updateTheme(value!),
                ),
                _buildRadioOption(
                  'dark',
                  context.l10n.dark,
                  current,
                  (value) => profileCubit.updateTheme(value!),
                ),
              ],
            ),
          ),
    );
  }

  void _showLanguageDialog(String current) {
    final profileCubit =
        context.read<ProfileCubit>(); // Capture cubit reference

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(context.l10n.selectLanguage),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRadioOption(
                  'en',
                  'English',
                  current,
                  (value) => profileCubit.updateLanguage(value!),
                ),
                _buildRadioOption(
                  'uz',
                  'O\'zbek',
                  current,
                  (value) => profileCubit.updateLanguage(value!),
                ),
              ],
            ),
          ),
    );
  }

  void _showCurrencyDialog(String current) {
    final profileCubit =
        context.read<ProfileCubit>(); // Capture cubit reference
    final currencies = ['USD', 'EUR', 'UZS', 'RUB'];

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(context.l10n.selectCurrency),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  currencies
                      .map(
                        (currency) => _buildRadioOption(
                          currency,
                          currency,
                          current,
                          (value) => profileCubit.updateCurrency(value!),
                        ),
                      )
                      .toList(),
            ),
          ),
    );
  }

  void _showEditNameDialog(String currentName) {
    final profileCubit =
        context.read<ProfileCubit>(); // Capture cubit reference
    _nameController.text = currentName;

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(context.l10n.editName),
            content: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: context.l10n.displayName,
                border: const OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(context.l10n.cancel),
              ),
              FilledButton(
                onPressed: () {
                  if (_nameController.text.trim().isNotEmpty) {
                    profileCubit.updateDisplayName(_nameController.text.trim());
                    Navigator.pop(dialogContext);
                  }
                },
                child: Text(context.l10n.save),
              ),
            ],
          ),
    );
  }

  Widget _buildRadioOption(
    String value,
    String title,
    String current,
    ValueChanged<String?> onChanged,
  ) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: current,
      onChanged: (value) {
        onChanged(value);
        context.pop(); // Use the screen's context, not dialog context
      },
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.l10n.signOut),
            content: Text(context.l10n.signOutConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.l10n.cancel),
              ),
              FilledButton(
                onPressed: () {
                  context.pop();
                  // TODO: Handle sign out
                },
                style: FilledButton.styleFrom(
                  backgroundColor: context.colorScheme.error,
                ),
                child: Text(context.l10n.signOut),
              ),
            ],
          ),
    );
  }
}
