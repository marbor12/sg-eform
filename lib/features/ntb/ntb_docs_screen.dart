import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_checkbox.dart';
import '../../core/widgets/app_choice.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_top_bar.dart';
import 'ntb_waiting_screen.dart';

class NtbDocsScreen extends StatefulWidget {
  const NtbDocsScreen({super.key});

  @override
  State<NtbDocsScreen> createState() => _NtbDocsScreenState();
}

class _NtbDocsScreenState extends State<NtbDocsScreen> {
  final _country = TextEditingController(text: 'Singapore');
  final _tin = TextEditingController(text: '= NRIC');

  bool _sowUploaded = false;
  int _fatca = 1;
  bool _signed = false;
  bool get _canSubmit => _sowUploaded && _signed;

  @override
  void dispose() {
    _country.dispose();
    _tin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(title: 'Dokumen pendukung', step: 5, total: 5),
              const SizedBox(height: 18),

              // ===== DOKUMEN =====
              const _DocRow(
                title: 'Fotocopy ID (NRIC)',
                subtitle: 'Dari scan OCR',
              ),
              const SizedBox(height: 10),
              const _DocRow(
                title: 'Bukti alamat',
                subtitle: 'utility_bill_sep.pdf · 412 KB',
              ),
              const SizedBox(height: 10),
              _DocRow(
                title: 'SOW / Slip gaji',
                subtitle: _sowUploaded
                    ? 'slip_gaji_okt.pdf · 1.2 MB'
                    : 'PDF / JPG, maks 5 MB',
                done: _sowUploaded,
                // simulasi unggah; nanti diganti pemilih file sungguhan
                onUpload: () => setState(() => _sowUploaded = true),
              ),
              const SizedBox(height: 18),

              const Text(
                'Deklarasi pajak',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'FATCA — Apakah Anda US person?',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: AppChoice(
                      label: 'Ya',
                      selected: _fatca == 0,
                      onTap: () => setState(() => _fatca = 0),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppChoice(
                      label: 'Tidak',
                      selected: _fatca == 1,
                      onTap: () => setState(() => _fatca = 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'CRS · Negara pajak',
                      controller: _country,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppTextField(label: 'TIN', controller: _tin),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AppCheckbox(
                value: _signed,
                label:
                    'Saya menandatangani Indemnity form dan form KYC secara elektronik.',
                onChanged: (v) => setState(() => _signed = v),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: AppButton(
            label: 'Kirim pengajuan',
            onPressed: _canSubmit
                ? () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const NtbWaitingScreen()),
                    (route) => false,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _DocRow extends StatelessWidget {
  const _DocRow({
    required this.title,
    required this.subtitle,
    this.done = true,
    this.onUpload,
  });

  final String title;
  final String subtitle;
  final bool done;
  final VoidCallback? onUpload;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Icon(
          done ? Icons.check_circle_outline : Icons.upload_outlined,
          size: 20,
          color: done ? AppColors.success : AppColors.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
        if (!done)
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: onUpload,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Unggah',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
      ],
    );

    // sudah terunggah: garis tepi biasa
    if (done) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: content,
      );
    }

    // belum: garis putus-putus biru, latar abu muda
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: AppColors.primary,
        strokeWidth: 1,
        dashPattern: const [4, 3],
        radius: const Radius.circular(8),
        padding: EdgeInsets.zero,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: content,
      ),
    );
  }
}
