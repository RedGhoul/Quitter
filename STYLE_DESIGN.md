# Quitter - Style & Design System Guide

**Version:** 1.0
**Last Updated:** 2025-11-14
**App Version:** 1.0.92+94

---

## Purpose

This document serves as the **authoritative style guide** for the Quitter app. It codifies all design patterns, styling conventions, and implementation details that should be followed when creating or modifying UI components. Use this document to ensure consistency across the entire application.

---

## Table of Contents

1. [Design Philosophy](#design-philosophy)
2. [Color System](#color-system)
3. [Typography](#typography)
4. [Spacing & Layout](#spacing--layout)
5. [Components](#components)
6. [Animations](#animations)
7. [Patterns & Best Practices](#patterns--best-practices)
8. [Accessibility Guidelines](#accessibility-guidelines)

---

## Design Philosophy

### Core Principles

**1. Material Design 3**
- The app follows Material Design 3 (Material You) guidelines
- Uses `useMaterial3: true` in ThemeData
- Leverages dynamic color when available
- Implements proper elevation and surface tones

**2. Privacy & Simplicity**
- No unnecessary visual clutter
- Clear, purposeful design elements
- Local-first with no tracking elements
- Clean, focused user experience

**3. Cross-Platform Consistency**
- Same visual language across all platforms (Android, iOS, Web, Desktop)
- Platform-adaptive where appropriate (e.g., Cupertino icons on iOS)
- Responsive layouts for different screen sizes

**4. Accessibility First**
- Sufficient color contrast
- Touch targets minimum 48x48dp
- Support for text scaling
- Screen reader compatibility

---

## Color System

### Theme Architecture

**Location:** `lib/app_theme_mode.dart`, `lib/app_scheme.dart`, `lib/color_scheme_type.dart`

#### Theme Modes

```dart
enum AppThemeMode {
  system,      // Follow system theme
  light,       // Light mode
  dark,        // Dark mode
  pureBlack;   // AMOLED pure black mode
}
```

#### Color Scheme Types

```dart
enum ColorSchemeType {
  dynamic,  // Material You dynamic colors (Android 12+)
  blue,     // Blue seed color
  green,    // Green seed color (#2E8B57 - SeaGreen)
  red,      // Red seed color
  purple,   // Purple seed color
  orange,   // Orange seed color
}
```

### Color Implementation

**Primary Color Seeds:**

```dart
// lib/app_scheme.dart
switch (type) {
  case ColorSchemeType.dynamic:
    // Uses system dynamic colors or falls back to green
    seedColor: const Color(0xFF2E8B57)

  case ColorSchemeType.blue:
    seedColor: Colors.blue

  case ColorSchemeType.green:
    seedColor: const Color(0xFF2E8B57) // SeaGreen

  case ColorSchemeType.red:
    seedColor: Colors.red

  case ColorSchemeType.purple:
    seedColor: Colors.purple

  case ColorSchemeType.orange:
    seedColor: Colors.orange
}
```

**Pure Black Mode Customization:**

```dart
// lib/main.dart lines 114-126
if (settings.themeMode == AppThemeMode.pureBlack) {
  darkColorScheme = darkColorScheme.copyWith(
    surface: Colors.black,
    surfaceContainer: const Color(0xFF0A0A0A),
    surfaceContainerLow: Colors.black,
    surfaceContainerLowest: Colors.black,
    surfaceContainerHigh: const Color(0xFF151515),
    surfaceContainerHighest: const Color(0xFF1A1A1A),
    onSurface: Colors.white,
    outline: const Color(0xFF404040),
    outlineVariant: const Color(0xFF303030),
  );
}
```

### Using Colors in Components

**✅ Correct Usage:**

```dart
// Access from theme
color: Theme.of(context).colorScheme.primary
color: Theme.of(context).colorScheme.onSurface
backgroundColor: Theme.of(context).colorScheme.surface

// Gradient colors for addiction cards
final gradientColors = [Color1, Color2]; // Passed as parameter
gradient: LinearGradient(
  colors: gradientColors,
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
```

**❌ Avoid:**

```dart
// Don't hardcode colors
color: Colors.blue  // Bad - use theme colors
color: Color(0xFF123456)  // Bad - not themeable
```

### Opacity/Alpha Values

**Current Pattern:**
```dart
// Note: Current codebase uses this pattern for opacity
color.withAlpha(255 ~/ (1 / 0.3))  // 30% opacity
color.withAlpha(255 ~/ (1 / 0.1))  // 10% opacity
color.withAlpha(255 ~/ (1 / 0.9))  // 90% opacity

// Recommended alternative (clearer):
color.withOpacity(0.3)  // 30% opacity
color.withOpacity(0.1)  // 10% opacity
color.withOpacity(0.9)  // 90% opacity
```

**Common Opacity Values:**
- **10%** - Subtle background tints
- **30%** - Disabled states, subtle shadows
- **60%** - Secondary text
- **70%** - Tertiary text
- **90%** - Semi-transparent overlays

---

## Typography

### Current Typography Usage

**Location:** Used throughout app, no centralized system yet

**Text Styles in Use:**

```dart
// Display/Headlines (Large numbers, days count)
Theme.of(context).textTheme.headlineSmall?.copyWith(
  fontWeight: FontWeight.bold,
)

// Titles (Card titles, section headers)
Theme.of(context).textTheme.titleMedium?.copyWith(
  fontWeight: FontWeight.w600,
)

// Body (Main content, descriptions)
Theme.of(context).textTheme.bodyLarge
Theme.of(context).textTheme.bodyMedium
Theme.of(context).textTheme.bodySmall

// Labels (Buttons, badges)
style: TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.5,
)
```

### Font Weights in Use

- **w400 (Regular)**: Body text, descriptions
- **w500 (Medium)**: Date labels, subtle emphasis
- **w600 (Semi-Bold)**: Titles, card headers
- **w700 (Bold)**: Headlines
- **w800 (Extra Bold)**: Hero numbers (days count)

### Typography Patterns

**1. Days Counter (Large Display):**
```dart
// lib/quit_card.dart lines 96-113
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
                  .colorScheme.onSurface
                  .withAlpha(255 ~/ (1 / 0.7)),
            ),
      ),
    ],
  ),
)
```

**2. Card Title:**
```dart
// lib/quit_card.dart lines 88-93
Text(
  title,
  style: Theme.of(context).textTheme.titleMedium?.copyWith(
    fontWeight: FontWeight.w600,
  ),
)
```

**3. Body Text:**
```dart
// lib/timeline_tile.dart lines 197-203
Text(
  milestone.description,
  style: TextStyle(
    fontSize: 14,
    height: 1.4,  // Line height
    color: colorScheme.onSurface,
  ),
)
```

**4. Badge/Label Text:**
```dart
// lib/timeline_tile.dart lines 132-145
Text(
  'Day ${milestone.day}',
  style: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: colorScheme.onPrimary,
  ),
)
```

---

## Spacing & Layout

### Spacing Values in Use

**Current Pattern:** Hardcoded values (no centralized system)

**Common Spacing Values:**

```dart
// Padding values observed in codebase
const EdgeInsets.all(24)      // Major section padding
const EdgeInsets.all(20)      // Card internal padding
const EdgeInsets.all(16)      // Standard padding
const EdgeInsets.all(12)      // Compact padding
const EdgeInsets.all(8)       // Tight padding
const EdgeInsets.all(4)       // Minimal padding

// SizedBox spacing
const SizedBox(height: 16)    // Standard vertical spacing
const SizedBox(height: 12)    // Medium vertical spacing
const SizedBox(height: 8)     // Small vertical spacing
const SizedBox(height: 4)     // Tight vertical spacing
const SizedBox(width: 6)      // Small horizontal spacing
```

**Recommended 8pt Grid:**
- 4, 8, 12, 16, 20, 24, 32, 40, 48, 64

### Border Radius

```dart
// Card radius
BorderRadius.circular(20)     // Large cards (QuitCard)
BorderRadius.circular(12)     // Medium cards (TimelineTile)
BorderRadius.circular(8)      // Small badges, chips

// Circle shapes
shape: BoxShape.circle        // Icons, indicators
BorderRadius.circular(999)    // Pill shape (future use)
```

### Elevation & Shadows

```dart
// Card elevation
elevation: 0  // Flat cards (current standard)

// Custom box shadows (QuitCard)
boxShadow: [
  BoxShadow(
    color: gradientColors.first.withAlpha(255 ~/ (1 / 0.3)),
    blurRadius: 8,
    offset: const Offset(0, 4),
  ),
]

// Subtle shadows (TimelineTile)
boxShadow: [
  BoxShadow(
    color: colorScheme.shadow.withAlpha((255 * 0.05).round()),
    blurRadius: 10,
    offset: const Offset(0, 2),
  ),
]
```

---

## Components

### QuitCard

**File:** `lib/quit_card.dart`

**Purpose:** Main addiction tracking card displayed on home page

**Visual Characteristics:**
- Card with gradient background
- Hero animation support
- Icon with gradient background
- Days counter with emphasis
- Quit date badge
- Rounded corners (20dp)
- Colored shadow matching gradient
- Tap and long-press interactions

**Code Pattern:**

```dart
QuitCard(
  context: context,
  title: 'Alcohol',
  icon: Icons.local_bar,
  gradientColors: [Color1, Color2],
  quitDate: '2024-01-01T00:00:00.000',
  onTap: () { /* Navigate to detail */ },
  onLongPress: () { /* Show options */ },
)
```

**Styling Details:**

```dart
// Outer card
Card(
  elevation: 0,
  margin: EdgeInsets.zero,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  clipBehavior: Clip.antiAlias,
)

// Gradient container
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: gradientColors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    boxShadow: [
      BoxShadow(
        color: gradientColors.first.withAlpha(255 ~/ (1 / 0.3)),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  ),
)

// Semi-transparent overlay
Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Theme.of(context)
        .colorScheme.surface
        .withAlpha(255 ~/ (1 / 0.9)),  // 90% opacity
  ),
)

// Icon container
Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: gradientColors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Icon(icon, color: contrastColor, size: 24),
)
```

### TimelineTile

**File:** `lib/timeline_tile.dart`

**Purpose:** Milestone items in timeline view

**Visual Characteristics:**
- Vertical timeline connector
- Circular status indicator (completed/next/upcoming)
- Card with milestone information
- Day badge
- Achievement history icons
- Reference link with icon
- Border highlight for next milestone

**States:**
- **Completed:** Primary color, check icon
- **Next:** Secondary color, radio icon
- **Upcoming:** Outline color, empty

**Code Pattern:**

```dart
TimelineTile(
  milestone: QuitMilestone(...),
  isCompleted: true/false,
  isNext: true/false,
  isLast: true/false,
  daysAchieved: [1, 3, 7, 7, 7],  // History
)
```

**Styling Details:**

```dart
// Timeline indicator
Container(
  width: 24,
  height: 24,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: isCompleted ? colorScheme.primary :
           isNext ? colorScheme.secondary :
           colorScheme.outline.withAlpha((255 * 0.3).round()),
    border: Border.all(
      color: isCompleted ? colorScheme.primary :
             isNext ? colorScheme.secondary :
             colorScheme.outline,
      width: 2,
    ),
  ),
  child: Icon(...),
)

// Timeline connector line
Container(
  width: 3,
  margin: const EdgeInsets.symmetric(vertical: 8),
  decoration: BoxDecoration(
    color: isCompleted ? colorScheme.primary :
           colorScheme.outline.withAlpha((255 * 0.3).round()),
    borderRadius: BorderRadius.circular(2),
  ),
)

// Milestone card
Container(
  margin: const EdgeInsets.only(bottom: 24),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: colorScheme.surface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [ /* subtle shadow */ ],
    border: isNext ?
      Border.all(color: colorScheme.secondary, width: 2) :
      Border.all(color: colorScheme.outline.withAlpha(...)),
  ),
)
```

### Modal Bottom Sheets

**File:** `lib/home_page.dart` lines 80-120

**Pattern:**

```dart
showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  builder: (BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon in circle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme.primary
                  .withAlpha(255 ~/ (1 / 0.1)),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32),
          ),
          // Title, message, buttons...
        ],
      ),
    );
  },
)
```

### Buttons

**Current Patterns:**

```dart
// FilledButton (primary action)
FilledButton(
  onPressed: () {},
  child: Text('Button Text'),
)

// TextButton (secondary action)
TextButton(
  onPressed: () {},
  child: Text('Cancel'),
)

// ElevatedButton
ElevatedButton(
  onPressed: () {},
  child: Text('Action'),
)

// IconButton
IconButton(
  icon: Icon(Icons.icon),
  onPressed: () {},
)
```

### List Tiles

**Settings Pattern:**

```dart
ListTile(
  leading: Icon(Icons.icon),
  title: Text('Setting Name'),
  subtitle: Text('Description'),
  trailing: Switch(
    value: settingValue,
    onChanged: (value) {},
  ),
)
```

---

## Animations

### Hero Animations

**Usage:** Card to detail page transitions

```dart
// In source widget (QuitCard)
Hero(
  tag: title,  // Unique identifier
  child: Card(...),
)

// In destination widget
Hero(
  tag: title,  // Same identifier
  child: Widget(),
)
```

### Confetti Animation

**File:** `lib/confetti_widget.dart`

**Purpose:** Celebration animation when starting quit journey

**Characteristics:**
- 60 confetti pieces
- Random colors (12 color palette)
- Three shapes: rectangle, circle, triangle
- Physics simulation with gravity
- 2500ms duration
- Spawns from bottom-right (85%, 85%)

**Usage:**

```dart
ConfettiWidget(
  active: showConfetti,
  onAnimationComplete: () {
    setState(() => showConfetti = false);
  },
  child: YourWidget(),
)
```

**Colors Used:**
```dart
[
  Colors.red, Colors.blue, Colors.green,
  Colors.yellow, Colors.purple, Colors.orange,
  Colors.pink, Colors.cyan, Colors.lime,
  Colors.indigo, Colors.amber, Colors.teal,
]
```

### InkWell Ripple Effects

**Pattern in QuitCard:**

```dart
InkWell(
  onTap: onTap,
  onLongPress: onLongPress,
  borderRadius: BorderRadius.circular(20),
  splashColor: Colors.white.withAlpha(255 ~/ (1 / 0.3)),
  highlightColor: Colors.white.withAlpha(255 ~/ (1 / 0.1)),
  child: ...,
)
```

### Animation Durations

**Current Usage:**

```dart
// Confetti
duration: const Duration(milliseconds: 2500)

// Confetti cleanup delay
Future.delayed(const Duration(milliseconds: 2500))

// (Recommended for future use)
const Duration(milliseconds: 150)  // Fast
const Duration(milliseconds: 250)  // Normal
const Duration(milliseconds: 350)  // Slow
```

---

## Patterns & Best Practices

### Provider Pattern

**State Access:**

```dart
// Read (when value doesn't change during build)
final settings = context.read<SettingsProvider>();
final addictions = context.read<AddictionProvider>();

// Watch (rebuilds when provider changes)
Consumer<SettingsProvider>(
  builder: (context, settings, child) {
    return Widget();
  },
)

// Or using watch
final settings = context.watch<SettingsProvider>();
```

### Conditional Rendering

```dart
// Using spread operator for conditional widgets
if (condition) ...[
  Widget1(),
  Widget2(),
] else ...[
  Widget3(),
]

// Ternary for single widget
condition ? Widget1() : Widget2()

// Null-aware for optional widgets
if (value != null) Widget()
```

### Date Formatting

```dart
import 'package:intl/intl.dart';

// Display date
DateFormat.yMMMd().format(DateTime.parse(quitDate))
// Output: "Jan 1, 2024"

// Key format for storage
DateFormat('yyyy-MM-dd').format(date)
// Output: "2024-01-01"
```

### Utility Functions

**File:** `lib/utils.dart`

```dart
// Calculate days since quit date (ceiling)
int daysCeil(String quitDate) {
  final now = DateTime.now();
  final quit = DateTime.parse(quitDate);
  return now.difference(quit).inDays + 1;
}

// Get contrasting color for text on background
Color getContrastingColor(Color background) {
  // Returns black or white based on luminance
}

// Show toast/snackbar
void toast(String message, {SnackBarAction? action}) {
  rootScaffoldMessenger.currentState?.showSnackBar(
    SnackBar(content: Text(message), action: action),
  );
}
```

### Navigation

```dart
// Push new page
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => NewPage(),
  ),
)

// Pop current page
Navigator.of(context).pop()

// Pop with result
Navigator.of(context).pop(result)
```

### SharedPreferences Pattern

```dart
// Save
final prefs = await SharedPreferences.getInstance();
await prefs.setString('key', value);
await prefs.setBool('key', true);
await prefs.setInt('key', 42);

// Load
final value = prefs.getString('key');
final boolValue = prefs.getBool('key') ?? false;
final intValue = prefs.getInt('key') ?? 0;

// JSON for complex objects
final json = jsonEncode(object.toJson());
await prefs.setString('key', json);

final jsonString = prefs.getString('key');
final object = MyClass.fromJson(jsonDecode(jsonString));
```

---

## Accessibility Guidelines

### Semantic Labels

```dart
Semantics(
  label: 'Descriptive label',
  button: true,
  child: Widget(),
)
```

### Touch Targets

**Minimum size:** 48x48 logical pixels

```dart
// Icon buttons automatically have minimum touch target
IconButton(
  icon: Icon(Icons.icon),
  onPressed: () {},
)

// For custom widgets, wrap in GestureDetector with padding
GestureDetector(
  onTap: () {},
  child: Container(
    padding: const EdgeInsets.all(12), // Ensures 48x48 minimum
    child: Icon(Icons.icon, size: 24),
  ),
)
```

### Color Contrast

**WCAG AA Requirements:**
- Normal text (< 18pt): 4.5:1 contrast ratio
- Large text (≥ 18pt): 3:1 contrast ratio
- UI components: 3:1 contrast ratio

**Testing:** Use Material Design color system which ensures proper contrast

### Text Scaling

**Support:** App should support text scaling up to 200%

```dart
// Use theme text styles (automatically scale)
Text(
  'Content',
  style: Theme.of(context).textTheme.bodyMedium,
)

// Avoid hardcoded font sizes
Text('Bad', style: TextStyle(fontSize: 14))  // ❌
Text('Good', style: Theme.of(context).textTheme.bodyMedium)  // ✅
```

---

## File Organization

### Current Structure

```
lib/
├── main.dart                  # App entry, providers, theme setup
├── *_provider.dart            # State management
├── *_page.dart                # Full pages
├── quit_card.dart             # Reusable card component
├── timeline_tile.dart         # Timeline component
├── confetti_widget.dart       # Animation component
├── icon_picker.dart           # Picker component
├── app_scheme.dart            # Color scheme logic
├── app_theme_mode.dart        # Theme mode enum
├── color_scheme_type.dart     # Color type enum
├── utils.dart                 # Utility functions
└── cupertino_icons.dart       # Icon mappings
```

### Naming Conventions

- **Pages:** `*_page.dart` (e.g., `home_page.dart`)
- **Providers:** `*_provider.dart` (e.g., `settings_provider.dart`)
- **Components:** Descriptive names (e.g., `quit_card.dart`)
- **Models:** Noun names (e.g., `entry.dart`)
- **Utilities:** `utils.dart`, `tasks.dart`

---

## Code Style

### Const Constructors

**Always use `const` when possible:**

```dart
const Text('Hello')  // ✅
const SizedBox(height: 16)  // ✅
const EdgeInsets.all(8)  // ✅

Text('Hello')  // ❌ (could be const)
```

### Widget Organization

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});  // Named parameters with super

  @override
  Widget build(BuildContext context) {
    return Widget();
  }
}
```

### Formatting

- **Line length:** No strict limit, but reasonable
- **Indentation:** 2 spaces
- **Trailing commas:** Used for better formatting
- **Linting:** Uses `flutter_lints: ^6.0.0`

---

## Quick Reference

### Common Color Accesses

```dart
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.secondary
Theme.of(context).colorScheme.surface
Theme.of(context).colorScheme.onSurface
Theme.of(context).colorScheme.onPrimary
Theme.of(context).colorScheme.outline
```

### Common Text Styles

```dart
Theme.of(context).textTheme.headlineSmall
Theme.of(context).textTheme.titleMedium
Theme.of(context).textTheme.bodyLarge
Theme.of(context).textTheme.bodyMedium
Theme.of(context).textTheme.bodySmall
```

### Common Spacing

```dart
const EdgeInsets.all(16)
const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
const SizedBox(height: 16)
```

### Common Border Radius

```dart
BorderRadius.circular(20)  // Large cards
BorderRadius.circular(12)  // Medium cards/icons
BorderRadius.circular(8)   // Small badges
```

---

## Summary

This style guide documents the current design system of Quitter v1.0.92. When creating new components or modifying existing ones:

1. **Use theme colors** - Never hardcode colors
2. **Follow Material Design 3** - Use proper elevation, surfaces, and color roles
3. **Maintain consistency** - Reuse existing patterns and components
4. **Consider accessibility** - Proper contrast, touch targets, semantic labels
5. **Optimize performance** - Use const constructors, avoid unnecessary rebuilds
6. **Stay simple** - Don't over-design, focus on user needs

For implementing improvements to this design system, see **DESIGN_IMPROVEMENT_PLAN.md**.

For practical implementation guidance, see **DESIGN_IMPLEMENTATION.md**.

---

**Document Version:** 1.0
**Maintainer:** Development Team
**Next Review:** After major design updates
