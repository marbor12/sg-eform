import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'amount_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';

class RecipientScreen extends StatefulWidget {
  const RecipientScreen({super.key});

  @override
  State<RecipientScreen> createState() => _RecipientScreenState();
}

class _RecipientScreenState extends State<RecipientScreen> {
  bool _useSaved = true;

  final _accountCtrl = TextEditingController(text: '0123 4522 10');
  final _addressCtrl = TextEditingController();

  String _country = 'Indonesia (IDR)';
  String _bank = 'BNI (Bank Negara Indonesia)';
  String _relation = 'Keluarga — orang tua';
  String _sourceAccount = 'Savings SGD •••• 4182 - SGD 12,450.80';
  
  @override
  void dispose() {
    _accountCtrl.dispose();
    _addressCtrl.dispose();
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
              child: AppTopBar(title: 'Data penerima', step: 1, total: 3),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Penerima tersimpan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 72,
                            child: _RecipientOption(
                              title: 'Siti Rahma',
                              subtitle: 'BNI ••• 2210',
                              selected: _useSaved,
                              onTap: () => setState(() => _useSaved = true),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 72,
                            child: _NewRecipientOption(
                              selected: !_useSaved,
                              onTap: () => setState(() => _useSaved = false),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Isi manual',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppDropdown(
                      label: 'Negara tujuan',
                      value: _country,
                      items: const ['Indonesia (IDR)'],
                      onChanged: (v) => setState(() => _country = v),
                    ),
                    const SizedBox(height: 14),
                    AppDropdown(
                      label: 'Bank penerima',
                      value: _bank,
                      items: const ['BNI (Bank Negara Indonesia)'],
                      onChanged: (v) => setState(() => _bank = v),
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'No. rekening',
                      controller: _accountCtrl,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.soft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Nama terverifikasi: SITI RAHMA',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    AppDropdown(
                      label: 'Hubungan dengan penerima',
                      value: _relation,
                      items: const ['Keluarga — orang tua'],
                      onChanged: (v) => setState(() => _relation = v),
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Alamat penerima',
                      controller: _addressCtrl,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: AppButton(
                label: 'Lanjut',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AmountScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipientOption extends StatelessWidget {
  final String title;
  final String? subtitle; // boleh kosong
  final bool selected;
  final VoidCallback onTap;

  const _RecipientOption({
    required this.title,
    this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.soft : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.primary : AppColors.text,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.muted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NewRecipientOption extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _NewRecipientOption({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: const Radius.circular(8),
          color: AppColors.primary,
          strokeWidth: selected ? 2 : 1,
          dashPattern: const [5, 4],
          padding: EdgeInsets.zero,
        ),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(12),
          color: selected ? AppColors.soft : Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '+ Penerima baru',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Isi manual',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
