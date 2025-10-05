import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sub/core/constants/app_constants.dart';
import 'package:sub/core/constants/constants.dart';
import 'package:sub/core/widgets/custom_button.dart';
import 'package:sub/features/subscriptions/bloc/subscription_bloc.dart';
import 'package:sub/features/subscriptions/bloc/subscription_event.dart';

/// Bottom sheet for filtering subscriptions
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedCategory;
  String? _selectedCurrency;
  int? _selectedUpcomingDays;

  void _applyFilter() {
    if (_selectedCategory != null) {
      context.read<SubscriptionBloc>().add(
        FilterByCategoryEvent(_selectedCategory!),
      );
    } else if (_selectedCurrency != null) {
      context.read<SubscriptionBloc>().add(
        FilterByCurrencyEvent(_selectedCurrency!),
      );
    } else if (_selectedUpcomingDays != null) {
      context.read<SubscriptionBloc>().add(
        LoadUpcomingRenewalsEvent(_selectedUpcomingDays!),
      );
    }
    Navigator.of(context).pop();
  }

  void _clearFilter() {
    setState(() {
      _selectedCategory = null;
      _selectedCurrency = null;
      _selectedUpcomingDays = null;
    });
    context.read<SubscriptionBloc>().add(const LoadSubscriptionsEvent());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.large),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Filter Subscriptions',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Category filter
              Text(
                'By Category',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: SubscriptionCategories.all.map((category) {
                  final isSelected = _selectedCategory == category;
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null;
                        _selectedCurrency = null;
                        _selectedUpcomingDays = null;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Currency filter
              Text(
                'By Currency',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: Currencies.supported.map((currency) {
                  final isSelected = _selectedCurrency == currency;
                  return FilterChip(
                    label: Text(currency),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCurrency = selected ? currency : null;
                        _selectedCategory = null;
                        _selectedUpcomingDays = null;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Upcoming renewals filter
              Text(
                'Upcoming Renewals',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: [7, 14, 30].map((days) {
                  final isSelected = _selectedUpcomingDays == days;
                  return FilterChip(
                    label: Text('Next $days days'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedUpcomingDays = selected ? days : null;
                        _selectedCategory = null;
                        _selectedCurrency = null;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Clear',
                      variant: ButtonVariant.outlined,
                      onPressed: _clearFilter,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: CustomButton(
                      text: 'Apply Filter',
                      onPressed:
                          (_selectedCategory != null ||
                              _selectedCurrency != null ||
                              _selectedUpcomingDays != null)
                          ? _applyFilter
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
