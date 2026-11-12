import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/app_checkbox.dart';
import 'etb_success_screen.dart';

class EtbPasswordScreen extends StatefulWidget {
  final String email;

  const EtbPasswordScreen({super.key, required this.email});

  @override
  State<EtbPasswordScreen> createState() => _EtbPasswordScreenState();
}

class _EtbPasswordScreenState extends State<EtbPasswordScreen> {
  // password palsu untuk latihan; nanti diganti pemeriksaan server
  static const _dummyPassword = 'Contoh123!';

  final _passwordController = TextEditingController();
  bool _hidden = true;
  bool _biometric = false;
  bool _loading = false;
  int _fails = 0;
  String? _error;

  bool get _locked => _fails >= 3;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  String _maskEmail(String email) {
    final at = email.indexOf('@');
    if (at < 2) return email;
    return '${email.substring(0, 2)}•••••${email.substring(at)}';
  }

  Future<void> _submit() async {
    // 1. nyalakan spinner (jangan hitung apa-apa dulu)
    setState(() => _loading = true);

    // 2. pura-pura menunggu server
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    // 3. password benar: reset hitungan lalu pindah halaman
    if (_passwordController.text == _dummyPassword) {
      setState(() {
        _loading = false;
        _fails = 0;
        _error = null;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EtbSuccessScreen()),
      );
      return;
    }

    // 4. password salah: hitung SEKALI saja
    setState(() {
      _loading = false;
      _fails++;
      if (_locked) _passwordController.clear();
      _error = _locked
          ? 'Akun terkunci sementara. Silakan reset password.'
          : 'Password salah (${3 - _fails} percobaan tersisa).';
    });
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
              const AppTopBar(title: 'Masukkan password', step: 3, total: 3),
              const SizedBox(height: 16),
              const Text(
                'Halo, Wei Ling',
                style: TextStyle(
                  fontSize: 24,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: AppColors.muted,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'Masukkan password akun BNI Singapore yang sudah Anda miliki untuk ',
                    ),
                    TextSpan(
                      text: _maskEmail(widget.email),
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
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.55,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: _hidden,
                enabled: !_locked,
                onChanged: (_) {
                  setState(() {
                    if (!_locked) _error = null;
                  });
                },
                decoration: InputDecoration(
                  errorText: _error,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.muted,
                    ),
                    onPressed: () => setState(() => _hidden = !_hidden),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // petunjuk sementara untuk latihan, hapus nanti
              const Text(
                'Password latihan: Contoh123!',
                style: TextStyle(fontSize: 11, color: AppColors.muted),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Halaman reset password belum dibuat'),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Lupa password?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                  'Maksimal 3 kali salah. Setelah itu akun akan terkunci sementara dan perlu reset password.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.55,
                    color: AppColors.text,
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: AppButton(
            label: 'Masuk',
            loading: _loading,
            onPressed:
                (_passwordController.text.isEmpty || _locked) ? null : _submit,
          ),
        ),
      ),
    );
  }
}