// This example app shows how to use the s_offstage package.
import 'package:flutter/material.dart';
import 'package:s_offstage/s_offstage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOffstage Example',
      home: const ExampleHome(),
    );
  }
}

class ExampleHome extends StatefulWidget {
  const ExampleHome({super.key});

  @override
  State<ExampleHome> createState() => _ExampleHomeState();
}

class _ExampleHomeState extends State<ExampleHome> {
  bool _loading = true;
  String _statusMessage = 'Content is loading...';
  SOffstageTransition _transition = SOffstageTransition.fadeAndScale;
  String _animationStatus = '';
  bool _showLoadingIndicator = true;
  bool _useCustomLoadingIndicator = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  void _handleOffstageStateChange(bool isOffstage) {
    // Avoid calling setState synchronously during the build phase; schedule it
    // to run after this frame to prevent "setState() called during build" errors.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _statusMessage =
            isOffstage ? 'Content is hidden (offstage)' : 'Content is visible!';
      });
    });
    debugPrint('Offstage state changed: $isOffstage');
  }

  void _handleAnimationComplete(bool isOffstage) {
    // Schedule UI updates after frame to avoid setState during build errors.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _animationStatus = isOffstage
            ? 'Animation complete: Fully hidden'
            : 'Animation complete: Fully visible';
      });
    });
    debugPrint('Animation completed: $isOffstage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOffstage Example'),
        elevation: 0,
        backgroundColor: Colors.grey[50],
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Main Demo Area
          Expanded(
            child: Center(
              child: SOffstage(
                isOffstage: _loading,
                transition: _transition,
                showLoadingIndicator: _showLoadingIndicator,
                loadingIndicator: _useCustomLoadingIndicator
                    ? _buildCustomLoadingIndicator()
                    : null,
                onOffstageStateChanged: _handleOffstageStateChange,
                onAnimationComplete: _handleAnimationComplete,
                fadeInCurve: Curves.easeOut,
                fadeOutCurve: Curves.easeIn,
                delayBeforeShow: const Duration(milliseconds: 100),
                showLoadingAfter: const Duration(milliseconds: 200),
                slideDirection: AxisDirection.up,
                slideOffset: 0.5,
                child: Container(
                  width: 300, // Fixed width for the content card
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 48,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Content Loaded!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Transition: ${_getTransitionName(_transition)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Controls Area
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Text
                SizedBox(
                  height: 50,
                  child: Column(
                    children: [
                      Text(
                        _statusMessage,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _loading ? Colors.orange : Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_animationStatus.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          _animationStatus,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Transition Selector
                const Text(
                  'Transition Type',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: SOffstageTransition.values.map((type) {
                      final isSelected = _transition == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(_getTransitionName(type)),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _transition = type;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Toggles Row
                Row(
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          _buildCompactSwitch(
                            'Show Indicator',
                            _showLoadingIndicator,
                            (v) => setState(() => _showLoadingIndicator = v),
                          ),
                          _buildCompactSwitch(
                            'Custom Indicator',
                            _useCustomLoadingIndicator,
                            (v) =>
                                setState(() => _useCustomLoadingIndicator = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Main Action Button
                    SizedBox(
                      width: 100,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          setState(() {
                            _loading = !_loading;
                            _animationStatus = '';
                          });
                        },
                        backgroundColor:
                            _loading ? Colors.green : Colors.orange,
                        icon: Icon(
                            _loading ? Icons.visibility : Icons.visibility_off),
                        label: Text(_loading ? 'Show' : 'Hide'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSwitch(
      String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Switch(
          value: value,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }

  Widget _buildCustomLoadingIndicator() {
    // A completely custom animated loading indicator
    return const CustomLoadingIndicator();
  }

  String _getTransitionName(SOffstageTransition type) {
    switch (type) {
      case SOffstageTransition.fade:
        return 'Fade';
      case SOffstageTransition.scale:
        return 'Scale';
      case SOffstageTransition.fadeAndScale:
        return 'Fade & Scale';
      case SOffstageTransition.slide:
        return 'Slide';
      case SOffstageTransition.rotation:
        return 'Rotation';
    }
  }
}

class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({super.key});

  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.14159,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.deepPurple,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Custom Loading...',
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
