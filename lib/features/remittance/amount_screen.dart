import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';

class AmountScreen extends StatefulWidget {
  const AmountScreen({super.key});

  @override
  State<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  static const double _rate = 12000; // kurs contoh: 1 SGD = IDR 12,000
  static const double _fee = 10;

  final _amountCtrl = TextEditingController(text: '1,000.00');
  final _noteCtrl = TextEditingController(text: 'Kiriman Oktober');

  String _purpose = 'Biaya hidup keluarga';
  String _fundSource = 'Gaji';
  String _sourceAccount = 'Savings SGD •••• 4182 - SGD 12,450.80';

  double get _amount =>
      double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0;

  double get _estimate => _amount * _rate;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: AppTopBar(title: 'Nominal & tujuan', step: 2, total: 3),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      clipBehavior:
                          Clip.antiAlias, // strip ikut terpotong sudut bulat
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- bagian 1: Anda kirim ---
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Anda kirim',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.muted,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const _CurrencyChip('SGD'),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: _amountCtrl,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9.,]'),
                                          ),
                                        ],
                                        onChanged: (_) => setState(() {}),
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.text,
                                        ),
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // --- bagian 2: strip kurs & biaya ---
                          Container(
                            width: double.infinity,
                            color: AppColors.soft,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Kurs indikatif 1 SGD = IDR ${formatMoney(_rate, decimals: 0)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Biaya SGD ${formatMoney(_fee)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // --- bagian 3: Penerima terima ---
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Penerima terima (estimasi)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.muted,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const _CurrencyChip('IDR'),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        formatMoney(_estimate, decimals: 0),
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Kurs final ditetapkan saat transaksi diproses di Go Remit setelah approval.',
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                    const SizedBox(height: 16),
                    AppDropdown(
                      label: 'Tujuan pengiriman',
                      value: _purpose,
                      items: const ['Biaya hidup keluarga'],
                      onChanged: (v) => setState(() => _purpose = v),
                    ),
                    const SizedBox(height: 12),
                    AppDropdown(
                      label: 'Sumber dana',
                      value: _fundSource,
                      items: const ['Gaji'],
                      onChanged: (v) => setState(() => _fundSource = v),
                    ),
                    const SizedBox(height: 12),
                    AppDropdown(
                      label: 'Rekening sumber',
                      value: _sourceAccount,
                      items: const ['Savings SGD •••• 4182 - SGD 12,450.80'],
                      onChanged: (v) => setState(() => _sourceAccount = v),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      label: 'Berita (opsional)',
                      controller: _noteCtrl,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: AppButton(
                label: 'Lanjut ke ringkasan',
                onPressed: () {
                  // nanti: Navigator.push ke halaman Ringkasan (R3)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyChip extends StatelessWidget {
  final String code;
  const _CurrencyChip(this.code);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.soft,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _InfoRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.muted),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}
