import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ticker_free_circular_progress_indicator/ticker_free_circular_progress_indicator.dart';

/// A custom widget that provides a loading state with smooth fade transitions.
///
/// [SOffstage] displays a circular progress indicator while content is loading
/// and smoothly fades in the actual content when it's ready to be displayed.
/// This widget combines the functionality of [Offstage] with [AnimatedOpacity]
/// to create a polished loading experience.
///
/// **Use Cases:**
/// - Loading screens for data fetching operations
/// - Smooth transitions between loading and content states
/// - Any scenario where you need to show a spinner while content is being prepared
///
/// **Example:**
/// ```dart
/// MyOffstage(
///   isOffstage: isLoading,
///   fadeDuration: Duration(milliseconds: 500),
///   child: YourContentWidget(),
/// )
/// ```
///
/// **Example with custom loading indicator:**
/// ```dart
/// MyOffstage(
///   isOffstage: isLoading,
///   loadingIndicator: CircularProgressIndicator(
///     color: Colors.blue,
///     strokeWidth: 3.0,
///   ),
///   child: YourContentWidget(),
/// )
/// ```
class SOffstage extends StatelessWidget {
  /// The duration of the fade animation when transitioning between loading and content states.
  ///
  /// Defaults to 400 milliseconds for a smooth but responsive transition.
  final Duration fadeDuration;

  /// Controls the visibility and loading state of the widget.
  ///
  /// When `true`:
  /// - Shows the circular progress indicator
  /// - Hides the child widget (opacity 0.0 and offstage)
  ///
  /// When `false`:
  /// - Hides the progress indicator
  /// - Shows the child widget with fade-in animation (opacity 1.0)
  final bool isOffstage;

  /// Controls whether to display the loading indicator during the loading state.
  ///
  /// When `true` (default): Shows the loading indicator when [isOffstage] is true.
  /// When `false`: Hides the loading indicator, showing only the content transition.
  ///
  /// Useful for scenarios where you want smooth content transitions without a spinner.
  final bool showLoadingIndicator;

  /// The content widget to display when loading is complete.
  ///
  /// This widget will be hidden (offstage) and transparent while [isOffstage] is true,
  /// and will fade in smoothly when [isOffstage] becomes false.
  final Widget child;

  /// A custom loading indicator widget to display during the loading state.
  ///
  /// If provided, this widget will be shown instead of the default [CircularProgressIndicator].
  /// Only displayed when both [showLoadingIndicator] is true and [isOffstage] is true.
  ///
  /// **Examples:**
  /// - Custom spinner: `CircularProgressIndicator(color: Colors.blue)`
  /// - Text indicator: `Text('Loading...', style: TextStyle(fontSize: 16))`
  /// - Custom animation: `SpinKitFadingCircle(color: Colors.red)`
  ///
  /// If null (default), uses the built-in styled [CircularProgressIndicator].
  final Widget? loadingIndicator;

  /// Creates a [SOffstage] widget.
  ///
  /// The [isOffstage] and [child] parameters are required.
  /// The [fadeDuration], [showLoadingIndicator], and [loadingIndicator] parameters are optional.
  /// [fadeDuration] defaults to 400 milliseconds.
  /// [showLoadingIndicator] defaults to true.
  /// [loadingIndicator] defaults to null (uses built-in CircularProgressIndicator).
  const SOffstage({
    super.key,
    this.fadeDuration = const Duration(milliseconds: 400),
    required this.isOffstage,
    required this.child,
    this.showLoadingIndicator = true,
    this.loadingIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Loading indicator - always present but only visible when isOffstage is true
            // The AnimatedOpacity on the child will reveal this spinner when content is hidden
            if (showLoadingIndicator && isOffstage)
              Center(
                child: loadingIndicator ??
                    TickerFreeCircularProgressIndicator(
                      // Custom styling for better visual hierarchy
                      color: Colors.grey[700]!,
                      backgroundColor: Colors.grey[200],
                    ),
              ),

            // Content container with smooth fade transition
            // Uses AnimatedOpacity for smooth transitions and Offstage for performance
            AnimatedScale(
              scale: isOffstage ? 0.97 : 1.0,
              duration: fadeDuration,
              curve: Curves.fastEaseInToSlowEaseOut,
              child: AnimatedOpacity(
                curve: Curves.easeInOut,
                duration: fadeDuration,
                // Fade out (transparent) when loading, fade in (opaque) when content ready
                opacity: isOffstage ? 0.0 : 1.0,
                child: Offstage(
                  // Remove from widget tree when loading for better performance
                  // This prevents the child from consuming resources while hidden
                  offstage: isOffstage,
                  child: child,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

//************************************ */

class HiddenContent extends StatefulWidget {
  final bool forceReveal;
  final bool isHidden;
  final Widget child;
  const HiddenContent({
    super.key,
    this.forceReveal = false,
    this.isHidden = false,
    required this.child,
  });

  @override
  State<HiddenContent> createState() => _HiddenContentState();
}

class _HiddenContentState extends State<HiddenContent> {
  bool _isHidden = false;

  @override
  void didUpdateWidget(covariant HiddenContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool shouldSetState = false;

    if (oldWidget.isHidden != widget.isHidden) {
      _isHidden = widget.isHidden;
      shouldSetState = true;
    }

    if (oldWidget.forceReveal != widget.forceReveal ||
        oldWidget.child != widget.child) {
      shouldSetState = true;
    }

    if (shouldSetState) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SOffstage(
          isOffstage: widget.forceReveal && _isHidden
              ? true
              : widget.forceReveal && !_isHidden
                  ? false
                  : widget.isHidden,
          loadingIndicator: Center(
            child: IgnorePointer(
              ignoring: !widget.forceReveal,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isHidden = !_isHidden;
                  });
                },
                child: SizedBox(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Icon(
                        Icons.visibility_off,
                        color: Colors.grey.shade500,
                        size: 20,
                      ),
                      Flexible(
                        child: Text(
                          "Content Hidden",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          child: widget.child,
        ),

        // Reveal button - only shown when content is hidden and forceReveal is true
        if (widget.forceReveal /*  && !_isHidden */)
          Positioned(
            top: 4,
            right: 4,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isHidden = !_isHidden;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    !_isHidden ? Icons.visibility_off : Icons.visibility,
                    color: !_isHidden
                        ? Colors.red.shade900.withValues(alpha: 0.8)
                        : Colors.green.shade600,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
