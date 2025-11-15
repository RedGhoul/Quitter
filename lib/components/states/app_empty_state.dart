import 'package:flutter/material.dart';
import 'package:quitter/design_tokens.dart';
import 'package:quitter/utils/accessibility_utils.dart';

/// Empty state component for displaying when no content is available.
///
/// Provides a consistent empty state experience with:
/// - Icon in colored circle
/// - Title and message
/// - Optional action button
/// - Centered layout
///
/// Usage:
/// ```dart
/// AppEmptyState(
///   icon: Icons.celebration,
///   title: 'Start Your Journey',
///   message: 'Add your first addiction tracker to begin your recovery journey.',
///   actionLabel: 'Add Tracker',
///   onAction: () => _showAddDialog(),
/// )
/// ```
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: title,
      value: message,
      hint: actionLabel != null
          ? 'Use the $actionLabel button to get started'
          : null,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.space8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            // Icon in circle
            Container(
              width: DesignTokens.icon2XL + DesignTokens.space6,
              height: DesignTokens.icon2XL + DesignTokens.space6,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(DesignTokens.opacitySubtle),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: DesignTokens.icon2XL,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: DesignTokens.space6),

            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: DesignTokens.space2),

            // Message
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(DesignTokens.opacityMediumEmphasis),
                  ),
              textAlign: TextAlign.center,
            ),

            // Action button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: DesignTokens.space6),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
              ),
            ],
            ],
          ),
        ),
      ),
    );
  }
}
