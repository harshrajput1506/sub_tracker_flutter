import 'package:flutter/material.dart';
import 'package:sub/core/constants/app_constants.dart';

/// Custom chip widget for categories/tags
class CustomChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final IconData? icon;

  const CustomChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.onDelete,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (onDelete != null) {
      return Chip(
        label: Text(label),
        labelStyle: TextStyle(
          color: textColor ?? theme.colorScheme.onSecondaryContainer,
        ),
        backgroundColor:
            backgroundColor ?? theme.colorScheme.secondaryContainer,
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: onDelete,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
      );
    }

    if (onTap != null) {
      return ActionChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: AppSpacing.xxs),
            ],
            Text(label),
          ],
        ),
        labelStyle: TextStyle(
          color: textColor ?? theme.colorScheme.onSecondaryContainer,
        ),
        backgroundColor:
            backgroundColor ?? theme.colorScheme.secondaryContainer,
        onPressed: onTap,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
      );
    }

    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: AppSpacing.xxs),
          ],
          Text(label),
        ],
      ),
      labelStyle: TextStyle(
        color: textColor ?? theme.colorScheme.onSecondaryContainer,
      ),
      backgroundColor: backgroundColor ?? theme.colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
    );
  }
}
