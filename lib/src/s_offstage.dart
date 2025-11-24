import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ticker_free_circular_progress_indicator/ticker_free_circular_progress_indicator.dart';

/// The type of transition animation to apply when showing/hiding content.
enum SOffstageTransition {
  /// Only fade animation (opacity change).
  fade,

  /// Only scale animation (size change).
  scale,

  /// Both fade and scale animations combined.
  fadeAndScale,

  /// Slide animation with fade.
  slide,

  /// Rotation animation with fade.
  rotation,
}

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
class SOffstage extends StatefulWidget {
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

  /// A callback that is triggered whenever the offstage state changes.
  ///
  /// The callback receives a boolean parameter:
  /// - `true` when the widget becomes offstage (hidden with opacity 0)
  /// - `false` when the widget comes back onscreen (visible with opacity 1)
  ///
  /// **Example:**
  /// ```dart
  /// SOffstage(
  ///   isOffstage: isLoading,
  ///   onOffstageStateChanged: (isOffstage) {
  ///     print('Widget is now ${isOffstage ? 'hidden' : 'visible'}');
  ///   },
  ///   child: YourContentWidget(),
  /// )
  /// ```
  final void Function(bool isOffstage)? onOffstageStateChanged;

  /// A callback that is triggered when the fade animation completes.
  ///
  /// The callback receives a boolean parameter indicating the final state:
  /// - `true` when fade-out animation completes (now fully hidden)
  /// - `false` when fade-in animation completes (now fully visible)
  ///
  /// Useful for chaining actions after transitions complete.
  ///
  /// **Example:**
  /// ```dart
  /// SOffstage(
  ///   isOffstage: isLoading,
  ///   onAnimationComplete: (isOffstage) {
  ///     if (!isOffstage) {
  ///       print('Content is now fully visible!');
  ///     }
  ///   },
  ///   child: YourContentWidget(),
  /// )
  /// ```
  final void Function(bool isOffstage)? onAnimationComplete;

  /// The curve to use for the fade-in animation when content becomes visible.
  ///
  /// Defaults to [Curves.easeInOut] for a smooth transition.
  final Curve fadeInCurve;

  /// The curve to use for the fade-out animation when content becomes hidden.
  ///
  /// Defaults to [Curves.easeInOut] for a smooth transition.
  final Curve fadeOutCurve;

  /// The curve to use for the scale animation.
  ///
  /// Defaults to [Curves.fastEaseInToSlowEaseOut] for a natural feeling transition.
  final Curve scaleCurve;

  /// Delay before showing the content when transitioning from offstage to visible.
  ///
  /// Useful for preventing quick flashes when state changes rapidly.
  /// Defaults to [Duration.zero] (no delay).
  ///
  /// **Example:**
  /// ```dart
  /// SOffstage(
  ///   isOffstage: isLoading,
  ///   delayBeforeShow: Duration(milliseconds: 100),
  ///   child: YourContentWidget(),
  /// )
  /// ```
  final Duration delayBeforeShow;

  /// Delay before hiding the content when transitioning from visible to offstage.
  ///
  /// Useful for preventing quick flashes when state changes rapidly.
  /// Defaults to [Duration.zero] (no delay).
  ///
  /// **Example:**
  /// ```dart
  /// SOffstage(
  ///   isOffstage: isLoading,
  ///   delayBeforeHide: Duration(milliseconds: 100),
  ///   child: YourContentWidget(),
  /// )
  /// ```
  final Duration delayBeforeHide;

  /// Only show the loading indicator if the widget remains offstage longer than this duration.
  ///
  /// This prevents flashing the loading indicator for very quick transitions.
  /// Defaults to [Duration.zero] (show immediately).
  ///
  /// **Example:**
  /// ```dart
  /// SOffstage(
  ///   isOffstage: isLoading,
  ///   showLoadingAfter: Duration(milliseconds: 300),
  ///   child: YourContentWidget(),
  /// )
  /// ```
  final Duration showLoadingAfter;

  /// Whether to maintain the child's state when it goes offstage.
  ///
  /// When `true`, the child widget's state will be preserved even when offstage.
  /// When `false` (default), the child widget may lose its state when offstage.
  ///
  /// This uses the [Offstage] widget's behavior with state management.
  final bool maintainState;

  /// Whether to maintain animations in the child when it goes offstage.
  ///
  /// When `true`, animations in the child continue even when offstage.
  /// When `false` (default), animations may be paused or reset.
  final bool maintainAnimation;

  /// The type of transition effect to apply.
  ///
  /// Options:
  /// - [SOffstageTransition.fade]: Only fade animation (default)
  /// - [SOffstageTransition.scale]: Only scale animation
  /// - [SOffstageTransition.fadeAndScale]: Both fade and scale (current behavior)
  /// - [SOffstageTransition.slide]: Slide animation with fade
  /// - [SOffstageTransition.rotation]: Rotation animation with fade
  final SOffstageTransition transition;

  /// The direction for slide transitions when [transition] is [transition.slide].
  ///
  /// Defaults to [AxisDirection.down].
  final AxisDirection slideDirection;

  /// The offset multiplier for slide transitions.
  ///
  /// A value of 1.0 means slide the full widget height/width.
  /// Defaults to 0.3 for a subtle slide effect.
  final double slideOffset;

  /// Creates a [SOffstage] widget.
  ///
  /// The [isOffstage] and [child] parameters are required.
  /// All other parameters are optional with sensible defaults.
  const SOffstage({
    super.key,
    this.fadeDuration = const Duration(milliseconds: 400),
    required this.isOffstage,
    required this.child,
    this.showLoadingIndicator = true,
    this.loadingIndicator,
    this.onOffstageStateChanged,
    this.onAnimationComplete,
    this.fadeInCurve = Curves.easeInOut,
    this.fadeOutCurve = Curves.easeInOut,
    this.scaleCurve = Curves.fastEaseInToSlowEaseOut,
    this.delayBeforeShow = Duration.zero,
    this.delayBeforeHide = Duration.zero,
    this.showLoadingAfter = Duration.zero,
    this.maintainState = false,
    this.maintainAnimation = false,
    this.transition = SOffstageTransition.fadeAndScale,
    this.slideDirection = AxisDirection.down,
    this.slideOffset = 0.3,
  });

  @override
  State<SOffstage> createState() => _SOffstageState();
}

class _SOffstageState extends State<SOffstage>
    with SingleTickerProviderStateMixin {
  bool _actualOffstageState = false;
  bool _showLoading = false;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _actualOffstageState = widget.isOffstage;
    _showLoading =
        widget.isOffstage && widget.showLoadingAfter == Duration.zero;

    // Initialize animation controller for tracking animation completion
    _animationController = AnimationController(
      duration: widget.fadeDuration,
      vsync: this,
    );

    _animationController!.addStatusListener(_onAnimationStatusChanged);

    if (!widget.isOffstage) {
      _animationController!.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController?.removeStatusListener(_onAnimationStatusChanged);
    _animationController?.dispose();
    super.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      widget.onAnimationComplete?.call(_actualOffstageState);
    }
  }

  @override
  void didUpdateWidget(SOffstage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update animation controller duration if it changed
    if (oldWidget.fadeDuration != widget.fadeDuration) {
      _animationController?.duration = widget.fadeDuration;
    }

    // Trigger callback when offstage state changes
    if (oldWidget.isOffstage != widget.isOffstage) {
      widget.onOffstageStateChanged?.call(widget.isOffstage);

      // Handle delays
      final delay =
          widget.isOffstage ? widget.delayBeforeHide : widget.delayBeforeShow;

      if (delay > Duration.zero) {
        Future.delayed(delay, () {
          if (mounted) {
            setState(() {
              _actualOffstageState = widget.isOffstage;
            });
            _updateAnimation();
          }
        });
      } else {
        setState(() {
          _actualOffstageState = widget.isOffstage;
        });
        _updateAnimation();
      }

      // Handle conditional loading indicator
      if (widget.isOffstage && widget.showLoadingAfter > Duration.zero) {
        Future.delayed(widget.showLoadingAfter, () {
          if (mounted && widget.isOffstage) {
            setState(() {
              _showLoading = true;
            });
          }
        });
      } else {
        setState(() {
          _showLoading = widget.isOffstage;
        });
      }
    }
  }

  void _updateAnimation() {
    if (_actualOffstageState) {
      _animationController?.reverse();
    } else {
      _animationController?.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Loading indicator - shown based on showLoadingAfter delay
            if (widget.showLoadingIndicator && _showLoading)
              Center(
                child: widget.loadingIndicator ??
                    TickerFreeCircularProgressIndicator(
                      // Custom styling for better visual hierarchy
                      color: Colors.grey[700]!,
                      backgroundColor: Colors.grey[200],
                    ),
              ),

            // Content container with transition animations
            _buildTransitionWidget(),
          ],
        );
      },
    );
  }

  Widget _buildTransitionWidget() {
    Widget content = Offstage(
      offstage: _actualOffstageState,
      child: widget.child,
    );

    // Apply transitions based on type
    switch (widget.transition) {
      case SOffstageTransition.fade:
        content = AnimatedOpacity(
          curve:
              _actualOffstageState ? widget.fadeOutCurve : widget.fadeInCurve,
          duration: widget.fadeDuration,
          opacity: _actualOffstageState ? 0.0 : 1.0,
          child: content,
        );
        break;

      case SOffstageTransition.scale:
        content = AnimatedScale(
          scale: _actualOffstageState ? 0.97 : 1.0,
          duration: widget.fadeDuration,
          curve: widget.scaleCurve,
          child: content,
        );
        break;

      case SOffstageTransition.fadeAndScale:
        content = AnimatedScale(
          scale: _actualOffstageState ? 0.97 : 1.0,
          duration: widget.fadeDuration,
          curve: widget.scaleCurve,
          child: AnimatedOpacity(
            curve:
                _actualOffstageState ? widget.fadeOutCurve : widget.fadeInCurve,
            duration: widget.fadeDuration,
            opacity: _actualOffstageState ? 0.0 : 1.0,
            child: content,
          ),
        );
        break;

      case SOffstageTransition.slide:
        content = AnimatedSlide(
          offset: _actualOffstageState
              ? _getSlideOffset(widget.slideDirection, widget.slideOffset)
              : Offset.zero,
          duration: widget.fadeDuration,
          curve: widget.scaleCurve,
          child: AnimatedOpacity(
            curve:
                _actualOffstageState ? widget.fadeOutCurve : widget.fadeInCurve,
            duration: widget.fadeDuration,
            opacity: _actualOffstageState ? 0.0 : 1.0,
            child: content,
          ),
        );
        break;

      case SOffstageTransition.rotation:
        content = AnimatedRotation(
          turns: _actualOffstageState ? 0.05 : 0.0,
          duration: widget.fadeDuration,
          curve: widget.scaleCurve,
          child: AnimatedOpacity(
            curve:
                _actualOffstageState ? widget.fadeOutCurve : widget.fadeInCurve,
            duration: widget.fadeDuration,
            opacity: _actualOffstageState ? 0.0 : 1.0,
            child: content,
          ),
        );
        break;
    }

    return content;
  }

  Offset _getSlideOffset(AxisDirection direction, double offset) {
    switch (direction) {
      case AxisDirection.up:
        return Offset(0, offset);
      case AxisDirection.down:
        return Offset(0, -offset);
      case AxisDirection.left:
        return Offset(offset, 0);
      case AxisDirection.right:
        return Offset(-offset, 0);
    }
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
