import 'dart:io';
import 'package:flutter/material.dart';
import 'result_screen.dart';

class ProcessingScreen extends StatefulWidget {
  final File imageFile;

  const ProcessingScreen({super.key, required this.imageFile});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startSmoothProgress();
  }

  void _startSmoothProgress() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      setState(() {
        _progress += 0.02; // Aumenta el progreso en 2% cada 100 ms
      });

      if (_progress < 1.0) {
        _startSmoothProgress();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DiagnosisResultsScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Center(
          child: Text(
            'Iris Science',
            style: TextStyle(
              color: Color(0xFF111418),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(widget.imageFile, width: 200, height: 200),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Analyzing image...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111418),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 8,
                backgroundColor: Color(0xFFdbe0e6),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF111418)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
