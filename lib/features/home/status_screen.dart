import 'package:flutter/material.dart' hide StepState;
import 'package:file_picker/file_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_small_button.dart';
import '../../core/widgets/status_timeline.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  // null = belum unggah; terisi = nama file yang dipilih
  String? _uploadedName;
  bool _isPicking = false;

  bool get _uploaded => _uploadedName != null;

  Future<void> _pickFile() async {
    if (_isPicking) return;
    _isPicking = true;

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );
      if (result == null || result.isEmpty) return; // user batal / tidak pilih file
      if (!mounted) return;

      final file = result.first;
      debugPrint('Dipilih: ${file.name}');
      setState(() => _uploadedName = file.name);
    } catch (e) {
      debugPrint('File picker dibatalkan / error: $e');
    } finally {
      // Jeda singkat agar native / web intent benar-benar selesai sebelum bisa dibuka lagi
      await Future.delayed(const Duration(milliseconds: 300));
      _isPicking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              Text(
                'pembukaan rekening'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pengajuan sedang diproses',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'No. ref ONB-SG-2026-00418 · dikirim 26 Okt 2026',
                style: TextStyle(fontSize: 13, color: AppColors.muted),
              ),
              const SizedBox(height: 22),

              // Kartu: oranye (perlu dokumen) atau hijau (sudah terkirim)
              _uploaded ? _uploadedCard() : _needDocCard(),

              const SizedBox(height: 22),
              StatusTimeline([
                const TimelineStep(
                  StepState.done,
                  'Pengajuan diterima',
                  '26 Okt, 09:12',
                ),
                const TimelineStep(
                  StepState.done,
                  'Cek dokumen · Account Services',
                  '26 Okt, 10:40',
                ),
                TimelineStep(
                  _uploaded ? StepState.done : StepState.now,
                  _uploaded
                      ? 'Dokumen tambahan diterima'
                      : 'Menunggu dokumen tambahan',
                  _uploaded ? 'Baru saja' : 'Batas unggah 2 Nov 2026',
                ),
                TimelineStep(
                  _uploaded ? StepState.now : StepState.todo,
                  'Screening & KYC',
                  'Account Services',
                ),
                const TimelineStep(
                  StepState.todo,
                  'Review HOD & Compliance (LCD)',
                  'Termasuk EDD bila diperlukan',
                ),
                const TimelineStep(
                  StepState.todo,
                  'Approval cabang (Teller & SPV)',
                  'Pembuatan CIF & rekening',
                ),
                const TimelineStep(
                  StepState.todo,
                  'Rekening aktif',
                  'Detail rekening dikirim via email',
                ),
              ]),
              const SizedBox(height: 8),
              const Text(
                'Notifikasi dikirim lewat email & push setiap tahap berubah.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _needDocCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.accent, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Perlu dokumen tambahan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.accentDark,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Account services: "Slip gaji 3 bulan terakhir belum terbaca jelas. Mohon unggah ulang."',
            style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.text),
          ),
          const SizedBox(height: 10),
          AppSmallButton(
            label: 'Unggah dokumen',
            height: 38,
            onPressed: _pickFile,
          ),
        ],
      ),
    );
  }

  Widget _uploadedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.success, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dokumen terkirim',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$_uploadedName\nMenunggu pemeriksaan Account Services.',
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
