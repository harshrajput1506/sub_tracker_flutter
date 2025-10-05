import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sub/core/constants/app_constants.dart';
import 'package:sub/core/constants/constants.dart';
import 'package:sub/core/di/injection.dart';
import 'package:sub/core/widgets/custom_app_bar.dart';
import 'package:sub/core/widgets/custom_button.dart';
import 'package:sub/core/widgets/custom_card.dart';
import 'package:sub/core/widgets/error_display_widget.dart';
import 'package:sub/core/widgets/loading_indicator.dart';
import 'package:sub/data/models/subscription_model.dart';
import 'package:sub/features/subscriptions/bloc/subscription_bloc.dart';
import 'package:sub/features/subscriptions/bloc/subscription_event.dart';
import 'package:sub/features/subscriptions/bloc/subscription_state.dart';

/// Screen displaying detailed subscription information
class SubscriptionDetailScreen extends StatelessWidget {
  final String id;

  const SubscriptionDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<SubscriptionBloc>()..add(LoadSubscriptionByIdEvent(id)),
      child: _SubscriptionDetailContent(id: id),
    );
  }
}

class _SubscriptionDetailContent extends StatelessWidget {
  final String id;

  const _SubscriptionDetailContent({required this.id});

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Subscription'),
        content: const Text(
          'Are you sure you want to delete this subscription? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<SubscriptionBloc>().add(DeleteSubscriptionEvent(id));
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionBloc, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionOperationSuccess &&
            state.operationType == SubscriptionOperationType.delete) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
          // Navigate back to home after delete
          context.go('/');
        } else if (state is SubscriptionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is SubscriptionLoading) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Subscription Details',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: const LoadingIndicator(),
          );
        }

        if (state is SubscriptionError) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Subscription Details',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: ErrorDisplayWidget(
              message: state.message,
              onRetry: () {
                context.read<SubscriptionBloc>().add(
                  LoadSubscriptionByIdEvent(id),
                );
              },
            ),
          );
        }

        if (state is SubscriptionDetailLoaded) {
          return _buildDetailView(context, state.subscription);
        }

        return Scaffold(
          appBar: CustomAppBar(
            title: 'Subscription Details',
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: const Center(child: Text('Subscription not found')),
        );
      },
    );
  }

  Widget _buildDetailView(
    BuildContext context,
    SubscriptionModel subscription,
  ) {
    final theme = Theme.of(context);
    final daysUntilRenewal = subscription.daysUntilRenewal;
    final isRenewingSoon = daysUntilRenewal <= 7;

    return Scaffold(
      appBar: CustomAppBar(
        title: subscription.name,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.goNamed(
                'editSubscription',
                pathParameters: {'id': subscription.id},
              );
            },
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
            tooltip: 'Delete',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Renewal Countdown Card
          CustomCard(
            color: isRenewingSoon
                ? theme.colorScheme.errorContainer
                : theme.colorScheme.primaryContainer,
            child: Column(
              children: [
                Icon(
                  isRenewingSoon
                      ? Icons.warning_amber_rounded
                      : Icons.calendar_today,
                  size: 48,
                  color: isRenewingSoon
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Next Renewal',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  DateFormat('MMMM dd, yyyy').format(subscription.nextRenewal),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isRenewingSoon
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isRenewingSoon
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    daysUntilRenewal == 0
                        ? 'Renewing Today!'
                        : daysUntilRenewal == 1
                        ? 'In 1 Day'
                        : 'In $daysUntilRenewal Days',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Price Information Card
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.attach_money, color: theme.colorScheme.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Price Information',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: AppSpacing.lg),
                _buildInfoRow(
                  context,
                  'Amount',
                  '${Currencies.getSymbol(subscription.currency)}${subscription.price.toStringAsFixed(2)}',
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildInfoRow(context, 'Currency', subscription.currency),
                const SizedBox(height: AppSpacing.sm),
                _buildInfoRow(
                  context,
                  'Billing Cycle',
                  subscription.recurringPeriod,
                ),
                if (subscription.recurringPeriod == RecurringPeriod.custom &&
                    subscription.customDays != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _buildInfoRow(
                    context,
                    'Custom Period',
                    '${subscription.customDays} days',
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Subscription Details Card
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: theme.colorScheme.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Subscription Details',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: AppSpacing.lg),
                _buildInfoRow(
                  context,
                  'Category',
                  subscription.category,
                  icon: _getCategoryIcon(subscription.category),
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildInfoRow(
                  context,
                  'Start Date',
                  DateFormat('MMM dd, yyyy').format(subscription.startDate),
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildInfoRow(
                  context,
                  'Created',
                  DateFormat(
                    'MMM dd, yyyy • hh:mm a',
                  ).format(subscription.createdAt),
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildInfoRow(
                  context,
                  'Last Updated',
                  DateFormat(
                    'MMM dd, yyyy • hh:mm a',
                  ).format(subscription.updatedAt),
                ),
              ],
            ),
          ),

          // Notes Card (if notes exist)
          if (subscription.notes != null && subscription.notes!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.note, color: theme.colorScheme.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Notes',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: AppSpacing.lg),
                  Text(subscription.notes!, style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),

          // Action Buttons
          CustomButton(
            text: 'Edit Subscription',
            icon: Icons.edit,
            onPressed: () {
              context.goNamed(
                'editSubscription',
                pathParameters: {'id': subscription.id},
              );
            },
          ),

          const SizedBox(height: AppSpacing.md),

          CustomButton(
            text: 'Delete Subscription',
            icon: Icons.delete,
            variant: ButtonVariant.outlined,
            onPressed: () => _showDeleteConfirmation(context),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppIconSize.small,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
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
