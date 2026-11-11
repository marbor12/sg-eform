import 'package:flutter/material.dart' hide StepState;
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/icon_circle.dart';
import '../../core/widgets/status_timeline.dart';

class ResultNtbScreen extends StatelessWidget {
  const ResultNtbScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const IconCircle(
                icon: Icons.person_add_alt_1_outlined,
                color: AppColors.accent,
                background: AppColors.accentSoft,
                size: 72,
              ),
              const SizedBox(height: 16),
              const Text(
                'Selamat datang, nasabah baru',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Email belum terdaftar. Lanjutkan pembukaan rekening dari HP. Pengajuan divalidasi petugas cabang sebelum rekening aktif.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ALUR PEMBUKAAN REKENING',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.9,
                    color: AppColors.muted,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const StatusTimeline([
                TimelineStep(
                  StepState.now,
                  'Lengkapi data diri',
                  'Scan ID, data pribadi & dokumen',
                ),
                TimelineStep(
                  StepState.todo,
                  'Liveness & face match',
                  'Verifikasi wajah',
                ),
                TimelineStep(
                  StepState.todo,
                  'Validasi cabang',
                  '1–3 hari kerja',
                ),
              ]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: AppButton(label: 'Buka rekening', onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Halaman jenis nasabah belum dibuat')),
            );
          }),
        ),
      ),
    );
  }
}
