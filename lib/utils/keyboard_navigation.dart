import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Keyboard navigation utilities for web and desktop platforms.
///
/// Provides helpers for:
/// - Focus management
/// - Keyboard shortcuts
/// - Tab order navigation
/// - Arrow key navigation
///
/// Usage:
/// ```dart
/// // Wrap your widget with keyboard shortcuts
/// KeyboardNavigationWrapper(
///   shortcuts: {
///     LogicalKeySet(LogicalKeyboardKey.enter): ActivateIntent(),
///   },
///   child: MyWidget(),
/// );
///
/// // Create focusable card
/// FocusableCard(
///   onTap: () => _handleTap(),
///   child: MyCardContent(),
/// );
/// ```
class KeyboardNavigation {
  KeyboardNavigation._();

  /// Check if platform supports keyboard navigation
  static bool get isKeyboardPlatform {
    return _isDesktopOrWeb();
  }

  static bool _isDesktopOrWeb() {
    // Check if running on web or desktop
    try {
      // ignore: undefined_prefixed_name
      return const bool.fromEnvironment('dart.library.html') ||
          const bool.fromEnvironment('dart.library.io');
    } catch (_) {
      return false;
    }
  }

  /// Default keyboard shortcuts for common actions
  static Map<LogicalKeySet, Intent> get defaultShortcuts => {
        // Navigation
        LogicalKeySet(LogicalKeyboardKey.tab): NextFocusIntent(),
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.tab):
            PreviousFocusIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(
          TraversalDirection.down,
        ),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(
          TraversalDirection.up,
        ),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): DirectionalFocusIntent(
          TraversalDirection.left,
        ),
        LogicalKeySet(LogicalKeyboardKey.arrowRight): DirectionalFocusIntent(
          TraversalDirection.right,
        ),

        // Activation
        LogicalKeySet(LogicalKeyboardKey.enter): ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.space): ActivateIntent(),

        // Escape
        LogicalKeySet(LogicalKeyboardKey.escape): DismissIntent(),
      };

  /// Create focus order for grid layout
  static FocusTraversalPolicy gridFocusPolicy() {
    return ReadingOrderTraversalPolicy();
  }

  /// Create custom focus order
  static FocusTraversalPolicy customFocusOrder(
    List<FocusNode> focusNodes,
  ) {
    return OrderedTraversalPolicy();
  }
}

/// Keyboard navigation wrapper with default shortcuts
class KeyboardNavigationWrapper extends StatelessWidget {
  final Widget child;
  final Map<LogicalKeySet, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;

  const KeyboardNavigationWrapper({
    super.key,
    required this.child,
    this.shortcuts,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: shortcuts ?? KeyboardNavigation.defaultShortcuts,
      child: Actions(
        actions: actions ?? {},
        child: child,
      ),
    );
  }
}

/// Focusable card wrapper for keyboard navigation
class FocusableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final FocusNode? focusNode;
  final bool autofocus;

  const FocusableCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<FocusableCard> createState() => _FocusableCardState();
}

class _FocusableCardState extends State<FocusableCard> {
  late FocusNode _focusNode;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _focused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.space) {
            widget.onTap?.call();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        decoration: _focused
            ? BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: widget.child,
      ),
    );
  }
}

/// Focusable button wrapper with visual focus indicator
class FocusableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final bool autofocus;

  const FocusableButton({
    super.key,
    required this.child,
    this.onPressed,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<FocusableButton> createState() => _FocusableButtonState();
}

class _FocusableButtonState extends State<FocusableButton> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.space) {
            widget.onPressed?.call();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: widget.child,
    );
  }
}

/// Grid navigation helper for card grids
class GridNavigationHelper {
  final int columns;
  final List<FocusNode> focusNodes;

  GridNavigationHelper({
    required this.columns,
    required int itemCount,
  }) : focusNodes = List.generate(itemCount, (_) => FocusNode());

  void dispose() {
    for (final node in focusNodes) {
      node.dispose();
    }
  }

  FocusNode getFocusNode(int index) => focusNodes[index];

  void requestFocus(int index) {
    if (index >= 0 && index < focusNodes.length) {
      focusNodes[index].requestFocus();
    }
  }

  int? getIndexAbove(int currentIndex) {
    final newIndex = currentIndex - columns;
    return newIndex >= 0 ? newIndex : null;
  }

  int? getIndexBelow(int currentIndex) {
    final newIndex = currentIndex + columns;
    return newIndex < focusNodes.length ? newIndex : null;
  }

  int? getIndexLeft(int currentIndex) {
    if (currentIndex % columns == 0) return null; // First column
    return currentIndex - 1;
  }

  int? getIndexRight(int currentIndex) {
    if ((currentIndex + 1) % columns == 0) return null; // Last column
    final newIndex = currentIndex + 1;
    return newIndex < focusNodes.length ? newIndex : null;
  }
}

/// Skip link for accessibility - jumps to main content
class SkipLink extends StatelessWidget {
  final Widget child;
  final String label;
  final FocusNode targetFocusNode;

  const SkipLink({
    super.key,
    required this.child,
    this.label = 'Skip to main content',
    required this.targetFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Skip link button (hidden until focused)
        Positioned(
          top: 0,
          left: 0,
          child: _SkipLinkButton(
            label: label,
            onPressed: () => targetFocusNode.requestFocus(),
          ),
        ),
        child,
      ],
    );
  }
}

class _SkipLinkButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _SkipLinkButton({
    required this.label,
    required this.onPressed,
  });

  @override
  State<_SkipLinkButton> createState() => _SkipLinkButtonState();
}

class _SkipLinkButtonState extends State<_SkipLinkButton> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _focused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_focused) {
      return Offstage(
        child: Focus(
          focusNode: _focusNode,
          child: TextButton(
            onPressed: widget.onPressed,
            child: Text(widget.label),
          ),
        ),
      );
    }

    return Focus(
      focusNode: _focusNode,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: widget.onPressed,
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
