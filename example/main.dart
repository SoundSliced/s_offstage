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
    setState(() {
      _statusMessage =
          isOffstage ? 'Content is hidden (offstage)' : 'Content is visible!';
    });
    print('Offstage state changed: $isOffstage');
  }

  void _handleAnimationComplete(bool isOffstage) {
    setState(() {
      _animationStatus = isOffstage
          ? 'Animation complete: Fully hidden'
          : 'Animation complete: Fully visible';
    });
    print('Animation completed: $isOffstage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SOffstage Example')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status indicators
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        _statusMessage,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _loading ? Colors.orange : Colors.green,
                        ),
                      ),
                      if (_animationStatus.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          _animationStatus,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Transition type selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transition Type:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: SOffstageTransition.values.map((type) {
                          return ChoiceChip(
                            label: Text(_getTransitionName(type)),
                            selected: _transition == type,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _transition = type;
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Toggle button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _loading = !_loading;
                    _animationStatus = '';
                  });
                },
                child: Text(_loading ? 'Show Content' : 'Hide Content'),
              ),

              const SizedBox(height: 32),

              // SOffstage widget with all features
              SizedBox(
                height: 300,
                child: Center(
                  child: SOffstage(
                    isOffstage: _loading,
                    transition: _transition,
                    onOffstageStateChanged: _handleOffstageStateChange,
                    onAnimationComplete: _handleAnimationComplete,
                    fadeInCurve: Curves.easeOut,
                    fadeOutCurve: Curves.easeIn,
                    delayBeforeShow: const Duration(milliseconds: 100),
                    showLoadingAfter: const Duration(milliseconds: 200),
                    slideDirection: AxisDirection.up,
                    slideOffset: 0.5,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
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

              const SizedBox(height: 24),

              // Feature highlights
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Features demonstrated:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildFeatureItem('✓ Multiple transition types'),
                      _buildFeatureItem('✓ State change callbacks'),
                      _buildFeatureItem('✓ Animation completion callbacks'),
                      _buildFeatureItem('✓ Custom animation curves'),
                      _buildFeatureItem('✓ Delay before showing (100ms)'),
                      _buildFeatureItem('✓ Conditional loading (after 200ms)'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[700],
        ),
      ),
    );
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
