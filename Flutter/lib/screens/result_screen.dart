import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
      ),
      body: const Center(
        child: Text(
          'Aquí van los resultados',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}