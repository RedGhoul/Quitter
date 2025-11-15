import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quitter/components/indicators/achievement_badge.dart';
import 'package:quitter/components/indicators/animated_counter.dart';
import 'package:quitter/components/indicators/progress_ring.dart';
import 'package:quitter/design_tokens.dart';
import 'package:quitter/utils.dart';
import 'package:quitter/utils/accessibility_utils.dart';

class QuitCard extends StatefulWidget {
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
  State<QuitCard> createState() => _QuitCardState();
}

class _QuitCardState extends State<QuitCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: DesignTokens.durationFast,
      vsync: this,
    );

    _elevationAnimation = Tween<double>(
      begin: 0,
      end: 4,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: DesignTokens.curveStandard,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: DesignTokens.curveStandard,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool hovering) {
    setState(() {
      _isHovered = hovering;
    });
    if (hovering) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    int? days;
    if (widget.quitDate != null) days = daysCeil(widget.quitDate!);

    // Build semantic label and value for screen readers
    final String semanticLabel = widget.title;
    final String semanticValue = days != null
        ? '$days ${days == 1 ? 'day' : 'days'} clean'
        : 'Not started';
    final String semanticHint = days != null
        ? 'Double tap to view details and milestones. Long press for options.'
        : 'Double tap to set a quit date and start tracking.';

    // Get achievement description for screen reader
    String achievementDescription = '';
    if (days != null) {
      if (days >= 365) {
        achievementDescription =
            ' Achievement: ${(days / 365).floor()} year${days >= 730 ? 's' : ''} milestone reached!';
      } else if (days >= 90) {
        achievementDescription = ' Achievement: 90 days milestone reached!';
      } else if (days >= 30) {
        achievementDescription = ' Achievement: 30 days milestone reached!';
      } else if (days >= 7) {
        achievementDescription = ' Achievement: 1 week milestone reached!';
      }
    }

    return AccessibilityUtils.buildSemanticCard(
      label: semanticLabel,
      value: semanticValue + achievementDescription,
      hint: semanticHint,
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => _onHoverChanged(true),
        onExit: (_) => _onHoverChanged(false),
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Hero(
                tag: widget.title,
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
              colors: widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors.first
                    .withOpacity(DesignTokens.opacityLight),
                blurRadius: _isHovered ? 16 : 8,
                offset: Offset(0, _elevationAnimation.value + 4),
                spreadRadius: _isHovered ? 2 : 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
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
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon with progress ring
                        ProgressRing(
                          progress: days != null ? ((days % 7) / 7.0) : 0.0,
                          size: DesignTokens.iconXL + DesignTokens.space6,
                          strokeWidth: 3,
                          color: widget.gradientColors.last,
                          child: Container(
                            padding: const EdgeInsets.all(DesignTokens.space3),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: widget.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                            ),
                            child: Icon(
                              widget.icon,
                              color: getContrastingColor(widget.gradientColors.last),
                              size: DesignTokens.iconMD,
                            ),
                          ),
                        ),
                    const SizedBox(height: DesignTokens.space4),
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.space1),
                    if (days != null) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          AnimatedCounter(
                            value: days,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: DesignTokens.space1),
                          Text(
                            days == 1 ? 'day' : 'days',
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

                    if (widget.quitDate != null) ...[
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
                          DateFormat.yMMMd().format(DateTime.parse(widget.quitDate!)),
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
            ],

            // Achievement badges (positioned absolutely)
            if (days != null) ...[
              Positioned(
                top: DesignTokens.space2,
                right: DesignTokens.space2,
                child: Row(
                  children: [
                    if (days >= 365) ...[
                      AchievementBadge(
                        icon: Icons.star,
                        color: Colors.amber,
                        tooltip: '${(days / 365).floor()} Year${days >= 730 ? 's' : ''}!',
                      ),
                      const SizedBox(width: DesignTokens.space1),
                    ],
                    if (days >= 90 && days < 365) ...[
                      AchievementBadge(
                        icon: Icons.workspace_premium,
                        color: Colors.purple,
                        tooltip: '90 Days!',
                      ),
                      const SizedBox(width: DesignTokens.space1),
                    ],
                    if (days >= 30 && days < 90)
                      AchievementBadge(
                        icon: Icons.local_fire_department,
                        color: Colors.orange,
                        tooltip: '30 Days!',
                      ),
                    if (days >= 7 && days < 30)
                      AchievementBadge(
                        icon: Icons.thumb_up,
                        color: Colors.green,
                        tooltip: '1 Week!',
                      ),
                  ],
                ),
              ),
            ],

            // Glassmorphism overlay (subtle)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.02),
                    ],
                  ),
                ),
              ),
            ),
          ],
                  ),
                ),
              ),
            ),
          ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
