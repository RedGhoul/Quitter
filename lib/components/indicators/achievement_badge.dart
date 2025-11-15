import 'package:flutter/material.dart';
import 'package:quitter/design_tokens.dart';
import 'package:quitter/utils/accessibility_utils.dart';

/// Small badge that appears on cards to show achievements and milestones.
///
/// Displays an icon in a colored circle with an optional tooltip.
/// Perfect for showing milestone achievements like 7 days, 30 days, 1 year, etc.
///
/// Usage:
/// ```dart
/// AchievementBadge(
///   icon: Icons.local_fire_department,
///   color: Colors.orange,
///   tooltip: '30 Days!',
/// )
/// ```
class AchievementBadge extends StatelessWidget {
  /// Icon to display in the badge
  final IconData icon;

  /// Background color of the badge
  final Color color;

  /// Optional tooltip text shown on long press
  final String? tooltip;

  /// Size of the badge (defaults to 24dp)
  final double size;

  const AchievementBadge({
    super.key,
    required this.icon,
    required this.color,
    this.tooltip,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(DesignTokens.opacityLight),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: size * 0.5,
        color: Colors.white,
      ),
    );

    final badgeWithTooltip = tooltip != null
        ? Tooltip(
            message: tooltip!,
            child: badge,
          )
        : badge;

    // Add semantic label for screen readers
    return Semantics(
      label: tooltip ?? 'Achievement badge',
      readOnly: true,
      child: ExcludeSemantics(child: badgeWithTooltip),
    );
  }
}
