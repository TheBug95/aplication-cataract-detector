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
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 32),
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
                  ),
                  IconButton(
                    onPressed: () {},
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
                  'assets\images\IriscienceLogo.png',
                  width: screenWidth * 0.6, // Responsive scaling
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
                    style: TextStyle(
                      color: Color(0xFF111418),
                      fontSize: 16,
                    ),
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
                      MaterialPageRoute(builder: (context) => const OptionsScreen()),
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
