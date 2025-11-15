import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quitter/design_tokens.dart';
import 'package:quitter/utils.dart';

class QuitCard extends StatelessWidget {
  const QuitCard({
    super.key,
    required this.context,
    required this.title,
    required this.icon,
    required this.gradientColors,
    required this.quitDate,
    required this.onTap,
    required this.onLongPress,
  });

  final BuildContext context;
  final String title;
  final IconData icon;
  final List<Color> gradientColors;
  final String? quitDate;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    int? days;
    if (quitDate != null) days = daysCeil(quitDate!);

    return Hero(
      tag: title,
      child: Card(
        elevation: DesignTokens.elevation0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first
                    .withOpacity(DesignTokens.opacityLight),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
              splashColor:
                  Colors.white.withOpacity(DesignTokens.opacityLight),
              highlightColor:
                  Colors.white.withOpacity(DesignTokens.opacitySubtle),
              child: Container(
                padding: const EdgeInsets.all(DesignTokens.space5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withOpacity(DesignTokens.opacitySemiTransparent),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(DesignTokens.space3),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                      ),
                      child: Icon(
                        icon,
                        color: getContrastingColor(gradientColors.last),
                        size: DesignTokens.iconMD,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.space4),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.space1),
                    if (days != null) ...[
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(text: '$days'),
                            TextSpan(
                              text: days == 1 ? ' day' : ' days',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(DesignTokens.opacityMediumEmphasis),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Tap to start',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(DesignTokens.opacityMediumEmphasis),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],

                    if (quitDate != null) ...[
                      const SizedBox(height: DesignTokens.space4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.space2,
                          vertical: DesignTokens.space1,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(DesignTokens.opacitySubtle),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
                        ),
                        child: Text(
                          DateFormat.yMMMd().format(DateTime.parse(quitDate!)),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
