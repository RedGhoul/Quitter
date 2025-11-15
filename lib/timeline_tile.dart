import 'package:flutter/material.dart';
import 'package:quitter/design_tokens.dart';
import 'package:quitter/quit_milestone.dart';
import 'package:url_launcher/url_launcher.dart';

class TimelineTile extends StatelessWidget {
  final QuitMilestone milestone;
  final bool isCompleted;
  final bool isNext;
  final bool isLast;
  final List<int> daysAchieved;

  const TimelineTile({
    super.key,
    required this.milestone,
    required this.isCompleted,
    required this.isNext,
    required this.isLast,
    this.daysAchieved = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final achievements = daysAchieved
        .where((days) => days == milestone.day)
        .toList();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: DesignTokens.iconMD,
                  height: DesignTokens.iconMD,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? colorScheme.primary
                        : isNext
                        ? colorScheme.secondary
                        : colorScheme.outline.withOpacity(DesignTokens.opacityLight),
                    border: Border.all(
                      color: isCompleted
                          ? colorScheme.primary
                          : isNext
                          ? colorScheme.secondary
                          : colorScheme.outline,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          size: DesignTokens.iconXS,
                          color: colorScheme.onPrimary,
                        )
                      : isNext
                      ? Icon(
                          Icons.radio_button_unchecked,
                          size: DesignTokens.space3,
                          color: colorScheme.onSecondary,
                        )
                      : null,
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 3,
                      margin: const EdgeInsets.symmetric(
                        vertical: DesignTokens.space2,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? colorScheme.primary
                            : colorScheme.outline
                                .withOpacity(DesignTokens.opacityLight),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: DesignTokens.space4),

          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: DesignTokens.space6),
              padding: const EdgeInsets.all(DesignTokens.space4),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow
                        .withOpacity(DesignTokens.opacitySubtle / 2),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: isNext
                    ? Border.all(color: colorScheme.secondary, width: 2)
                    : Border.all(
                        color: colorScheme.outline
                            .withOpacity(DesignTokens.opacitySubtle),
                      ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.space2,
                          vertical: DesignTokens.space1,
                        ),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? colorScheme.primary
                              : isNext
                              ? colorScheme.secondary
                              : colorScheme.outline
                                  .withOpacity(DesignTokens.opacityLight),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                        ),
                        child: Text(
                          milestone.day >= 365
                              ? '${(milestone.day / 365).toStringAsFixed(0)} Year${milestone.day >= 730 ? 's' : ''}'
                              : 'Day ${milestone.day}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? colorScheme.onPrimary
                                : isNext
                                ? colorScheme.onSecondary
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.space2),
                      if (achievements.isNotEmpty &&
                          achievements.length <= 5) ...[
                        Row(
                          children: daysAchieved
                              .where((days) => days == milestone.day)
                              .map(
                                (days) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                  ),
                                  child: Icon(
                                    Icons.history,
                                    size: DesignTokens.iconXS,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ] else if (achievements.length > 5) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.history,
                              size: DesignTokens.iconXS,
                              color: colorScheme.tertiary,
                            ),
                            const SizedBox(width: DesignTokens.space1 / 2),
                            Text(
                              '${achievements.length}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: DesignTokens.space2),
                  Text(
                    milestone.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isCompleted
                          ? colorScheme.primary
                          : isNext
                          ? colorScheme.secondary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.space2),
                  Text(
                    milestone.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.space3),
                  GestureDetector(
                    onTap: () => launchUrl(Uri.parse(milestone.link)),
                    child: Container(
                      padding: const EdgeInsets.all(DesignTokens.space2),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.science,
                            size: DesignTokens.iconXS,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: DesignTokens.space2 - 2),
                          Expanded(
                            child: Text(
                              milestone.reference,
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
