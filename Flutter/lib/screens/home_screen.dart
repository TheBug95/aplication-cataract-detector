import 'package:flutter/material.dart';
import 'options_screen.dart';

class IrisScienceApp extends StatelessWidget {
  const IrisScienceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stitch Design',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const IrisHomePage(),
    );
  }
}

class IrisHomePage extends StatelessWidget {
  const IrisHomePage({super.key});

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'About Iriscience',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF111418),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mission Section
                const Text(
                  'Our Mission',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF3d98f4),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'To improve access to vital eye care and prevent avoidable blindness. By empowering communities with accessible, AI-driven tools, the company aims to make a lasting impact on global vision health.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF111418),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                
                // AI-assisted diagnosis
                const Text(
                  'AI-assisted diagnosis',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF3d98f4),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'We take pride in providing safe algorithms based on diverse datasets',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF111418),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                
                // EMR integrated platform
                const Text(
                  'EMR integrated platform',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF3d98f4),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'User-friendly interface. Real-time eye tracking facilitates image acquisition',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF111418),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Education
                const Text(
                  'Education',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF3d98f4),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Iriscience Academy: continuous education and training for health providers',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF111418),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Color(0xFF3d98f4),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _showInfoDialog(context),
                    icon: const Icon(
                      Icons.help_outline,
                      color: Color(0xFF111418),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Imagen centrada (logo)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Image.asset(
                  'assets/images/IriscienceLogo.png',
                  width: screenWidth * 0.6,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Title and description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Text(
                    'Welcome to Iris Science',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF111418),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Begin your diagnostic journey with us. Our advanced image analysis provides accurate insights into your health.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF111418), fontSize: 16),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3d98f4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OptionsScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Start Diagnosis',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}