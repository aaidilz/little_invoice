import 'package:flutter/material.dart';
import 'package:invoice_app/core/theme/app_colors.dart';
import 'package:invoice_app/core/theme/app_text_styles.dart';
import 'package:invoice_app/core/theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String headline;
  final String body;
  final String? ctaLabel;
  final VoidCallback? onCta;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.headline,
    required this.body,
    this.ctaLabel,
    this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 260),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: AppColors.onSurface.withOpacity(0.4),
            ),
            const SizedBox(height: AppTheme.space16),
            Text(
              headline,
              style: AppTextStyles.headline,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.space8),
            Text(
              body,
              style: AppTextStyles.body.copyWith(
                color: AppColors.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (ctaLabel != null && onCta != null) ...[
              const SizedBox(height: AppTheme.space24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onCta,
                  child: Text(ctaLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
