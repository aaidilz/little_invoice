import 'package:flutter/material.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // ── Changelog entries ──────────────────────────────────────
  static const _changelog = [
    _ChangelogEntry(
      version: '1.0.5',
      date: 'June 2026',
      changes: [
        'Added Settings screen with version info and changelog',
        'Improved PDF export stability and currency formatting',
        'Fixed profile data persistence on app restart',
        'Restored app icon in top-left navigation bar',
      ],
    ),
    _ChangelogEntry(
      version: '1.0.4',
      date: 'May 2026',
      changes: [
        'Secure asset deletion with RLS policies',
        'Markdown editor integration across invoice forms',
        'Asset management module for evidence attachments',
      ],
    ),
    _ChangelogEntry(
      version: '1.0.3',
      date: 'May 2026',
      changes: [
        'PDF export: fixed text alignment and font rendering',
        'Fixed core library desugaring for Android < API 26',
        'Groovy DSL migration to resolve JDK 25 Gradle conflicts',
      ],
    ),
    _ChangelogEntry(
      version: '1.0.2',
      date: 'May 2026',
      changes: [
        'Buyer list screen with search and pagination',
        'Invoice detail view with status management',
        'Bottom navigation animated pill indicator',
      ],
    ),
    _ChangelogEntry(
      version: '1.0.1',
      date: 'May 2026',
      changes: [
        'Initial invoice CRUD (Create, Read, Update, Delete)',
        'Seller profile with logo, stamp and signature upload',
        'Dashboard stats: total, unpaid, paid, amount due',
      ],
    ),
  ];

  void _showComingSoon(BuildContext context, String feature) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: const Icon(
                Icons.rocket_launch_outlined,
                size: 20,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: AppTheme.space12),
            Text('Coming Soon', style: AppTextStyles.h2),
          ],
        ),
        content: Text(
          '$feature will be available in a future update. Stay tuned! 🚀',
          style: AppTextStyles.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.space16),
      children: [
        const SizedBox(height: AppTheme.space16),

        // ── Page header ──────────────────────────────────────
        Text('Settings', style: AppTextStyles.h1.copyWith(color: AppColors.primary)),
        const SizedBox(height: AppTheme.space4),
        Text(
          'Manage your app preferences and data.',
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: AppTheme.space24),

        // ── Data Management section ───────────────────────────
        _SectionHeader(icon: Icons.storage_outlined, label: 'DATA MANAGEMENT'),
        const SizedBox(height: AppTheme.space12),

        _SettingsCard(
          children: [
            _ComingSoonTile(
              icon: Icons.delete_sweep_outlined,
              iconColor: AppColors.error,
              iconBg: AppColors.errorContainer,
              title: 'Delete All Data',
              subtitle: 'Permanently remove all invoices and clients',
              onTap: () => _showComingSoon(context, 'Delete All Data'),
            ),
            const _Divider(),
            _ComingSoonTile(
              icon: Icons.upload_file_outlined,
              iconColor: AppColors.secondary,
              iconBg: AppColors.secondaryFixed,
              title: 'Import Data',
              subtitle: 'Import invoices and clients from a file',
              onTap: () => _showComingSoon(context, 'Import Data'),
            ),
            const _Divider(),
            _ComingSoonTile(
              icon: Icons.download_outlined,
              iconColor: AppColors.primary,
              iconBg: AppColors.primaryFixed,
              title: 'Export Data',
              subtitle: 'Export all your data to a portable format',
              onTap: () => _showComingSoon(context, 'Export Data'),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.space24),

        // ── About section ─────────────────────────────────────
        _SectionHeader(icon: Icons.info_outline, label: 'ABOUT'),
        const SizedBox(height: AppTheme.space12),

        _SettingsCard(
          children: [
            // App version
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space16,
                vertical: AppTheme.space12,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Image.asset(
                      'assets/images/Icon.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: AppTheme.space12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Little Invoice',
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'App Version 1.0.5',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(AppTheme.radiusBadge),
                    ),
                    child: Text(
                      'v1.0.5',
                      style: AppTextStyles.labelBold.copyWith(
                        color: AppColors.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const _Divider(),
            // Developer
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space16,
                vertical: AppTheme.space12,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryFixed,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: const Icon(
                      Icons.code_outlined,
                      size: 20,
                      color: AppColors.onTertiaryFixed,
                    ),
                  ),
                  const SizedBox(width: AppTheme.space12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Developed by',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Penacode',
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.space24),

        // ── Changelog section ────────────────────────────────
        _SectionHeader(icon: Icons.history_outlined, label: 'CHANGELOG'),
        const SizedBox(height: AppTheme.space12),

        ..._changelog.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.space12),
              child: _ChangelogCard(entry: entry),
            )),

        const SizedBox(height: AppTheme.space100),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
        const SizedBox(width: AppTheme.space8),
        Text(
          label,
          style: AppTextStyles.labelBold.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16);
  }
}

class _ComingSoonTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ComingSoonTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.space16,
          vertical: AppTheme.space12,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: AppTheme.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppTheme.space8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withOpacity(0.25),
                borderRadius: BorderRadius.circular(AppTheme.radiusChip),
              ),
              child: Text(
                'Soon',
                style: AppTextStyles.labelBold.copyWith(
                  color: AppColors.secondary,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangelogCard extends StatelessWidget {
  final _ChangelogEntry entry;
  const _ChangelogCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final isLatest = entry == SettingsScreen._changelog.first;
    return Container(
      padding: const EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(
          color: isLatest ? AppColors.primaryContainer : AppColors.outlineVariant,
          width: isLatest ? 1.5 : 1,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isLatest
                      ? AppColors.primaryContainer
                      : AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppTheme.radiusBadge),
                ),
                child: Text(
                  'v${entry.version}',
                  style: AppTextStyles.labelBold.copyWith(
                    color: isLatest
                        ? AppColors.onPrimaryContainer
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              if (isLatest) ...[
                const SizedBox(width: AppTheme.space8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusChip),
                  ),
                  child: Text(
                    'CURRENT',
                    style: AppTextStyles.labelBold.copyWith(
                      color: AppColors.onSecondaryContainer,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                entry.date,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.space12),
          ...entry.changes.map(
            (change) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isLatest
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.space8),
                  Expanded(
                    child: Text(
                      change,
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────

class _ChangelogEntry {
  final String version;
  final String date;
  final List<String> changes;
  const _ChangelogEntry({
    required this.version,
    required this.date,
    required this.changes,
  });
}
