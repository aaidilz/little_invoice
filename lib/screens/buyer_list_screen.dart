import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:invoice_app/core/theme/app_colors.dart';
import 'package:invoice_app/core/theme/app_text_styles.dart';
import 'package:invoice_app/core/theme/app_theme.dart';
import 'package:invoice_app/providers/buyer_provider.dart';
import 'package:invoice_app/screens/buyer_form_screen.dart';
import 'package:invoice_app/widgets/empty_state_widget.dart';

class BuyerListScreen extends StatelessWidget {
  const BuyerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyers'),
      ),
      body: Consumer<BuyerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppTheme.space16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search buyers...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space16,
                      vertical: AppTheme.space12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: provider.buyers.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.person_outline,
                        headline: 'No buyers yet',
                        body: 'Add your first buyer to get started',
                        ctaLabel: 'Add Buyer',
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
                          vertical: AppTheme.space12,
                        ),
                        itemCount: provider.buyers.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppTheme.space12),
                        itemBuilder: (ctx, idx) {
                          final buyer = provider.buyers[idx];
                          return Dismissible(
                            key: Key(buyer.id.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: AppColors.error,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(
                                right: AppTheme.space16,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) {
                              provider.deleteBuyer(buyer.id!);
                            },
                            child: Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(
                                  AppTheme.space16,
                                ),
                                title: Text(
                                  buyer.name,
                                  style: AppTextStyles.title,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: AppTheme.space4),
                                    Text(
                                      buyer.phone,
                                      style: AppTextStyles.caption,
                                    ),
                                    Text(
                                      buyer.email,
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right,
                                ),
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
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BuyerFormScreen()),
          );
        },
        label: const Text('Add Buyer'),
        icon: const Icon(Icons.person_add),
      ),
    );
  }
}
