import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_screen.dart';
import 'gallery_screen.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  void _openCamera(BuildContext context) async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CameraScreen(),
      ),
    );
  }

  void _openGallery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GalleryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                        color: const Color(0xFF111418),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Iris Science',
                            style: TextStyle(
                              color: Color(0xFF111418),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.015,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Space to balance the back icon
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Upload an image',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF111418),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => _openGallery(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3D98F4),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Upload from gallery',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.015,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => _openCamera(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3D98F4),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Take a photo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.015,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // bottom padding
          ],
        ),
      ),
    );
  }
}
