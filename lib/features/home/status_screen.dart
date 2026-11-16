import 'package:flutter/material.dart' hide StepState;
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_small_button.dart';
import '../../core/widgets/status_timeline.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

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
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Pengajuan sedang diproses',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'No. ref ONB-SG-2026-00418 · dikirim 26 Okt 2026',
                style: TextStyle(fontSize: 13, color: AppColors.muted),
              ),
              const SizedBox(height: 22),
              Container(
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
                    Text(
                      'Perlu dokumen tambahan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Account services: "Slip gaji 3 bulan terakhir belum terbaca jelas. Mohon unggah ulang."',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppSmallButton(
                      label: 'Unggah dokumen', 
                      height: 38,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pemilih file belum tersedia'),
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const StatusTimeline([
                TimelineStep(
                  StepState.done,
                  'Pengajuan diterima',
                  '26 Okt, 09:12',
                ),
                TimelineStep(
                  StepState.done,
                  'Cek dokumen · Account Services',
                  '26 Okt, 10:40',
                ),
                TimelineStep(
                  StepState.now,
                  'Menunggu dokumen tambahan',
                  'Batas unggah 2 Nov 2026',
                ),
                TimelineStep(
                  StepState.todo,
                  'Screening & KYC',
                  'Account Services',
                ),
                TimelineStep(
                  StepState.todo,
                  'Review HOD & Compliance (LCD)',
                  'Termasuk EDD bila diperlukan',
                ),
                TimelineStep(
                  StepState.todo,
                  'Approval cabang (Teller & SPV)',
                  'Pembuatan CIF & rekening',
                ),
                TimelineStep(
                  StepState.todo,
                  'Rekening aktif',
                  'Detail rekening dikirim via email',
                ),
              ]),
              const SizedBox(height: 8),
              Text(
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
}
