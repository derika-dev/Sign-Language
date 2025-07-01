import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';

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

    double totalLength = path.computeMetrics().fold(
      0.0,
      (double prev, PathMetric metric) => prev + metric.length,
    );

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
  bool _isPicking = false; // Tambahkan flag ini

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    if (_isPicking) return; // Cegah double tap
    setState(() {
      _isPicking = true;
    });
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      // Optional: tampilkan error ke user
    } finally {
      setState(() {
        _isPicking = false;
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
              fontSize: 28,
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
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Yuk, belajar isyarat hari ini!",
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC727),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Abjad Isyarat",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Dalam bahasa isyarat abjad ditunjukkan dengan jari. Yuk, kenali satu per satu!",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Image.asset(
                        'assets/images/Crossed Fingers.png',
                        width: 72,
                        height: 72,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
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
                      padding: const EdgeInsets.all(
                        16,
                      ), // Tambahkan padding di sini
                      child: Column(
                        children: [
                          const Icon(
                            Icons.image_outlined,
                            size: 56,
                            color: Color(0xFFFFC727),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Unggah Foto",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () =>
                                    _pickImage(ImageSource.gallery),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFC727),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.insert_drive_file_rounded,
                                  color: Colors.black,
                                  size: 28,
                                ),
                                label: const Text(
                                  'File',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () => _pickImage(ImageSource.camera),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFC727),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.black,
                                  size: 28,
                                ),
                                label: const Text(
                                  'Camera',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
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
                    onPressed: () {
                      // implementasikan translate di sini
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
                if (_imageFile != null)
                  Center(
                    child: Image.file(
                      File(_imageFile!.path),
                      width: 240,
                      height: 240,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
