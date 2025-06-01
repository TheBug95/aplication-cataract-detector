import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'processing_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isLoading = true;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        _initializeCamera(description: _controller!.description);
      }
    }
  }

  Future<void> _initializeCamera({CameraDescription? description}) async {
    try {
      final cameras = await availableCameras();
      final camera = description ?? cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } on CameraException catch (e) {
      _showCameraError(e);
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      setState(() => _isLoading = true);
      final image = await _controller!.takePicture();

      setState(() {
        _capturedImage = image;
        _isLoading = false;
      });

    } on CameraException catch (e) {
      _showCameraError(e);
      setState(() => _isLoading = false);
    }
  }

  void _showCameraError(CameraException e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.description}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _capturedImage == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111418)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Iris Science',
          style: TextStyle(
            color: Color(0xFF111418),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _capturedImage != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(File(_capturedImage!.path)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFF111418),
                            backgroundColor: const Color(0xFFF0F2F5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () => setState(() => _capturedImage = null),
                          child: const Text(
                            'Retake',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF3D98F4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProcessingScreen(
                                imageFile: File(_capturedImage!.path),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Accept',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 24.0, bottom: 8.0),
                  child: Center(
                    child: Text(
                      'Upload an image',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111418),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CameraPreview(_controller!),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: ElevatedButton(
                    onPressed: _takePicture,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D98F4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text(
                      'Take a photo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}