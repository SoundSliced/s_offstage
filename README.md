
# s_offstage

A Flutter package for smooth loading/content transitions and content hiding/reveal widgets.


## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  s_offstage: ^1.0.1
```


## Usage

Import the package:

```dart
import 'package:s_offstage/s_offstage.dart';
```

### Example

```dart
SOffstage(
  isOffstage: isLoading,
  child: YourContentWidget(),
)
```

See [`example/main.dart`](example/main.dart) for a complete runnable example:

```dart
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

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SOffstage Example')),
      body: Center(
        child: SOffstage(
          isOffstage: _loading,
          child: Container(
            padding: const EdgeInsets.all(24),
            color: Colors.green.shade100,
            child: const Text(
              'Loaded content!',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
```


## Features

- `SOffstage` widget: Smooth fade transitions between loading and content
- Customizable loading indicator (default or custom widget)
- Performance-optimized with Offstage and AnimatedOpacity
- `HiddenContent` widget: Hide/reveal content with optional force reveal and custom indicator


## License

MIT License. See [LICENSE](LICENSE) for details.


## Repository

https://github.com/SoundSliced/s_offstage
