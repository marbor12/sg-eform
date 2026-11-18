import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/liveness_checker.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/live_camera.dart';

enum PillState { done, current, todo }

/// Data satu label langkah liveness.
class LivenessPill {
  final String label;
  final PillState state;

  const LivenessPill(this.label, this.state);
}

const _labels = ['Hadap depan', 'Kedip', 'Toleh kiri'];
const _titles = [
  'Hadap lurus ke kamera',
  'Kedipkan mata perlahan',
  'Toleh ke kiri perlahan',
];

class LivenessScreen extends StatefulWidget {
  const LivenessScreen({
    super.key,
    required this.step,
    required this.total,
    required this.subtitle,
    required this.footer,
    required this.onPassed,
  });

  final int step;
  final int total;
  final String subtitle;
  final String footer;
  final void Function(BuildContext context) onPassed;

  @override
  State<LivenessScreen> createState() => _LivenessScreenState();
}

class _LivenessScreenState extends State<LivenessScreen> {
  static const _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  final _checker = LivenessChecker();
  final _detector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true, // untuk peluang mata terbuka
      performanceMode: FaceDetectorMode.fast,
      minFaceSize: 0.3,
    ),
  );

  CameraController? _camera;
  bool _busy = false;
  bool _passed = false;
  bool _disposed = false;
  DateTime _lastFrame = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void dispose() {
    _disposed = true;
    _detector.close();
    super.dispose();
  }

  ImageFormatGroup? get _formatGroup {
    if (kIsWeb) return null;
    return Platform.isAndroid
        ? ImageFormatGroup.nv21
        : ImageFormatGroup.bgra8888;
  }

  void _onCameraReady(CameraController c) {
    _camera = c;
    if (kIsWeb) return;
    c.startImageStream((image) async {
      if (_busy || _passed || _disposed) return;
      final now = DateTime.now();
      if (now.difference(_lastFrame) < const Duration(milliseconds: 120)) {
        return; // batasi ±8 frame per detik
      }
      _lastFrame = now;
      _busy = true;
      try {
        await _onFrame(image, c);
      } catch (e) {
        debugPrint('Deteksi wajah gagal: $e');
      } finally {
        _busy = false;
      }
    });
  }

  Future<void> _onFrame(CameraImage image, CameraController c) async {
    final input = _toInputImage(image, c);
    if (input == null) return;

    final faces = await _detector.processImage(input);
    if (!mounted || _passed || _disposed) return;

    if (faces.isEmpty) {
      _checker.lostFace();
      return;
    }

    // pakai wajah terbesar di layar
    final face = faces.reduce((a, b) {
      final areaA = a.boundingBox.width * a.boundingBox.height;
      final areaB = b.boundingBox.width * b.boundingBox.height;
      return areaA >= areaB ? a : b;
    });

    final advanced = _checker.update(
      yaw: face.headEulerAngleY ?? 0,
      leftEye: face.leftEyeOpenProbability,
      rightEye: face.rightEyeOpenProbability,
    );

    if (advanced) {
      setState(() {});
      if (_checker.done) _finish();
    }
  }

  Future<void> _finish() async {
    if (_passed) return;
    _passed = true;
    try {
      await _camera?.stopImageStream();
    } catch (_) {}
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) widget.onPassed(context);
  }

  /// Mengubah frame kamera menjadi masukan ML Kit (butuh rotasi yang tepat).
  InputImage? _toInputImage(CameraImage image, CameraController c) {
    final sensor = c.description.sensorOrientation;
    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensor);
    } else {
      var comp = _orientations[c.value.deviceOrientation];
      if (comp == null) return null;
      if (c.description.lensDirection == CameraLensDirection.front) {
        comp = (sensor + comp) % 360;
      } else {
        comp = (sensor - comp + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(comp);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  List<LivenessPill> get _pills => [
        for (var i = 0; i < _labels.length; i++)
          LivenessPill(
            _labels[i],
            i < _checker.index
                ? PillState.done
                : (i == _checker.index ? PillState.current : PillState.todo),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    final title =
        _checker.done ? 'Verifikasi selesai' : _titles[_checker.index];

    return Scaffold(
      backgroundColor: AppColors.text,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: AppTopBar(
                title: 'Verifikasi wajah',
                step: widget.step,
                total: widget.total,
                dark: true,
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Mode debug: ketuk lingkaran untuk melewati deteksi
                      // (berguna di emulator tanpa kamera).
                      GestureDetector(
                        onTap: kDebugMode ? _finish : null,
                        child: Container(
                          width: 280,
                          height: 280,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0x0DFFFFFF),
                            border: Border.all(
                              color: const Color(0xFF4FB3A9),
                              width: 4,
                            ),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              LiveCamera(
                                lens: CameraLensDirection.front,
                                imageFormatGroup: _formatGroup,
                                onReady: _onCameraReady,
                              ),
                              Center(
                                child: CustomPaint(
                                  size: const Size(120, 140),
                                  painter: _FacePainter(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: Text(
                          widget.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xBFFFFFFF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < _pills.length; i++) ...[
                            if (i > 0) const SizedBox(width: 8),
                            _Pill(_pills[i]),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Text(
                widget.footer,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: Color(0xB3FFFFFF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Label kecil status langkah liveness (3 keadaan).
class _Pill extends StatelessWidget {
  const _Pill(this.data);

  final LivenessPill data;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    switch (data.state) {
      case PillState.done:
        bg = const Color(0x384FB3A9); // tosca 22%
        fg = const Color(0xFFBFEAE4);
      case PillState.current:
        bg = const Color(0x1FFFFFFF); // putih 12%
        fg = Colors.white;
      case PillState.todo:
        bg = const Color(0x14FFFFFF); // putih 8%
        fg = const Color(0xB3FFFFFF); // putih 70%
    }

    final done = data.state == PillState.done;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        done ? '${data.label} ✓' : data.label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

/// Siluet kepala dan bahu (ukuran gambar 120 x 140).
class _FacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x73FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // kepala
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(60, 58), width: 72, height: 88),
      paint,
    );

    // bahu
    final shoulders = Path()
      ..moveTo(14, 140)
      ..relativeCubicTo(4, -26, 22, -38, 46, -38)
      ..relativeCubicTo(24, 0, 42, 12, 46, 38);
    canvas.drawPath(shoulders, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}