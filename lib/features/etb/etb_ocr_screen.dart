import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_top_bar.dart';
import 'etb_liveness_screen.dart';

class EtbOcrScreen extends StatelessWidget {
  const EtbOcrScreen({super.key});

  static const _rows = [
    ['Nama', 'TAN WEI LING'],
    ['NRIC / FIN', 'S•••••12A'],
    ['Tanggal lahir', '14/03/1990'],
    ['CIF', '10•••418'],
  ];

  // garis tebal 8 untuk siluet kartu ID
  Widget _bar(double widthFactor, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTopBar(title: 'Verifikasi identitas', step: 1, total: 3),
              const SizedBox(height: 24),

              // 1. area kamera (placeholder)
              Container(
                height: 210,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.text,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        color: const Color(0x8CFFFFFF),
                        strokeWidth: 2,
                        dashPattern: const [6, 4],
                        radius: const Radius.circular(10),
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: 260,
                        height: 156,
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 62,
                                  height: 78,
                                  decoration: BoxDecoration(
                                    color: const Color(0x29FFFFFF),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Column(
                                      children: [
                                        _bar(0.8, const Color(0x4DFFFFFF)),
                                        const SizedBox(height: 8),
                                        _bar(0.6, const Color(0x4DFFFFFF)),
                                        const SizedBox(height: 8),
                                        _bar(0.7, const Color(0x4DFFFFFF)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _bar(0.9, const Color(0x38FFFFFF)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Posisikan NRIC / FIN di dalam bingkai',
                      style: TextStyle(color: Color(0xD9FFFFFF), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 2. banner kecocokan data
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.successSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle,
                        size: 20, color: AppColors.success),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cocok dengan data nasabah (CIF)',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                            ),
                          ),
                          Text(
                            'Nama, NRIC dan tanggal lahir sesuai.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 3. data nasabah
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < _rows.length; i++)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: i == _rows.length - 1
                              ? null
                              : const Border(
                                  bottom: BorderSide(color: AppColors.soft),
                                ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _rows[i][0],
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.muted,
                              ),
                            ),
                            Text(
                              _rows[i][1],
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 4. catatan kecil
              const Text(
                'Jika data tidak cocok, aktivasi dialihkan ke cabang.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: AppButton(
            label: 'Lanjut',
            onPressed: () {
              Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const EtbLivenessScreen()),
            );
            },
          ),
        ),
      ),
    );
  }
}