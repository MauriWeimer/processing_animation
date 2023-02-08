import 'package:flutter/material.dart';

import './src/processing_animation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Processing Animation',
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: const Center(child: ProcessingAnimation()),
      ),
    );
  }
}
