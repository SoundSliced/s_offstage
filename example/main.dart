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
