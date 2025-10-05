import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sub/core/constants/app_constants.dart';
import 'package:sub/core/constants/constants.dart';
import 'package:sub/core/di/injection.dart';
import 'package:sub/core/utils/validators.dart';
import 'package:sub/core/widgets/custom_app_bar.dart';
import 'package:sub/core/widgets/custom_button.dart';
import 'package:sub/core/widgets/custom_dropdown.dart';
import 'package:sub/core/widgets/custom_text_field.dart';
import 'package:sub/features/subscriptions/bloc/subscription_bloc.dart';
import 'package:sub/features/subscriptions/bloc/subscription_event.dart';
import 'package:sub/features/subscriptions/bloc/subscription_state.dart';

/// Screen for adding a new subscription
class AddSubscriptionScreen extends StatelessWidget {
  const AddSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SubscriptionBloc>(),
      child: const _AddSubscriptionContent(),
    );
  }
}

class _AddSubscriptionContent extends StatefulWidget {
  const _AddSubscriptionContent();

  @override
  State<_AddSubscriptionContent> createState() =>
      _AddSubscriptionContentState();
}

class _AddSubscriptionContentState extends State<_AddSubscriptionContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  final _customDaysController = TextEditingController();

  String _selectedCurrency = Currencies.usd;
  String _selectedCategory = SubscriptionCategories.entertainment;
  String _selectedRecurringPeriod = RecurringPeriod.monthly;
  DateTime _startDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    _customDaysController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: Theme.of(context).colorScheme),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate custom days if custom period is selected
    if (_selectedRecurringPeriod == RecurringPeriod.custom) {
      if (_customDaysController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please enter custom days'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
    }

    final price = double.tryParse(_priceController.text) ?? 0.0;
    final customDays = _selectedRecurringPeriod == RecurringPeriod.custom
        ? int.tryParse(_customDaysController.text)
        : null;

    // Add subscription via BLoC
    context.read<SubscriptionBloc>().add(
      AddSubscriptionEvent(
        name: _nameController.text.trim(),
        price: price,
        currency: _selectedCurrency,
        category: _selectedCategory,
        startDate: _startDate,
        recurringPeriod: _selectedRecurringPeriod,
        customDays: customDays,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionBloc, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionLoading) {
          setState(() {
            _isLoading = true;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }

        if (state is SubscriptionOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
          // Navigate back to home
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
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Add Subscription',
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              // Name field
              CustomTextField(
                controller: _nameController,
                label: 'Subscription Name',
                hint: 'e.g., Netflix, Spotify',
                prefixIcon: const Icon(Icons.subscriptions),
                validator: (value) =>
                    Validators.required(value, fieldName: 'Name'),
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Price and Currency row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: _priceController,
                      label: 'Price',
                      hint: '0.00',
                      prefixIcon: Icon(Icons.attach_money),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Price is required';
                        }
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'Enter valid price';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: CustomDropdown(
                      label: 'Currency',
                      value: _selectedCurrency,
                      items: Currencies.supported,
                      itemLabel: (value) => value,
                      onChanged: (value) {
                        setState(() {
                          _selectedCurrency = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Category dropdown
              CustomDropdown(
                label: 'Category',
                value: _selectedCategory,
                items: SubscriptionCategories.all,
                itemLabel: (value) => value,
                prefixIcon: const Icon(Icons.category),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Start date picker
              CustomTextField(
                label: 'Start Date',
                hint: DateFormat('MMM dd, yyyy').format(_startDate),
                readOnly: true,
                prefixIcon: const Icon(Icons.calendar_today),
                suffixIcon: const Icon(Icons.arrow_drop_down),
                onTap: () => _selectDate(context),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Recurring period dropdown
              CustomDropdown(
                label: 'Recurring Period',
                value: _selectedRecurringPeriod,
                items: RecurringPeriod.all,
                itemLabel: (value) => value,
                prefixIcon: const Icon(Icons.repeat),
                onChanged: (value) {
                  setState(() {
                    _selectedRecurringPeriod = value!;
                    if (value != RecurringPeriod.custom) {
                      _customDaysController.clear();
                    }
                  });
                },
              ),

              // Custom days field (only show if custom period selected)
              if (_selectedRecurringPeriod == RecurringPeriod.custom) ...[
                const SizedBox(height: AppSpacing.lg),
                CustomTextField(
                  controller: _customDaysController,
                  label: 'Custom Days',
                  hint: 'e.g., 15, 45, 90',
                  prefixIcon: const Icon(Icons.timer),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (_selectedRecurringPeriod == RecurringPeriod.custom) {
                      if (value == null || value.isEmpty) {
                        return 'Custom days required';
                      }
                      final days = int.tryParse(value);
                      if (days == null || days <= 0) {
                        return 'Enter valid number of days';
                      }
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ],

              const SizedBox(height: AppSpacing.lg),

              // Notes field
              CustomTextField(
                controller: _notesController,
                label: 'Notes (Optional)',
                hint: 'Add any additional notes...',
                prefixIcon: const Icon(Icons.note),
                maxLines: 3,
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Submit button
              CustomButton(
                text: 'Add Subscription',
                onPressed: _isLoading ? null : _submitForm,
                isLoading: _isLoading,
              ),

              const SizedBox(height: AppSpacing.md),

              // Cancel button
              CustomButton(
                text: 'Cancel',
                variant: ButtonVariant.outlined,
                onPressed: _isLoading ? null : () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
