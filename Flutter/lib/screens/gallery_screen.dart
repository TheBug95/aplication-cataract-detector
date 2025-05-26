import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'processing_screen.dart'; // Asegúrate de importar la pantalla de procesamiento

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería'),
        actions: [
          if (_selectedImage != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProcessingScreen(
                      imageFile: _selectedImage!,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.file(
                  _selectedImage!,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              )
            else
              const Text('No hay imagen seleccionada'),

            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Abrir Galería'),
            ),
          ],
        ),
      ),
    );
  }
}
