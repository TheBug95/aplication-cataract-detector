import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'result_screen.dart';

class ProcessingScreen extends StatefulWidget {
  final File imageFile;

  const ProcessingScreen({super.key, required this.imageFile});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  double _progress = 0.0;
  bool _isError = false;
  String? _filename;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  Future<void> _startProcessing() async {
    // Reset error state
    setState(() {
      _isError = false;
      _progress = 0.0;
      _errorMessage = '';
    });

    _startSmoothProgress();

    try {
      // 1. POST request to upload image
      print('Enviando imagen al servidor...');
      final postResponse = await _sendImageToApi(widget.imageFile);
      print('Respuesta POST: $postResponse');

      // Verificar que la respuesta contenga filename en la estructura correcta
      final storedData = postResponse['stored'];
      if (storedData == null || storedData['filename'] == null || storedData['filename'].toString().trim().isEmpty) {
        throw Exception('El servidor no devolvió un nombre de archivo válido');
      }

      _filename = storedData['filename'].toString();
      print('Filename obtenido: $_filename');

      // 2. GET request to fetch results - solo si tenemos filename
      print('Obteniendo resultados para archivo: $_filename');
      final getResponse = await _fetchResults(_filename!);
      print('Respuesta GET: $getResponse');

      // Verificar que la respuesta tenga la estructura esperada
      if (getResponse['result'] == null) {
        throw Exception('La respuesta del servidor no contiene resultados válidos');
      }

      // Wait for progress to complete
      while (_progress < 1.0) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (!mounted) return;

      // Navigate to results screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DiagnosisResultsScreen(
            apiResponse: getResponse,
            imageFile: widget.imageFile,
          ),
        ),
      );
    } catch (e) {
      print('Error en procesamiento: $e');

      if (!mounted) return;

      setState(() {
        _isError = true;
        _errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _sendImageToApi(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.0.36:8000/predict/'),
      );

      // Add the image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      // Timeout para la request
      var response = await request.send().timeout(const Duration(seconds: 30));
      final responseString = await response.stream.bytesToString();

      print('Status Code POST: ${response.statusCode}');
      print('Response POST: $responseString');

      if (response.statusCode == 200) {
        final parsedResponse = _parseResponse(responseString);

        // Validar que la respuesta tenga la estructura esperada
        if (parsedResponse is! Map<String, dynamic>) {
          throw Exception('Respuesta del servidor en formato incorrecto');
        }

        return parsedResponse;
      } else {
        throw Exception('Error del servidor (POST): ${response.statusCode} - $responseString');
      }
    } on TimeoutException {
      throw Exception('Timeout: El servidor tardó demasiado en responder');
    } catch (e) {
      throw Exception('Error enviando imagen: $e');
    }
  }

  Future<Map<String, dynamic>> _fetchResults(String filename) async {
    try {
      final uri = Uri.parse('http://192.168.0.36:8000/results/?filename=$filename');
      print('GET URL: $uri');

      final response = await http.get(uri).timeout(const Duration(seconds: 30));

      print('Status Code GET: ${response.statusCode}');
      print('Response GET: ${response.body}');

      if (response.statusCode == 200) {
        final parsedResponse = _parseResponse(response.body);

        // Validar estructura de respuesta
        if (parsedResponse is! Map<String, dynamic>) {
          throw Exception('Respuesta de resultados en formato incorrecto');
        }

        return parsedResponse;
      } else {
        throw Exception('Error obteniendo resultados: ${response.statusCode} - ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Timeout obteniendo resultados');
    } catch (e) {
      throw Exception('Error obteniendo resultados: $e');
    }
  }

  Map<String, dynamic> _parseResponse(String responseString) {
    try {
      if (responseString.trim().isEmpty) {
        throw Exception('Respuesta vacía del servidor');
      }

      final decoded = json.decode(responseString);
      if (decoded is! Map<String, dynamic>) {
        throw Exception('Formato de respuesta inválido');
      }

      return decoded;
    } catch (e) {
      print('Error parsing JSON: $e');
      print('Response string: $responseString');
      throw Exception('Error analizando respuesta del servidor: $e');
    }
  }

  void _startSmoothProgress() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted || _isError) return;

      setState(() {
        _progress += 0.02;
      });

      if (_progress < 1.0) {
        _startSmoothProgress();
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
              child: Image.file(
                widget.imageFile,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _isError ? 'Error procesando imagen' : 'Analizando imagen...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _isError ? Colors.red : const Color(0xFF111418),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 8,
                backgroundColor: const Color(0xFFdbe0e6),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _isError ? Colors.red : const Color(0xFF111418),
                ),
              ),
            ),
            if (_isError) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red[800],
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _startProcessing();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Reintentar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Volver'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}