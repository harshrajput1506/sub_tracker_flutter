import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sub/core/constants/app_constants.dart';
import 'package:sub/core/constants/constants.dart';
import 'package:sub/core/widgets/custom_card.dart';
import 'package:sub/core/widgets/custom_chip.dart';
import 'package:sub/data/models/subscription_model.dart';

/// Card widget displaying subscription information
class SubscriptionCard extends StatelessWidget {
  final SubscriptionModel subscription;
  final VoidCallback? onTap;

  const SubscriptionCard({super.key, required this.subscription, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysUntilRenewal = subscription.daysUntilRenewal;
    final isRenewingSoon = daysUntilRenewal <= 7;

    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name and Price
          Row(
            children: [
              Expanded(
                child: Text(
                  subscription.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${Currencies.getSymbol(subscription.currency)}${subscription.price.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          // Category chip
          CustomChip(
            label: subscription.category,
            icon: _getCategoryIcon(subscription.category),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Renewal information
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isRenewingSoon
                  ? theme.colorScheme.errorContainer
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Row(
              children: [
                Icon(
                  isRenewingSoon
                      ? Icons.warning_amber_rounded
                      : Icons.calendar_today,
                  size: AppIconSize.small,
                  color: isRenewingSoon
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Renewal',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'MMM dd, yyyy',
                        ).format(subscription.nextRenewal),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isRenewingSoon
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isRenewingSoon
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Text(
                    daysUntilRenewal == 0
                        ? 'Today'
                        : daysUntilRenewal == 1
                        ? '1 day'
                        : '$daysUntilRenewal days',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Footer: Recurring period and currency
          Row(
            children: [
              Icon(
                Icons.repeat,
                size: AppIconSize.small,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                subscription.recurringPeriod,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (subscription.recurringPeriod.toLowerCase() == 'custom') ...[
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '(${subscription.customDays} days)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: Text(
                  subscription.currency,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Entertainment':
        return Icons.movie_outlined;
      case 'Productivity':
        return Icons.work_outline;
      case 'Utilities':
        return Icons.lightbulb_outline;
      case 'Education':
        return Icons.school_outlined;
      case 'Fitness':
        return Icons.fitness_center_outlined;
      case 'Finance':
        return Icons.account_balance_outlined;
      case 'Shopping':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
