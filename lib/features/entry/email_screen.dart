import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'otp_screen.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_checkbox.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  bool _agree = false;
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _emailValid => _emailController.text.contains('@');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 12, height: 12, color: AppColors.accent),
                  const SizedBox(width: 10),
                  const Text(
                    'BNI',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Singapore Branch',
                    style: TextStyle(fontSize: 13, color: AppColors.muted),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              const Text(
                'Selamat datang',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Masukkan email Anda. Kami akan cek apakah Anda sudah menjadi nasabah BNI Singapore atau nasabah baru.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.muted,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (_) {
                  setState(() {});
                },
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'weiling.tan@email.com',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    color: AppColors.muted,
                  ),
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
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Kode OTP 6 digit akan dikirim ke email ini.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.muted,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppCheckbox(
                value: _agree,
                label: 'Saya menyetujui Syarat & Ketentuan serta pemrosesan data pribadi (PDPA)',
                onChanged: (v) => setState(() => _agree = v),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (_agree && _emailValid)
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                OtpScreen(email: _emailController.text),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.muted,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Kirim Kode OTP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
