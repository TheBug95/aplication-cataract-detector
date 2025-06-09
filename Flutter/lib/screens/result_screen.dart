import 'dart:io';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class DiagnosisResultsScreen extends StatelessWidget {
  final Map<String, dynamic> apiResponse;
  final File imageFile;

  const DiagnosisResultsScreen({
    Key? key,
    required this.apiResponse,
    required this.imageFile,
  }) : super(key: key);

  Color _getConfidenceColor(double confidence) {
    if (confidence < 0.5) return Colors.red;
    if (confidence < 0.8) return Colors.orange;
    return Colors.green;
  }

  String _getDiagnosisMessage(String diagnosis) {
    switch (diagnosis.toLowerCase()) {
      case 'cataract':
        return 'Our analysis detected signs of cataracts. Cataracts are a clouding of the eye\'s natural lens. We recommend scheduling an appointment with an ophthalmologist for a comprehensive eye examination. Early detection and treatment can help preserve your vision.';
      default:
        return 'Based on the analysis of your iris scans, your eye health appears normal. However, regular eye check-ups are recommended to maintain optimal eye health.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = apiResponse['result'] ?? {};
    final diagnosis = result['diagnosis']?.toString() ?? 'No diagnosis';
    final confidence = double.tryParse(result['confidence']?.toString() ?? '0') ?? 0;
    final confidencePercentage = (confidence * 100).toStringAsFixed(0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header section
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const IrisHomePage()),
                        );
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Diagnosis Results',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111418),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // To balance the back button
                  ],
                ),
              ),

              // Original image section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Stats cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 400) {
                      return Column(
                        children: [
                          _buildStatCard('Diagnosis', diagnosis, Colors.blue),
                          const SizedBox(height: 12),
                          _buildStatCard(
                            'Confidence',
                            '$confidencePercentage%',
                            _getConfidenceColor(confidence),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildStatCard('Diagnosis', diagnosis, Colors.blue),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Confidence',
                              '$confidencePercentage%',
                              _getConfidenceColor(confidence),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),

              // Description text
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[100]!),
                  ),
                  child: Text(
                    _getDiagnosisMessage(diagnosis),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF111418),
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              // Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Scheduling consultation...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D98F4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Schedule Consultation',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDBE0E6)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111418),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}