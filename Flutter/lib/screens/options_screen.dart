import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_screen.dart';
import 'gallery_screen.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  // Esta función se encarga de manejar la apertura de la cámara
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opciones'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _openCamera(context),
              child: const Text('Abrir Cámara'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GalleryScreen()),
                );
              },
              child: const Text('Abrir Galería'),
            ),
          ],
        ),
      ),
    );
  }
}
