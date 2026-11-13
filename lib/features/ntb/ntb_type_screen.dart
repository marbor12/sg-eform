import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_top_bar.dart';
import 'ntb_ocr_screen.dart';

class NtbTypeScreen extends StatefulWidget {
  const NtbTypeScreen({super.key});

  @override
  State<NtbTypeScreen> createState() => _NtbTypeScreenState();
}

class _NtbTypeScreenState extends State<NtbTypeScreen> {
  int _type = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(title: 'Buka rekening'),
              const SizedBox(height: 16),
              Text(
                'Buka rekening tanpa ke cabang',
                style: TextStyle(
                  fontSize: 26,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Isi form, verifikasi identitas, dan unggah dokumen dari HP. Keputusan pembukaan rekening dilakukan oleh petugas BNI Singapore.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Saya mendaftar sebagai',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),

              const SizedBox(height: 16),
              _TypeOption(
                title: 'Nasabah perorangan',
                desc: 'NRIC / FIN atau paspor, bukti alamat, SOW / slip gaji',
                selected: _type == 0,
                onTap: () => setState(() => _type = 0),
              ),
              const SizedBox(height: 16),
              _TypeOption(
                title: 'Nasabah korporat',
                desc: 'Dokumen legal, board resolution, UBO, ID pengurus',
                selected: _type == 1,
                onTap: () => setState(() => _type = 1),
              ),
              const SizedBox(height: 20),
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIAPKAN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.muted,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'NRIC / FIN · Bukti alamat · Slip gaji / SOW · Data pajak (FATCA & CRS)',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.6,
                        color: AppColors.text,
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
          child: AppButton(
            label: 'Mulai',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NtbOcrScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TypeOption extends StatelessWidget {
  final String title;
  final String desc;
  final bool selected;
  final VoidCallback onTap;

  const _TypeOption({
    required this.title,
    required this.desc,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.soft : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.white : null, // <- tambah
                border: Border.all(
                  color: selected ? AppColors.primary : const Color(0xFF9DB5BA),
                  width: selected ? 6 : 2,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
