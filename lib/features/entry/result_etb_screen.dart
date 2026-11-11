import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/icon_circle.dart';
import '../../core/widgets/status_timeline.dart';
import '../etb/etb_ocr_screen.dart';

class ResultEtbScreen extends StatelessWidget {
  const ResultEtbScreen({super.key});

  static const _steps = [
    'Scan ID (OCR)',
    'Liveness & face match',
    'Masukkan password',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 56),
              const IconCircle(icon: Icons.how_to_reg_outlined),
              const SizedBox(height: 12),
              const Text(
                'Anda sudah nasabah BNI',
                style: TextStyle(
                  fontSize: 24,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Email terdaftar di  data nasabah kami. Verifikasi identitas sekali  lagi lalu masukkan password Anda untuk aktivasi aplikasi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LANGKAH BERIKUTNYA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.9,
                        color: AppColors.muted,
                      ),
                    ),
                    for (var i = 0; i < _steps.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _steps[i],
                              style: const TextStyle(
                                fontSize: 14, 
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: AppButton(label: 'Lanjut verifikasi', onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const EtbOcrScreen()),
            );
          }),
        ),
      ),
    );
  }
}
