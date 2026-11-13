import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/mask.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_checkbox.dart';
import '../../core/widgets/app_text_field.dart';
import '../home/home_screen.dart';

class NtbPasswordScreen extends StatefulWidget {
  const NtbPasswordScreen({super.key, required this.email});

  final String email;

  @override
  State<NtbPasswordScreen> createState() => _NtbPasswordScreenState();
}

class _NtbPasswordScreenState extends State<NtbPasswordScreen> {
  
  static const _banned = ['weiling', '14031990', '1990'];

  final _pw = TextEditingController();
  final _pw2 = TextEditingController();
  bool _hide1 = true;
  bool _hide2 = true;
  bool _biometric = false;

  String get _p => _pw.text;

  bool get _okLength => _p.length >= 8;
  bool get _okMix =>
      RegExp(r'[A-Z]').hasMatch(_p) &&
      RegExp(r'[a-z]').hasMatch(_p) &&
      RegExp(r'\d').hasMatch(_p) &&
      RegExp(r'[^A-Za-z0-9]').hasMatch(_p);
  bool get _okNoPersonal =>
      _p.isNotEmpty && !_banned.any((w) => _p.toLowerCase().contains(w));
  bool get _match => _p.isNotEmpty && _p == _pw2.text;

  bool get _valid => _okLength && _okMix && _okNoPersonal && _match;

  @override
  void dispose() {
    _pw.dispose();
    _pw2.dispose();
    super.dispose();
  }

  Widget _eye(bool hidden, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Icon(
      hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      size: 20,
      color: AppColors.muted,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== BANNER HIJAU =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 22,
                      color: AppColors.success,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.success,
                          ),
                          children: [
                            TextSpan(
                              text: 'Rekening Anda sudah tervalidasi',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text:
                                  '\nSavings SGD •••• 4182 siap dipakai setelah password dibuat.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ===== JUDUL =====
              const Text(
                'Buat password',
                style: TextStyle(
                  fontSize: 24,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: AppColors.muted,
                  ),
                  children: [
                    const TextSpan(text: 'Untuk masuk ke aplikasi dengan email '),
                    TextSpan(
                      text: maskEmail(widget.email),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ===== ISIAN =====
              AppTextField(
                label: 'Password',
                controller: _pw,
                obscureText: _hide1,
                onChanged: (_) => setState(() {}),
                trailing: _eye(_hide1, () => setState(() => _hide1 = !_hide1)),
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Ulangi password',
                controller: _pw2,
                obscureText: _hide2,
                onChanged: (_) => setState(() {}),
                errorText: (_pw2.text.isNotEmpty && !_match)
                    ? 'Password belum sama'
                    : null,
                trailing: _eye(_hide2, () => setState(() => _hide2 = !_hide2)),
              ),
              const SizedBox(height: 14),

              // ===== SYARAT =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Rule(_okLength, 'Minimal 8 karakter'),
                    const SizedBox(height: 8),
                    _Rule(_okMix, 'Huruf besar, kecil, angka & simbol'),
                    const SizedBox(height: 8),
                    _Rule(_okNoPersonal, 'Tidak mengandung nama / tanggal lahir'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              AppCheckbox(
                value: _biometric,
                label: 'Aktifkan login biometrik',
                onChanged: (v) => setState(() => _biometric = v),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: AppButton(
            label: 'Simpan & masuk',
            onPressed: _valid
                ? () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    )
                : null,
          ),
        ),
      ),
    );
  }
}

/// Satu baris syarat: ✓ hijau kalau terpenuhi, ○ abu kalau belum.
class _Rule extends StatelessWidget {
  const _Rule(this.ok, this.text);

  final bool ok;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${ok ? '✓' : '○'} $text',
      style: TextStyle(
        fontSize: 13,
        fontWeight: ok ? FontWeight.w600 : FontWeight.w500,
        color: ok ? AppColors.success : AppColors.muted,
      ),
    );
  }
}