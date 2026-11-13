import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_top_bar.dart';
import '../entry/otp_screen.dart';
import '../shared/liveness_screen.dart';
import '../../core/widgets/app_choice.dart';
import 'ntb_docs_screen.dart';

class NtbProfileScreen extends StatefulWidget {
  const NtbProfileScreen({super.key});

  @override
  State<NtbProfileScreen> createState() => _NtbProfileScreenState();
}

class _NtbProfileScreenState extends State<NtbProfileScreen> {
  static const _jobs = [
    'Karyawan swasta',
    'Wiraswasta',
    'Professional',
    'Lainnya',
  ];
  static const _incomes = [
    '< SGD 2k',
    'SGD 2k - 5k',
    'SGD 5k - 10k',
    '> SGD 10k',
  ];
  static const _sources = ['Gaji', 'Usaha', 'Tabungan', 'Lainnya'];
  static const _purposes = [
    'Tabungan & remitansi ke Indonesia',
    'Transaksi harian',
    'Lainnya',
  ];
  static const _products = ['Savings SGD', 'Savings USD', 'Giro'];

  final _email = TextEditingController(text: 'weiling.tan@email.com');
  final _phone = TextEditingController(text: '+65 9123 4521');

  String _job = 'Karyawan swasta';
  String _income = 'SGD 5k - 10k';
  String _source = 'Gaji';
  String _purpose = 'Tabungan & remitansi ke Indonesia';
  int _product = 0;

  @override
  void dispose() {
    _email.dispose();
    _phone.dispose();
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
              const AppTopBar(title: 'Data diri', step: 2, total: 5),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.soft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Nama, NRIC dan tanggal lahir terisi dari OCR. Email dari langkah awal.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.55,
                    color: AppColors.muted,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Email',
                controller: _email,
                readOnly: true,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successSoft,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Terverifikasi',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'No. HP',
                controller: _phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppDropdown(
                      label: 'Pekerjaan',
                      value: _job,
                      items: _jobs,
                      onChanged: (v) => setState(() => _job = v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppDropdown(
                      label: 'Penghasilan / bln',
                      value: _income,
                      items: _incomes,
                      onChanged: (v) => setState(() => _income = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AppDropdown(
                label: 'Sumber dana (SOW)',
                value: _source,
                items: _sources,
                onChanged: (v) => setState(() => _source = v),
              ),
              const SizedBox(height: 14),
              AppDropdown(
                label: 'Tujuan pembukaan rekening',
                value: _purpose,
                items: _purposes,
                onChanged: (v) => setState(() => _purpose = v),
              ),
              const SizedBox(height: 14),
              const Text(
                'Produk',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (var i = 0; i < _products.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    AppChoice(
                      label: _products[i],
                      selected: _product == i,
                      onTap: () => setState(() => _product = i),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: AppButton(
            label: 'Kirim OTP ke No. HP',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OtpScreen(
                  title: 'Verifikasi No. HP',
                  step: 3,
                  total: 5,
                  heading: 'Masukkan kode SMS',
                  intro: 'Kode 6 digit dikirim via SMS ke ',
                  target: '+65 9••• ••21',
                  changeLabel: 'Ganti nomor',
                  infoText:
                      'No. HP terverifikasi dipakai untuk OTP transaksi dan notifikasi status pengajuan.',
                  onVerified: (ctx) => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => LivenessScreen(
                        step: 4,
                        total: 5,
                        title: 'Kedipkan mata perlahan',
                        subtitle:
                            'Pastikan wajah di dalam bingkai, cahaya cukup, dan tanpa kacamata gelap.',
                        pills: const [
                          LivenessPill('Hadap depan ✓', PillState.done),
                          LivenessPill('Kedip', PillState.current),
                          LivenessPill('Toleh kiri', PillState.todo),
                        ],
                        footer:
                            'Foto wajah dicocokkan dengan foto di NRIC (face match). Hasil dikirim ke back office untuk ditinjau.',
                        onPassed: (ctx2) => Navigator.push(
                          ctx2,
                          MaterialPageRoute(builder: (_) => const NtbDocsScreen()),
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
