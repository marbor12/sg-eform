import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_checkbox.dart';
import '../entry/otp_screen.dart';
import '../remittance/remittance_status_screen.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _agreed = false;

  static const _rows = [
    ['Pengirim', 'TAN WEI LING'],
    ['Rekening sumber', 'Savings SGD •••• 4182'],
    ['Penerima', 'SITI RAHMA'],
    ['Bank / rekening', 'BNI · 0123 4522 10'],
    ['Nominal', 'SGD 1,000.00'],
    ['Biaya', 'SGD 10.00'],
    ['Tujuan', 'Biaya hidup keluarga'],
    ['Sumber dana', 'Gaji'],
  ];

  void _submit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          title: 'Verifikasi OTP',
          heading: 'Masukkan kode SMS',
          intro: 'Kode 6 digit dikirim via SMS ke ',
          target: '+65 9••• ••21',
          changeLabel: 'Ganti nomor',
          infoText:
              'OTP dipakai untuk mengonfirmasi pengajuan eForm remittance.',
          onVerified: (ctx) {
            Navigator.pushAndRemoveUntil(
              ctx,
              MaterialPageRoute(builder: (_) => const RemittanceStatusScreen()),
              (route) => false, 
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: AppTopBar(title: 'Ringkasan eForm', step: 3, total: 3),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ===== TOTAL (tengah, tanpa kotak) =====
                    const Center(
                      child: Text(
                        'Total didebet',
                        style: TextStyle(fontSize: 13, color: AppColors.muted),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Center(
                      child: Text(
                        'SGD 1,010.00',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ===== KARTU RINGKASAN =====
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          for (var i = 0; i < _rows.length; i++)
                            _SummaryLine(
                              label: _rows[i][0],
                              value: _rows[i][1],
                              isLast: i == _rows.length - 1,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.soft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: AppColors.soft,
                          ),
                          children: [
                            TextSpan(
                              text: 'eForm akan ',
                              style: TextStyle(color: AppColors.text),
                            ),
                            TextSpan(
                              text: 'divalidasi petugas cabang',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.text,
                              ),
                            ),
                            TextSpan(
                              text:
                                ' (verifikasi dan screening) lalu di-release supervisor. Dana di-hold sampai keputusan.',
                                style: TextStyle(color: AppColors.text),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ===== CHECKBOX =====
                    AppCheckbox(
                      value: _agreed,
                      onChanged: (v) => setState(() => _agreed = v),
                      label:
                          'Saya menyatakan data benar dan dana bukan hasil tindak pidana.',
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: AppButton(
                label: 'Ajukan dengan OTP',
                onPressed: _agreed ? _submit : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _SummaryLine({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}