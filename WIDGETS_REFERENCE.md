# 🎨 Shared Widgets Reference

Quick reference guide for all shared widgets in `lib/core/widgets/`.

---

## Form Widgets

### CustomTextField

Text input field with validation and consistent styling.

```dart
CustomTextField(
  label: 'Subscription Name',
  hint: 'Enter name',
  controller: nameController,
  validator: (value) => Validators.required(value, fieldName: 'Name'),
  prefixIcon: Icon(Icons.label),
  keyboardType: TextInputType.text,
  onChanged: (value) => print(value),
)
```

**Props:**
- `label` - Field label
- `hint` - Placeholder text
- `controller` - TextEditingController
- `validator` - Validation function
- `prefixIcon` / `suffixIcon` - Icon widgets
- `obscureText` - For password fields
- `maxLines` - Number of lines
- `enabled` - Enable/disable field
- `readOnly` - Make field read-only
- `onTap` - Tap handler (useful for pickers)

---

### CustomDropdown<T>

Dropdown selector with generic type support.

```dart
CustomDropdown<String>(
  label: 'Category',
  value: selectedCategory,
  items: SubscriptionCategories.all,
  itemLabel: (item) => item,
  onChanged: (value) => setState(() => selectedCategory = value),
  validator: (value) => Validators.required(value?.toString()),
  prefixIcon: Icon(Icons.category),
)
```

**Props:**
- `label` - Dropdown label
- `value` - Currently selected value
- `items` - List of items
- `itemLabel` - Function to get item label
- `onChanged` - Selection change handler
- `validator` - Validation function
- `prefixIcon` - Icon widget

---

## Display Widgets

### CustomCard

Container with elevation and consistent padding.

```dart
CustomCard(
  padding: EdgeInsets.all(AppSpacing.md),
  margin: EdgeInsets.all(AppSpacing.xs),
  elevation: AppElevation.small,
  borderRadius: AppRadius.medium,
  onTap: () => print('Card tapped'),
  child: Text('Card content'),
)
```

**Props:**
- `child` - Widget inside card (required)
- `padding` - Internal padding
- `margin` - External margin
- `color` - Background color
- `elevation` - Shadow depth
- `onTap` - Tap handler
- `borderRadius` - Corner radius

---

### CustomChip

Chip widget for categories, tags, or filters.

```dart
// Regular chip
CustomChip(
  label: 'Entertainment',
  icon: Icons.movie,
  backgroundColor: Colors.blue.shade100,
  textColor: Colors.blue.shade900,
)

// Action chip
CustomChip(
  label: 'Filter',
  icon: Icons.filter_list,
  onTap: () => showFilterDialog(),
)

// Deletable chip
CustomChip(
  label: 'Selected',
  onDelete: () => removeFilter(),
)
```

**Props:**
- `label` - Chip text (required)
- `icon` - Leading icon
- `backgroundColor` - Background color
- `textColor` - Text color
- `onTap` - Tap handler (makes it ActionChip)
- `onDelete` - Delete handler (makes it deletable)

---

### StatCard

Card for displaying statistics with icon.

```dart
StatCard(
  title: 'Monthly Spending',
  value: '\$125.50',
  subtitle: '+12% from last month',
  icon: Icons.trending_up,
  iconColor: Colors.green,
  onTap: () => navigateToDetails(),
)
```

**Props:**
- `title` - Stat title (required)
- `value` - Stat value (required)
- `icon` - Icon (required)
- `iconColor` - Icon color
- `subtitle` - Additional info
- `onTap` - Tap handler

---

## Button Widgets

### CustomButton

Button with multiple variants and loading state.

```dart
// Primary button
CustomButton(
  text: 'Save',
  onPressed: () => save(),
  icon: Icons.save,
  width: double.infinity,
)

// Secondary button
CustomButton(
  text: 'Cancel',
  variant: ButtonVariant.secondary,
  onPressed: () => Navigator.pop(context),
)

// Outlined button
CustomButton(
  text: 'Delete',
  variant: ButtonVariant.outlined,
  onPressed: () => delete(),
)

// Loading button
CustomButton(
  text: 'Saving...',
  isLoading: true,
)
```

**Variants:**
- `ButtonVariant.primary` - Filled primary button
- `ButtonVariant.secondary` - Filled secondary button
- `ButtonVariant.outlined` - Outlined button
- `ButtonVariant.text` - Text button

**Props:**
- `text` - Button text (required)
- `onPressed` - Tap handler
- `isLoading` - Show loading spinner
- `variant` - Button style
- `icon` - Leading icon
- `width` / `height` - Button dimensions

---

## State Widgets

### LoadingIndicator

Consistent loading spinner.

```dart
LoadingIndicator(
  message: 'Loading subscriptions...',
  size: 48,
)
```

**Props:**
- `message` - Optional loading message
- `size` - Spinner size

---

### EmptyStateWidget

Empty state with action button.

```dart
EmptyStateWidget(
  icon: Icons.subscriptions,
  title: 'No Subscriptions',
  message: 'Add your first subscription to get started',
  actionLabel: 'Add Subscription',
  onAction: () => navigateToAddScreen(),
)
```

**Props:**
- `icon` - Large icon (required)
- `title` - Empty state title (required)
- `message` - Description message
- `actionLabel` - Action button text
- `onAction` - Action button handler

---

### ErrorDisplayWidget

Error state with retry button.

```dart
ErrorDisplayWidget(
  message: 'Failed to load subscriptions',
  onRetry: () => retry(),
)
```

**Props:**
- `message` - Error message (required)
- `onRetry` - Retry button handler

---

## Navigation Widgets

### CustomAppBar

Consistent app bar with actions.

```dart
CustomAppBar(
  title: 'Subscriptions',
  centerTitle: true,
  actions: [
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () => showSearch(),
    ),
    IconButton(
      icon: Icon(Icons.filter_list),
      onPressed: () => showFilter(),
    ),
  ],
)
```

**Props:**
- `title` - App bar title (required)
- `actions` - Action widgets
- `leading` - Leading widget (overrides back button)
- `centerTitle` - Center the title

---

## Usage Examples

### Form Screen

```dart
Form(
  key: formKey,
  child: Column(
    children: [
      CustomTextField(
        label: 'Name',
        controller: nameController,
        validator: Validators.required,
      ),
      SizedBox(height: AppSpacing.md),
      CustomDropdown<String>(
        label: 'Category',
        value: category,
        items: categories,
        itemLabel: (item) => item,
        onChanged: (value) => setState(() => category = value),
      ),
      SizedBox(height: AppSpacing.xl),
      CustomButton(
        text: 'Save',
        onPressed: () => save(),
        width: double.infinity,
      ),
    ],
  ),
)
```

### List Screen with States

```dart
BlocBuilder<SubscriptionBloc, SubscriptionState>(
  builder: (context, state) {
    if (state is SubscriptionLoading) {
      return LoadingIndicator(message: 'Loading...');
    }
    
    if (state is SubscriptionError) {
      return ErrorDisplayWidget(
        message: state.message,
        onRetry: () => context.read<SubscriptionBloc>().add(LoadSubscriptions()),
      );
    }
    
    if (state is SubscriptionLoaded) {
      if (state.subscriptions.isEmpty) {
        return EmptyStateWidget(
          icon: Icons.subscriptions,
          title: 'No Subscriptions',
          actionLabel: 'Add Subscription',
          onAction: () => context.goNamed('addSubscription'),
        );
      }
      
      return ListView.builder(
        itemCount: state.subscriptions.length,
        itemBuilder: (context, index) {
          final sub = state.subscriptions[index];
          return CustomCard(
            onTap: () => showDetails(sub),
            child: ListTile(
              title: Text(sub.name),
              subtitle: Text(sub.category),
              trailing: Text('\$${sub.price}'),
            ),
          );
        },
      );
    }
    
    return SizedBox.shrink();
  },
)
```

---

## Constants Reference

### Spacing
```dart
AppSpacing.xxs   // 4px
AppSpacing.xs    // 8px
AppSpacing.sm    // 12px
AppSpacing.md    // 16px
AppSpacing.lg    // 24px
AppSpacing.xl    // 32px
AppSpacing.xxl   // 48px
```

### Border Radius
```dart
AppRadius.small   // 8px
AppRadius.medium  // 12px
AppRadius.large   // 16px
AppRadius.xLarge  // 24px
```

### Elevation
```dart
AppElevation.none     // 0
AppElevation.small    // 2
AppElevation.medium   // 4
AppElevation.large    // 8
AppElevation.xLarge   // 16
```

### Icon Sizes
```dart
AppIconSize.small   // 16px
AppIconSize.medium  // 24px
AppIconSize.large   // 32px
AppIconSize.xLarge  // 48px
```

---

## Utilities

### Validators
```dart
Validators.required(value, fieldName: 'Name')
Validators.email(value)
Validators.numeric(value)
Validators.positiveNumber(value)
Validators.minLength(value, 3)
Validators.maxLength(value, 50)
Validators.combine([validator1, validator2])
```

### Formatters
```dart
DateFormatter.format(date)              // 05 Oct 2025
DateFormatter.formatSlash(date)         // 05/10/2025
DateFormatter.formatLong(date)          // Oct 05, 2025
DateFormatter.formatRelative(date)      // 2 days ago

CurrencyFormatter.format(125.50, 'USD')           // $125.50
CurrencyFormatter.formatWithCode(125.50, 'USD')   // 125.50 USD
CurrencyFormatter.formatCompact(1500)             // 1.5K
```

### Snackbar
```dart
SnackBarUtils.showSuccess(context, 'Subscription added')
SnackBarUtils.showError(context, 'Failed to delete')
SnackBarUtils.showInfo(context, 'Rate limit reached')
SnackBarUtils.showWarning(context, 'Renewal tomorrow')
```

---

**Note:** All widgets follow Material 3 design guidelines and automatically adapt to light/dark themes.
