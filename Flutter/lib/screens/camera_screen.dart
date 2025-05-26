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
      appBar: AppBar(
        title: const Text('Cámara'),
        actions: [
          if (_capturedImage != null)
            IconButton(
              icon: const Icon(Icons.check),
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
            ),
        ],
      ),
      body: _capturedImage != null
          ? Center(
        child: Image.file(File(_capturedImage!.path)),
      )
          : CameraPreview(_controller!),
      floatingActionButton: _capturedImage == null
          ? FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera),
      )
          : FloatingActionButton(
        onPressed: () => setState(() => _capturedImage = null),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}