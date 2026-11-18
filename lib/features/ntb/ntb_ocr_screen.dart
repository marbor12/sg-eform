import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/nric_parser.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/id_camera_frame.dart';
import 'ntb_profile_screen.dart';

class NtbOcrScreen extends StatefulWidget {
  const NtbOcrScreen({super.key});

  @override
  State<NtbOcrScreen> createState() => _NtbOcrScreenState();
}

class _NtbOcrScreenState extends State<NtbOcrScreen> {
  static const double _footerSpace = 96; // ruang untuk tombol (keyboard tutup)
  static const double _footerHeight = 64; // ruang untuk tombol (keyboard buka)

  final _name = TextEditingController();
  final _id = TextEditingController();
  final _dob = TextEditingController();
  final _nationality = TextEditingController();
  final _address = TextEditingController();

  CameraController? _camera;
  bool _scanning = false;
  bool _hasScanned = false;
  int _found = 0;

  @override
  void dispose() {
    _name.dispose();
    _id.dispose();
    _dob.dispose();
    _nationality.dispose();
    _address.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _hasScanned &&
      _name.text.trim().isNotEmpty &&
      _id.text.trim().isNotEmpty &&
      _dob.text.trim().isNotEmpty;

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _scan() async {
    final cam = _camera;
    if (kIsWeb) {
      _toast('OCR hanya tersedia di Android/iOS.');
      return;
    }
    if (cam == null || !cam.value.isInitialized) {
      _toast('Kamera belum siap.');
      return;
    }

    setState(() => _scanning = true);
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    XFile? shot;

    try {
      shot = await cam.takePicture();
      final result = await recognizer.processImage(
        InputImage.fromFilePath(shot.path),
      );
      final data = parseNric(result.text);

      if (!mounted) return;
      setState(() {
        if (data.name != null) _name.text = data.name!;
        if (data.nric != null) _id.text = data.nric!;
        if (data.dob != null) _dob.text = data.dob!;

        if (data.nric != null &&
            _nationality.text.isEmpty &&
            'ST'.contains(data.nric![0])) {
          _nationality.text = 'Singapore';
        }

        _found = data.foundCount;
        _hasScanned = true;
      });

      if (data.foundCount == 0) {
        _toast('Teks tidak terbaca. Coba lagi dengan cahaya lebih terang.');
      }
    } catch (e) {
      debugPrint('OCR gagal: $e');
      if (mounted) _toast('Gagal memindai. Coba lagi.');
    } finally {
      try {
        await recognizer.close();
      } catch (_) {}

      if (shot != null) {
        try {
          await File(shot.path).delete();
        } catch (_) {}
      }
      if (mounted) setState(() => _scanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allFound = _found == 3;
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: AppTopBar(
                title: 'Verifikasi identitas',
                step: 1,
                total: 5,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  // Area scroll. Saat keyboard terbuka, berhenti di atas tombol
                  // supaya textfield tidak tertutup.
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: keyboardOpen ? _footerHeight : 0,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        14,
                        20,
                        keyboardOpen ? 14 : _footerSpace,
                      ),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IdCameraFrame(
                            hint: _hasScanned
                                ? 'Hasil pindai di bawah · periksa & koreksi'
                                : 'Posisikan sisi depan NRIC lalu tekan Pindai',
                            onCameraReady: (c) => _camera = c,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Hasil OCR — periksa & koreksi',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.text,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: !_hasScanned
                                      ? AppColors.soft
                                      : allFound
                                      ? AppColors.successSoft
                                      : AppColors.accentSoft,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  !_hasScanned
                                      ? 'Belum dipindai'
                                      : '$_found/3 terbaca',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: !_hasScanned
                                        ? AppColors.muted
                                        : allFound
                                        ? AppColors.success
                                        : AppColors.accentDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'Nama sesuai ID',
                            controller: _name,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: 'NRIC / FIN',
                                  controller: _id,
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: AppTextField(
                                  label: 'Tanggal lahir',
                                  controller: _dob,
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'Kewarganegaraan',
                            controller: _nationality,
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'Alamat (isi manual)',
                            controller: _address,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tombol melayang di bawah
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: AppButton(
                              label: _scanning
                                  ? 'Memindai…'
                                  : (_hasScanned ? 'Scan ulang' : 'Pindai'),
                              outlined: true,
                              onPressed: _scanning ? null : _scan,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 14,
                            child: AppButton(
                              label: 'Data sudah benar',
                              onPressed: _canContinue
                                  ? () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const NtbProfileScreen(),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}