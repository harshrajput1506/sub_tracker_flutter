import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sub/core/constants/app_constants.dart';
import 'package:sub/core/di/injection.dart';
import 'package:sub/core/widgets/custom_text_field.dart';
import 'package:sub/core/widgets/empty_state_widget.dart';
import 'package:sub/core/widgets/error_display_widget.dart';
import 'package:sub/core/widgets/loading_indicator.dart';
import 'package:sub/features/subscriptions/bloc/subscription_bloc.dart';
import 'package:sub/features/subscriptions/bloc/subscription_event.dart';
import 'package:sub/features/subscriptions/bloc/subscription_state.dart';
import 'package:sub/features/subscriptions/widgets/subscription_card.dart';
import 'package:sub/features/subscriptions/widgets/filter_bottom_sheet.dart';

/// Home screen displaying list of subscriptions
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<SubscriptionBloc>()..add(const LoadSubscriptionsEvent()),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      context.read<SubscriptionBloc>().add(const LoadSubscriptionsEvent());
    } else {
      context.read<SubscriptionBloc>().add(SearchSubscriptionsEvent(query));
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.large),
        ),
      ),
      builder: (context) => BlocProvider.value(
        value: context.read<SubscriptionBloc>(),
        child: const FilterBottomSheet(),
      ),
    );
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
    });
    context.read<SubscriptionBloc>().add(const LoadSubscriptionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? CustomTextField(
                controller: _searchController,
                hint: 'Search subscriptions...',
                onChanged: _onSearchChanged,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                    });
                    _clearFilters();
                  },
                ),
              )
            : const Text('Subscriptions'),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        listener: (context, state) {
          if (state is SubscriptionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<SubscriptionBloc>().add(
                      const LoadSubscriptionsEvent(),
                    );
                  },
                ),
              ),
            );
          } else if (state is SubscriptionOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return const LoadingIndicator();
          }

          if (state is SubscriptionsEmpty) {
            return EmptyStateWidget(
              icon: Icons.subscriptions_outlined,
              title: 'No Subscriptions',
              message: state.message,
              actionLabel: state.isFiltered
                  ? 'Clear Filters'
                  : 'Add First Subscription',
              onAction: state.isFiltered
                  ? _clearFilters
                  : () => context.goNamed('addSubscription'),
            );
          }

          if (state is SubscriptionsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<SubscriptionBloc>().add(
                  const RefreshSubscriptionsEvent(),
                );
              },
              child: Column(
                children: [
                  // Filter chips
                  if (state.isFiltered)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: Row(
                        children: [
                          Chip(
                            label: Text(
                              'Filtered by ${state.filterType ?? ""}',
                            ),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: _clearFilters,
                          ),
                          const Spacer(),
                          Text(
                            '${state.subscriptions.length} results',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),

                  // Subscription list
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: state.subscriptions.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final subscription = state.subscriptions[index];
                        return SubscriptionCard(
                          subscription: subscription,
                          onTap: () {
                            context.goNamed(
                              'subscriptionDetail',
                              pathParameters: {'id': subscription.id},
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is SubscriptionError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () {
                context.read<SubscriptionBloc>().add(
                  const LoadSubscriptionsEvent(),
                );
              },
            );
          }

          return const EmptyStateWidget(
            icon: Icons.subscriptions_outlined,
            title: 'Welcome',
            message: 'Start by adding your first subscription',
            actionLabel: 'Add Subscription',
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed('addSubscription'),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }
}
