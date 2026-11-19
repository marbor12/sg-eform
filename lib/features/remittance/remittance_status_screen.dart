import 'package:flutter/material.dart' hide StepState;
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../home/home_screen.dart';
import '../../core/widgets/icon_circle.dart';
import '../../core/widgets/status_timeline.dart';

class RemittanceStatusScreen extends StatelessWidget {
  const RemittanceStatusScreen({super.key});

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome(context);
      },
      child: Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          const IconCircle(
                            icon: Icons.schedule_outlined,
                            color: AppColors.primary,
                            background: AppColors.soft,
                            size: 88,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'eForm terkirim',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              height: 1.3,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Menunggu validasi cabang. Anda akan menerima notifikasi saat transaksi di-release atau ditolak.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.55,
                              color: AppColors.muted,
                            ),
                          ),
                          const SizedBox(height: 18),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'No. referensi',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'RMT-SG-2026-01204',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.32,
                                        color: AppColors.text,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'SGD 1,010.00',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const StatusTimeline([
                      TimelineStep(
                        StepState.done,
                        'eForm diajukan',
                        '26 Okt, 14:05 · dana di-hold',
                      ),
                      TimelineStep(
                        StepState.now,
                        'Verifikasi teller',
                        'Form & identitas nasabah',
                      ),
                      TimelineStep(
                        StepState.todo,
                        'Screening',
                        'No hit / false hit / true hit',
                      ),
                      TimelineStep(
                        StepState.todo,
                        'Proses di Go Remit',
                        'Kurs final ditetapkan',
                      ),
                      TimelineStep(
                        StepState.todo,
                        'Release supervisor',
                        'Transaksi dieksekusi',
                      ),
                      TimelineStep(
                        StepState.todo,
                        'Dana diterima',
                        'Notifikasi ke Anda',
                      ),
                    ]),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Batalkan eForm',
                      variant: AppButtonVariant.outlineNeutral,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur batalkan belum tersedia'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: 'Ke beranda',
                      onPressed: () => _goHome(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
