import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../data/dummy.dart';
import '../../core/widgets/tx_row.dart';
import '../../core/widgets/app_button.dart';

class MutasiScreen extends StatefulWidget {
  const MutasiScreen({super.key});

  @override
  State<MutasiScreen> createState() => _MutasiScreenState();
}

class _MutasiScreenState extends State<MutasiScreen> {
  int _filter = 0; // 0 = 7 hari, 1 = 30 hari, 2 = pilih tanggal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: AppTopBar(title: 'Mutasi · SGD •••• 4182'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _FilterChip(
                    label: '7 hari',
                    selected: _filter == 0,
                    onTap: () => setState(() => _filter = 0),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: '30 hari',
                    selected: _filter == 1,
                    onTap: () => setState(() => _filter = 1),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Pilih tanggal',
                    selected: _filter == 2,
                    onTap: () => setState(() => _filter = 2),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: _SummaryBox(
                      label: 'Uang masuk',
                      value: 'SGD 6,800.00',
                      valueColor: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: _SummaryBox(
                      label: 'Uang keluar',
                      value: 'SGD 1,349.20',
                      valueColor: AppColors.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: [
                    for (final m in dummyMutasi) ...[
                      if (m.day != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 4),
                          child: Text(
                            m.day!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.muted,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                      TxRow(
                        title: m.title,
                        subtitle: m.desc,
                        amount: m.amount,
                        isIncome: m.isIncome,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: AppButton(
          label: 'Unduh e-statement (PDF)',
          outlined: true,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fitur unduh belum tersedia')),
            );
          },
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: selected ? null : Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? Colors.white : AppColors.text,
          ),
        ),
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _SummaryBox({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.soft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
