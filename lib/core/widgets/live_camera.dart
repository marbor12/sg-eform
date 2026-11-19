import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LiveCamera extends StatefulWidget {
  final CameraLensDirection lens;
  final void Function(CameraController controller)? onReady;
  final ImageFormatGroup? imageFormatGroup;

  const LiveCamera({
    super.key,
    this.lens = CameraLensDirection.back,
    this.onReady,
    this.imageFormatGroup,
  });

  @override
  State<LiveCamera> createState() => _LiveCameraState();
}

class _LiveCameraState extends State<LiveCamera> {
  static Future<void>? _pendingDisposal;
  static CameraController? _activeGlobalController;
  static int _globalSession = 0;

  CameraController? _controller;
  String? _error;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final session = ++_globalSession;

    // 1. Tunggu proses dispose kamera sebelumnya tuntas (terutama di Chrome Web)
    if (_pendingDisposal != null) {
      try {
        await _pendingDisposal;
      } catch (_) {}
      _pendingDisposal = null;
    }

    // 2. Jika ada controller kamera lain yang masih aktif, lepaskan dulu
    if (_activeGlobalController != null) {
      final old = _activeGlobalController;
      _activeGlobalController = null;
      await _safeRelease(old);
    }

    // 3. Beri jeda singkat khusus Web agar Chrome benar-benar melepas hardware lock webcam
    if (kIsWeb) {
      await Future.delayed(const Duration(milliseconds: 250));
    }

    if (!mounted || _isDisposed || session != _globalSession) return;

    try {
      final all = await availableCameras();
      if (all.isEmpty) {
        if (mounted && session == _globalSession) {
          setState(() => _error = 'Kamera tidak ditemukan.');
        }
        return;
      }
      // pilih kamera sesuai arah; kalau tidak ada, pakai yang pertama
      final cam = all.firstWhere(
        (c) => c.lensDirection == widget.lens,
        orElse: () => all.first,
      );

      if (!mounted || _isDisposed || session != _globalSession) return;

      final controller = CameraController(
        cam,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: widget.imageFormatGroup,
      );
      await controller.initialize();
      if (!mounted || _isDisposed || session != _globalSession) {
        await _safeRelease(controller);
        return;
      }

      _activeGlobalController = controller;
      if (mounted) {
        setState(() => _controller = controller);
      }
      widget.onReady?.call(controller);
    } on CameraException catch (e) {
      if (!mounted || session != _globalSession) return;
      setState(() {
        _error = e.code == 'CameraAccessDenied'
            ? 'Izin kamera ditolak. Aktifkan di pengaturan.'
            : 'Kamera gagal dibuka.';
      });
    } catch (e) {
      debugPrint('Kamera gagal: $e');
      if (mounted && session == _globalSession) {
        setState(() => _error = 'Kamera gagal dibuka.');
      }
    }
  }

  /// Hentikan aliran gambar (bila ada), lalu matikan kamera tanpa melempar error.
  static Future<void> _safeRelease(CameraController? c) async {
    if (c == null) return;
    try {
      if (c.value.isStreamingImages) await c.stopImageStream();
    } catch (_) {}
    try {
      await c.dispose();
    } catch (_) {}
  }

  @override
  void dispose() {
    _isDisposed = true;
    final c = _controller;
    _controller = null;
    if (_activeGlobalController == c) {
      _activeGlobalController = null;
    }
    if (c != null) {
      _pendingDisposal = _safeRelease(c);
    }
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