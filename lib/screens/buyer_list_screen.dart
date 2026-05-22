import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/models/buyer.dart';
import 'package:little_invoice/providers/buyer_provider.dart';
import 'package:little_invoice/providers/invoice_provider.dart';
import 'package:little_invoice/screens/buyer_form_screen.dart';
import 'package:little_invoice/widgets/empty_state_widget.dart';

class BuyerListScreen extends StatefulWidget {
  const BuyerListScreen({super.key});

  @override
  State<BuyerListScreen> createState() => _BuyerListScreenState();
}

class _BuyerListScreenState extends State<BuyerListScreen> {
  String _searchQuery = '';

  /// Filter buyers by search query (name or email, case-insensitive).
  List<Buyer> _filterBuyers(List<Buyer> buyers) {
    if (_searchQuery.isEmpty) return buyers;
    final q = _searchQuery.toLowerCase();
    return buyers.where((b) {
      return b.name.toLowerCase().contains(q) ||
          b.email.toLowerCase().contains(q);
    }).toList();
  }

  /// Check if any invoice references this buyer before deleting.
  Future<bool> _confirmDelete(BuildContext context, Buyer buyer) async {
    final invoiceProvider = context.read<InvoiceProvider>();
    final hasInvoices =
        invoiceProvider.invoices.any((i) => i.buyerId == buyer.id);

    if (hasInvoices) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Cannot Delete Client'),
          content: Text(
            '${buyer.name} has existing invoices. '
            'Delete all related invoices first, or force delete?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Force Delete'),
            ),
          ],
        ),
      );
      return confirmed == true;
    }

    // No invoices — still ask for confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Client'),
        content: Text('Are you sure you want to delete ${buyer.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BuyerProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show provider errors
        if (provider.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${provider.errorMessage}')),
              );
            }
          });
        }

        final filteredBuyers = _filterBuyers(provider.buyers);

        return Column(
          children: [
            // ── Search bar (matching DESIGN) ──
            Padding(
              padding: const EdgeInsets.all(AppTheme.space16),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search clients by name or email...',
                  hintStyle: AppTextStyles.bodyLg.copyWith(
                    color: AppColors.outline,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.outline,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () =>
                              setState(() => _searchQuery = ''),
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space16,
                    vertical: AppTheme.space16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusCard),
                    borderSide: const BorderSide(
                      color: AppColors.outlineVariant,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusCard),
                    borderSide: const BorderSide(
                      color: AppColors.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusCard),
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
                      _searchQuery.isEmpty
                          ? '${provider.buyers.length} total'
                          : '${filteredBuyers.length} of ${provider.buyers.length}',
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
              child: filteredBuyers.isEmpty
                  ? EmptyStateWidget(
                      icon: _searchQuery.isNotEmpty
                          ? Icons.search_off_outlined
                          : Icons.group_off_outlined,
                      headline: _searchQuery.isNotEmpty
                          ? 'No results'
                          : 'No clients found',
                      body: _searchQuery.isNotEmpty
                          ? 'No clients match "$_searchQuery".'
                          : 'Start adding your business contacts to manage your invoices more efficiently.',
                      ctaLabel:
                          _searchQuery.isNotEmpty ? null : 'Add Client',
                      onCta: _searchQuery.isNotEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const BuyerFormScreen(),
                                ),
                              );
                            },
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.space16,
                        vertical: AppTheme.space8,
                      ),
                      itemCount: filteredBuyers.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppTheme.space12),
                      itemBuilder: (ctx, idx) {
                        final buyer = filteredBuyers[idx];
                        final initials = _getInitials(buyer.name);

                        return Dismissible(
                          key: Key(buyer.id.toString()),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) =>
                              _confirmDelete(context, buyer),
                          onDismissed: (_) {
                            provider.deleteBuyer(buyer.id!);
                          },
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
