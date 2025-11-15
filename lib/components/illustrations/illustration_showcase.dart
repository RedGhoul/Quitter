import 'package:flutter/material.dart';
import 'package:quitter/components/illustrations/empty_state_illustration.dart';
import 'package:quitter/components/illustrations/error_state_illustration.dart';
import 'package:quitter/components/illustrations/success_illustration.dart';
import 'package:quitter/components/illustrations/onboarding_illustration.dart';
import 'package:quitter/design_tokens.dart';

/// Showcase page demonstrating all custom illustrations.
///
/// This page serves as:
/// 1. Documentation for available illustrations
/// 2. Visual reference for designers and developers
/// 3. Testing ground for illustration animations
///
/// Use this as a reference when deciding which illustration to use
/// in your UI.
class IllustrationShowcase extends StatelessWidget {
  const IllustrationShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Illustration Showcase'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(DesignTokens.space4),
        children: [
          // Empty States
          _buildSection(
            context,
            title: 'Empty State Illustrations',
            description:
                'Use when there is no content to display. Animated version shows floating elements.',
            children: [
              _buildShowcaseCard(
                context,
                title: 'Animated Empty State',
                illustration: const EmptyStateIllustration(size: 200),
              ),
              _buildShowcaseCard(
                context,
                title: 'Static Empty State',
                illustration: const EmptyStateIllustration(
                  size: 200,
                  animated: false,
                ),
              ),
              _buildShowcaseCard(
                context,
                title: 'Simple Empty State',
                illustration: const SimpleEmptyIllustration(size: 120),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.space8),

          // Error States
          _buildSection(
            context,
            title: 'Error State Illustrations',
            description:
                'Use for error messages and failure states. Multiple types available.',
            children: [
              _buildShowcaseCard(
                context,
                title: 'Warning (Animated)',
                illustration: const ErrorStateIllustration(
                  size: 200,
                  type: ErrorIllustrationType.warning,
                ),
              ),
              _buildShowcaseCard(
                context,
                title: 'Error (Animated)',
                illustration: const ErrorStateIllustration(
                  size: 200,
                  type: ErrorIllustrationType.error,
                ),
              ),
              _buildShowcaseCard(
                context,
                title: 'Offline (Animated)',
                illustration: const ErrorStateIllustration(
                  size: 200,
                  type: ErrorIllustrationType.offline,
                ),
              ),
              _buildShowcaseCard(
                context,
                title: 'Simple Error',
                illustration: const SimpleErrorIllustration(size: 80),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.space8),

          // Success States
          _buildSection(
            context,
            title: 'Success Illustrations',
            description:
                'Use for celebrations, achievements, and success confirmations.',
            children: [
              _buildShowcaseCard(
                context,
                title: 'Checkmark Success',
                illustration: const SuccessIllustration(
                  size: 200,
                  type: SuccessIllustrationType.checkmark,
                ),
              ),
              _buildShowcaseCard(
                context,
                title: 'Trophy Success',
                illustration: const SuccessIllustration(
                  size: 200,
                  type: SuccessIllustrationType.trophy,
                ),
              ),
              _buildShowcaseCard(
                context,
                title: 'Achievement Burst',
                illustration: const SuccessIllustration(
                  size: 200,
                  type: SuccessIllustrationType.achievement,
                ),
              ),
              _buildShowcaseCard(
                context,
                title: 'Simple Success',
                illustration: const SimpleSuccessIllustration(size: 60),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.space8),

          // Onboarding Illustrations
          _buildSection(
            context,
            title: 'Onboarding Illustrations',
            description:
                'Use for app introduction, tutorials, and feature highlights.',
            children: [
              _buildShowcaseCard(
                context,
                title: 'Tracking Progress',
                illustration: const OnboardingIllustration(
                  size: 250,
                  type: OnboardingIllustrationType.tracking,
                ),
              ),
              _buildShowcaseCard(
                context,
                title: 'Privacy & Security',
                illustration: const OnboardingIllustration(
                  size: 250,
                  type: OnboardingIllustrationType.privacy,
                ),
              ),
              _buildShowcaseCard(
                context,
                title: 'Recovery Journey',
                illustration: const OnboardingIllustration(
                  size: 250,
                  type: OnboardingIllustrationType.journey,
                ),
              ),
              _buildShowcaseCard(
                context,
                title: 'Community Support',
                illustration: const OnboardingIllustration(
                  size: 250,
                  type: OnboardingIllustrationType.community,
                ),
              ),
              _buildShowcaseCard(
                context,
                title: 'Milestones & Achievements',
                illustration: const OnboardingIllustration(
                  size: 250,
                  type: OnboardingIllustrationType.milestones,
                ),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.space8),

          // Usage Examples
          _buildSection(
            context,
            title: 'Usage Examples',
            description: 'Code examples for implementing illustrations',
            children: [
              _buildCodeExample(
                context,
                title: 'Basic Empty State',
                code: '''
EmptyStateIllustration(
  size: 200,
  color: Theme.of(context).colorScheme.primary,
  animated: true,
)''',
              ),
              _buildCodeExample(
                context,
                title: 'Error with Custom Color',
                code: '''
ErrorStateIllustration(
  size: 200,
  type: ErrorIllustrationType.warning,
  color: Colors.orange,
  animated: true,
)''',
              ),
              _buildCodeExample(
                context,
                title: 'Success Static',
                code: '''
SuccessIllustration(
  size: 200,
  type: SuccessIllustrationType.achievement,
  animated: false,
)''',
              ),
              _buildCodeExample(
                context,
                title: 'Onboarding',
                code: '''
OnboardingIllustration(
  size: 300,
  type: OnboardingIllustrationType.journey,
  color: Theme.of(context).colorScheme.primary,
)''',
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.space8),

          // Design Guidelines
          _buildSection(
            context,
            title: 'Design Guidelines',
            description: 'Best practices for using illustrations',
            children: [
              _buildGuidelineCard(
                context,
                title: 'Size',
                content:
                    'Empty states: 200-300dp\nInline errors: 80-120dp\nOnboarding: 250-350dp',
                icon: Icons.photo_size_select_large,
              ),
              _buildGuidelineCard(
                context,
                title: 'Color',
                content:
                    'Use theme colors for consistency\nError states: colorScheme.error\nSuccess: primary or tertiary\nNeutral: onSurface',
                icon: Icons.palette,
              ),
              _buildGuidelineCard(
                context,
                title: 'Animation',
                content:
                    'Enable for full-page states\nDisable for inline or repeated elements\nRespect reduced motion preferences',
                icon: Icons.animation,
              ),
              _buildGuidelineCard(
                context,
                title: 'Context',
                content:
                    'Empty states: Center of screen with message\nErrors: Below error text\nSuccess: Modal or full-page celebration',
                icon: Icons.location_on,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: DesignTokens.space2),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(DesignTokens.opacityMediumEmphasis),
              ),
        ),
        const SizedBox(height: DesignTokens.space4),
        Wrap(
          spacing: DesignTokens.space4,
          runSpacing: DesignTokens.space4,
          children: children,
        ),
      ],
    );
  }

  Widget _buildShowcaseCard(
    BuildContext context, {
    required String title,
    required Widget illustration,
  }) {
    return Card(
      elevation: 2,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(DesignTokens.space4),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.space4),
            illustration,
            const SizedBox(height: DesignTokens.space2),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeExample(
    BuildContext context, {
    required String title,
    required String code,
  }) {
    return Card(
      elevation: 1,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(DesignTokens.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: DesignTokens.space2),
            Container(
              padding: const EdgeInsets.all(DesignTokens.space3),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius:
                    BorderRadius.circular(DesignTokens.radiusSM),
              ),
              child: SelectableText(
                code,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineCard(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.space4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: DesignTokens.iconLG,
            ),
            const SizedBox(width: DesignTokens.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: DesignTokens.space1),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
