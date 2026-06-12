import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/core/utils/currency_formatter.dart';
import 'package:little_invoice/models/invoice.dart';
import 'package:little_invoice/providers/invoice_provider.dart';
import 'package:little_invoice/screens/invoice_list_screen.dart';
import 'package:little_invoice/screens/invoice_detail_screen.dart';
import 'package:little_invoice/screens/invoice_form_screen.dart';
import 'package:little_invoice/screens/buyer_list_screen.dart';
import 'package:little_invoice/screens/settings_screen.dart';
import 'package:little_invoice/screens/seller_profile_screen.dart';
import 'package:little_invoice/widgets/invoice_card.dart';
import 'package:little_invoice/widgets/empty_state_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static void setTabIndex(BuildContext context, int index) {
    context.findAncestorStateOfType<_HomeScreenState>()?.setTabIndex(index);
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void setTabIndex(int index) {
    setState(() => _currentIndex = index);
  }

  static const _navItems = [
    _NavItem(Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
    _NavItem(Icons.receipt_long_outlined, Icons.receipt_long, 'Invoices'),
    _NavItem(Icons.people_outline, Icons.people, 'Clients'),
    _NavItem(Icons.person_outline, Icons.person, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── AppBar matching DESIGN TopAppBar ──
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.rectangle,
              ),
              child: Image.asset(
                'assets/images/Icon.png',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: AppTheme.space12),
            Text(
              'Little Invoice',
              style: AppTextStyles.h1.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.onSurfaceVariant,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(),
          InvoiceListScreen(),
          BuyerListScreen(),
          SellerProfileScreen(),
        ],
      ),

      // ── Bottom Nav matching DESIGN BottomNavBar ──
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          boxShadow: AppTheme.bottomBarShadow,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final isSelected = _currentIndex == i;
                return _buildNavItem(item, isSelected, () {
                  setState(() => _currentIndex = i);
                });
              }),
            ),
          ),
        ),
      ),

      // ── FAB ──
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InvoiceFormScreen()),
                );
              },
              child: const Icon(Icons.add, size: 28),
            )
          : null,
    );
  }

  Widget _buildNavItem(
    _NavItem item,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              size: 24,
              color: isSelected
                  ? AppColors.onPrimaryContainer
                  : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: AppTextStyles.labelBold.copyWith(
                color: isSelected
                    ? AppColors.onPrimaryContainer
                    : AppColors.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(this.icon, this.activeIcon, this.label);
}

// ─────────────────────────────────────────────────────────────
// Home Tab (Dashboard)
// ─────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(
      builder: (BuildContext context, InvoiceProvider provider, Widget? child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final invoices = provider.invoices;
        final totalInvoices = invoices.length;
        final unpaidInvoices =
            invoices.where((i) => i.status == InvoiceStatus.unpaid).toList();
        final paidInvoices =
            invoices.where((i) => i.status == InvoiceStatus.paid).toList();
        final totalAmountDue =
            unpaidInvoices.fold(0.0, (sum, i) => sum + i.total);

        final recentInvoices = invoices.reversed.take(5).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppTheme.space16),

              // ── Stats Bento Grid (matching DESIGN) ──
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'TOTAL INVOICES',
                      value: totalInvoices.toString(),
                      icon: Icons.receipt_long_outlined,
                    ),
                  ),
                  const SizedBox(width: AppTheme.space12),
                  Expanded(
                    child: _StatCard(
                      label: 'UNPAID',
                      value: unpaidInvoices.length.toString(),
                      icon: Icons.pending_actions_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.space12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'PAID',
                      value: paidInvoices.length.toString(),
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                  const SizedBox(width: AppTheme.space12),
                  Expanded(
                    child: _StatCard(
                      label: 'AMOUNT DUE',
                      value: CurrencyFormatter.formatCompact(totalAmountDue),
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.space24),

              // ── Recent invoices header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Invoices',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      HomeScreen.setTabIndex(context, 1);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'See All',
                          style: AppTextStyles.labelBold.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: AppColors.secondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.space12),

              // ── Invoice list ──
              recentInvoices.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.space32,
                      ),
                      child: EmptyStateWidget(
                        icon: Icons.receipt_long_outlined,
                        headline: 'No invoices yet',
                        body:
                            'Create your first invoice to get started with Little Invoice',
                        ctaLabel: 'Create Invoice',
                        onCta: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InvoiceFormScreen(),
                            ),
                          );
                        },
                      ),
                    )
                  : Column(
                      children: recentInvoices
                          .map((invoice) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppTheme.space12,
                                ),
                                child: InvoiceCard(
                                  invoice: invoice,
                                  onTap: () {
                                    HomeScreen.setTabIndex(context, 1);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => InvoiceDetailScreen(
                                          invoiceId: invoice.id!,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ))
                          .toList(),
                    ),

              // Bottom breathing room for FAB
              const SizedBox(height: AppTheme.space100),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Stat Card (Bento style, matching DESIGN Stats section)
// ─────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: AppColors.surfaceContainer),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: AppTheme.space8),
          Text(
            label,
            style: AppTextStyles.labelBold.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppTheme.space4),
          Text(
            value,
            style: AppTextStyles.statDisplay.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
