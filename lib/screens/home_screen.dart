import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/core/utils/currency_formatter.dart';
import 'package:little_invoice/models/invoice.dart';
import 'package:little_invoice/providers/invoice_provider.dart';
import 'package:little_invoice/screens/invoice_list_screen.dart';
import 'package:little_invoice/screens/invoice_form_screen.dart';
import 'package:little_invoice/screens/buyer_list_screen.dart';
import 'package:little_invoice/screens/seller_profile_screen.dart';
import 'package:little_invoice/widgets/invoice_card.dart';
import 'package:little_invoice/widgets/empty_state_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InvoiceKu'),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Invoices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Buyers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => InvoiceFormScreen()),
                );
              },
              label: const Text('New Invoice'),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }
}

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
        final totalAmountDue =
            unpaidInvoices.fold(0.0, (sum, i) => sum + i.total);

        final recentInvoices = invoices.reversed.take(5).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppTheme.space16),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Total Invoices',
                      value: totalInvoices.toString(),
                    ),
                  ),
                  const SizedBox(width: AppTheme.space12),
                  Expanded(
                    child: _StatCard(
                      label: 'Unpaid',
                      value: unpaidInvoices.length.toString(),
                    ),
                  ),
                  const SizedBox(width: AppTheme.space12),
                  Expanded(
                    child: _StatCard(
                      label: 'Amount Due',
                      value: CurrencyFormatter.formatCompact(totalAmountDue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.space24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Invoices',
                    style: AppTextStyles.h1,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const InvoiceListScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'See All',
                      style: AppTextStyles.labelBold.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.space12),
              recentInvoices.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.receipt_long_outlined,
                      headline: 'No invoices yet',
                      body: 'Create your first invoice to get started',
                      ctaLabel: 'Create Invoice',
                      onCta: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InvoiceFormScreen(),
                          ),
                        );
                      },
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => InvoiceListScreen(
                                          initialInvoiceId: invoice.id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ))
                          .toList(),
                    ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyles.statDisplay.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppTheme.space4),
            Text(
              label,
              style: AppTextStyles.bodyMd,
            ),
          ],
        ),
      ),
    );
  }
}
