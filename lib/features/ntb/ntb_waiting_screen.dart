import 'package:flutter/material.dart' hide StepState;
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/icon_circle.dart';
import '../../core/widgets/status_timeline.dart' show StepState;

class NtbWaitingScreen extends StatelessWidget {
  const NtbWaitingScreen({super.key});

  // nomor contoh; nanti datang dari server
  static const _refNo = 'ONB-SG-2026-00418';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 72, 24, 0),
          child: Column(
            children: [
              // ===== IKON + JUDUL + PARAGRAF =====
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    IconCircle(
                      icon: Icons.schedule_outlined,
                      color: AppColors.primary,
                      background: AppColors.soft,
                      size: 88,
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Menunggu validasi cabang',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        height: 1.3,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Pengajuan Anda sedang diperiksa petugas BNI Singapore. '
                      'Kami kirim email & SMS saat sudah tervalidasi, lalu '
                      'Anda bisa membuat password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.55,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ===== KARTU NO. REFERENSI =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No. referensi',
                          style: TextStyle(fontSize: 12, color: AppColors.muted),
                        ),
                        SizedBox(height: 2),
                        Text(
                          _refNo,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Estimasi 1–3 hari kerja',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12, color: AppColors.muted),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ===== 4 LANGKAH =====
              const _StepRow(StepState.done, 'Pengajuan terkirim'),
              const SizedBox(height: 12),
              const _StepRow(StepState.now, 'Verifikasi dokumen & KYC'),
              const SizedBox(height: 12),
              const _StepRow(StepState.todo, 'Approval HOD, LCD & cabang'),
              const SizedBox(height: 12),
              const _StepRow(StepState.todo, 'Buat password & rekening aktif'),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: AppButton(
            label: 'Lihat detail status',
            outlined: true,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Halaman status pengajuan belum dibuat'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Satu baris langkah: titik + teks (tanpa garis penghubung).
class _StepRow extends StatelessWidget {
  const _StepRow(this.state, this.label);

  final StepState state;
  final String label;

  @override
  Widget build(BuildContext context) {
    final BoxDecoration dot;
    switch (state) {
      case StepState.done:
        dot = const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        );
      case StepState.now:
        dot = BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.accent, width: 6),
        );
      case StepState.todo:
        dot = BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.dotTodo, width: 2),
        );
    }

    return Row(
      children: [
        Container(width: 20, height: 20, decoration: dot),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: state == StepState.done
                  ? FontWeight.w600
                  : (state == StepState.now ? FontWeight.w700 : FontWeight.w400),
              color: state == StepState.todo ? AppColors.muted : AppColors.text,
            ),
          ),
        ),
      ],
    );
  }
}