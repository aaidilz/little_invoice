import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/providers/buyer_provider.dart';
import 'package:little_invoice/screens/buyer_form_screen.dart';
import 'package:little_invoice/widgets/empty_state_widget.dart';

class BuyerListScreen extends StatelessWidget {
  const BuyerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BuyerProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // ── Search bar (matching DESIGN) ──
            Padding(
              padding: const EdgeInsets.all(AppTheme.space16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search clients by name or email...',
                  hintStyle: AppTextStyles.bodyLg.copyWith(
                    color: AppColors.outline,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.outline,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space16,
                    vertical: AppTheme.space16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                    borderSide: const BorderSide(
                      color: AppColors.outlineVariant,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                    borderSide: const BorderSide(
                      color: AppColors.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                    borderSide: const BorderSide(
                      color: AppColors.primaryContainer,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            // ── Header ──
            if (provider.buyers.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Clients',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '${provider.buyers.length} total',
                      style: AppTextStyles.labelBold.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppTheme.space8),

            // ── List ──
            Expanded(
              child: provider.buyers.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.group_off_outlined,
                      headline: 'No clients found',
                      body:
                          'Start adding your business contacts to manage your invoices more efficiently.',
                      ctaLabel: 'Add Client',
                      onCta: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BuyerFormScreen(),
                          ),
                        );
                      },
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.space16,
                        vertical: AppTheme.space8,
                      ),
                      itemCount: provider.buyers.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppTheme.space12),
                      itemBuilder: (ctx, idx) {
                        final buyer = provider.buyers[idx];
                        final initials = _getInitials(buyer.name);

                        return Dismissible(
                          key: Key(buyer.id.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(
                              right: AppTheme.space24,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusCard,
                              ),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          onDismissed: (_) {
                            provider.deleteBuyer(buyer.id!);
                          },
                          child: _BuyerCard(
                            initials: initials,
                            name: buyer.name,
                            email: buyer.email,
                            phone: buyer.phone,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BuyerFormScreen(
                                    buyer: buyer,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

/// Client card matching the DESIGN card pattern: avatar initials,
/// name, contact info, decorative corner blob.
class _BuyerCard extends StatelessWidget {
  final String initials;
  final String name;
  final String email;
  final String phone;
  final VoidCallback onTap;

  const _BuyerCard({
    required this.initials,
    required this.name,
    required this.email,
    required this.phone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        child: Stack(
          children: [
            // Decorative corner blob
            Positioned(
              right: -12,
              top: -12,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.04),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(64),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppTheme.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusSmall,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.space12),
                      Expanded(
                        child: Text(
                          name,
                          style: AppTextStyles.bodyLg.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.space12),

                  // Contact details
                  _ContactRow(
                    icon: Icons.mail_outline,
                    text: email,
                  ),
                  const SizedBox(height: AppTheme.space4),
                  _ContactRow(
                    icon: Icons.phone_outlined,
                    text: phone,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
        const SizedBox(width: AppTheme.space8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
