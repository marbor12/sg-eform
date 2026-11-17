import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LiveCamera extends StatefulWidget {
  final CameraLensDirection lens;
  final void Function(CameraController)? onReady;

  const LiveCamera({
    super.key, 
    this.lens = CameraLensDirection.back,
    this.onReady,
    });

  @override
  State<LiveCamera> createState() => _LiveCameraState();
}

class _LiveCameraState extends State<LiveCamera> {
  CameraController? _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final all = await availableCameras();
      if (all.isEmpty) {
        if (mounted) setState(() => _error = 'Kamera tidak ditemukan.');
        return;
      }
      // pilih kamera sesuai arah; kalau tidak ada, pakai yang pertama
      final cam = all.firstWhere(
        (c) => c.lensDirection == widget.lens,
        orElse: () => all.first,
      );
      final controller = CameraController(
        cam,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
      widget.onReady?.call(controller);
    } on CameraException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.code == 'CameraAccessDenied'
            ? 'Izin kamera ditolak. Aktifkan di pengaturan.'
            : 'Kamera gagal dibuka.';
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ),
      );
    }

    if (c == null || !c.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColors.primary,
        ),
      );
    }

    final size = c.value.previewSize!;
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: size.height, 
          height: size.width,
          child: CameraPreview(c),
        ),
      ),
    );
  }
}