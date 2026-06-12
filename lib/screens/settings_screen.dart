import 'package:flutter/material.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.space16),
        children: [
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
                          'App Version 1.0.8',
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
                        'v1.0.8',
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

          const SizedBox(height: AppTheme.space100),
        ],
      ),
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
