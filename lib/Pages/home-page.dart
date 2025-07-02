import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double gap;
  final double dash;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 2,
    this.radius = 16,
    this.gap = 8,
    this.dash = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);

    double drawn = 0.0;
    for (final PathMetric metric in path.computeMetrics()) {
      while (drawn < metric.length) {
        final double len = (drawn + dash < metric.length)
            ? dash
            : metric.length - drawn;
        canvas.drawPath(metric.extractPath(drawn, drawn + len), paint);
        drawn += dash + gap;
      }
      drawn = 0.0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? _imageFile;
  bool _isPicking = false;

  final ImagePicker _picker = ImagePicker();

  // Tambahkan variabel untuk hasil deteksi
  String? _detectedLabel;
  double? _confidence;

  // Tambahkan variabel
  bool _isLoading = false;
  String? _detectedImageUrl;
  List<dynamic>? _detections;

  Future<void> _pickImage(ImageSource source) async {
    if (_isPicking) return;
    setState(() {
      _isPicking = true;
    });
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
          _detectedImageUrl = null;
          _detectedLabel = null;
          _confidence = null;
        });
        // Panggil fungsi deteksi setelah gambar dipilih
        _detectImage(File(pickedFile.path));
      }
    } catch (e) {
      // Optional: tampilkan error ke user
    } finally {
      setState(() {
        _isPicking = false;
      });
    }
  }

  // Modifikasi _detectImage
  Future<void> _detectImage(File imageFile) async {
    setState(() {
      _isLoading = true;
      _detectedLabel = null;
      _confidence = null;
    });
    final url = Uri.parse('https://Maulidaaa-HelloMe.hf.space/detect');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      print('Status: ${response.statusCode}');
      print('Body: $respStr');
      if (response.statusCode == 200) {
        final data = json.decode(respStr);
        setState(() {
          _detectedImageUrl = data['saved_to'];
          _detections = data['detections'];
        });
        if (_detections != null && _detections!.isNotEmpty) {
          setState(() {
            _detectedLabel =
                null; // Tidak perlu pakai _detectedLabel tunggal lagi
            _confidence = null;
          });
        } else {
          setState(() {
            _detectedLabel = 'Tidak terdeteksi';
            _confidence = null;
            _detections = null;
          });
        }
      } else {
        setState(() {
          _detectedLabel = 'Gagal mendeteksi';
          _confidence = null;
          _detectedImageUrl = null;
          _detections = null;
        });
      }
    } catch (e) {
      setState(() {
        _detectedLabel = 'Error: $e';
        _confidence = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.black87),
          ),
        ],
        title: const Text.rich(
          TextSpan(
            text: 'hello.',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cursive', // Hanya ini yang Cursive
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: 'Me',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Sans', // Ini Sans
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Text(
                      //   "Yuk, belajar isyarat hari ini!",
                      //   style: TextStyle(fontSize: 20, color: Colors.black54),
                      // ),
                      const SizedBox(height: 2),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC727),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFFFC727),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Abjad Isyarat",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Dalam bahasa isyarat abjad ditunjukkan dengan jari. \n Yuk, kenali satu per satu!",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Image.asset(
                              'assets/images/6.png',
                              width: 120,
                              height: 170,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CustomPaint(
                          painter: DashedBorderPainter(
                            color: const Color(0xFFFFC727),
                            strokeWidth: 2,
                            radius: 16,
                            gap: 8,
                            dash: 8,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: _imageFile == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.image_outlined,
                                        size: 60,
                                        color: Color(0xFFFFC727),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        "Unggah atau Ambil Foto",
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () =>
                                                _pickImage(ImageSource.gallery),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              elevation: 0,
                                              side: const BorderSide(
                                                color: Color(0xFFFFC727),
                                                width: 2,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 14,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            icon: const Icon(
                                              Icons.insert_drive_file_rounded,
                                              color: Color(0xFFFFC727),
                                            ),
                                            label: const Text(
                                              'File',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              if (_isPicking) return;
                                              var status = await Permission
                                                  .camera
                                                  .request();
                                              if (!mounted) return;
                                              if (status.isGranted) {
                                                _pickImage(ImageSource.camera);
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Izin kamera diperlukan',
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              elevation: 0,
                                              side: const BorderSide(
                                                color: Color(0xFFFFC727),
                                                width: 2,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 14,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            icon: const Icon(
                                              Icons.camera_alt_rounded,
                                              color: Color(0xFFFFC727),
                                            ),
                                            label: const Text(
                                              'Camera',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: _detectedImageUrl != null
                                            ? Image.network(
                                                _detectedImageUrl!,
                                                width: double.infinity,
                                                height: 220,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => const Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                      ),
                                                    ),
                                              )
                                            : Image.file(
                                                File(_imageFile!.path),
                                                width: double.infinity,
                                                height: 220,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _imageFile = null;
                                              _detectedImageUrl = null;
                                              _detectedLabel = null;
                                              _confidence = null;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(6),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_imageFile != null) {
                              await _detectImage(File(_imageFile!.path));
                              // Optionally: Scroll ke bawah atau tampilkan dialog
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC727),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Terjemahkan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (_isLoading)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Color(0xFFFFC727),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFFFC727),
                                        strokeWidth: 4,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      "Sedang memproses...",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color(0xFFFFC727),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (_detections != null && _detections!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color(0xFFFFC727),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hasil Deteksi:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFC727),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ..._detections!.map(
                                  (det) => Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF8E1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Color(0xFFFFC727),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.emoji_objects,
                                          color: Color(0xFFFFC727),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Label: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFFC727),
                                          ),
                                        ),
                                        Text(
                                          '${det['label']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          'Confidence: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFFC727),
                                          ),
                                        ),
                                        Text(
                                          '${(det['confidence'] * 100).toStringAsFixed(1)}%',
                                          style: const TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (_detectedLabel != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            _detectedLabel!,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
