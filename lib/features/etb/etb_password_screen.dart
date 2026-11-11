import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_top_bar.dart';

class EtbPasswordScreen extends StatefulWidget {
  final String email;

  const EtbPasswordScreen({super.key, required this.email});

  @override
  State<EtbPasswordScreen> createState() => _EtbPasswordScreenState();
}

class _EtbPasswordScreenState extends State<EtbPasswordScreen> {
  final _passwordController = TextEditingController();
  bool _hidden = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTopBar(title: 'Masukkan password', step: 3, total: 3),
              const SizedBox(height: 24),
              Text(
                'Halo, ${'Nama'}',
                style: const TextStyle(
                  fontSize: 24,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
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
            label: 'Masuk',
            onPressed: _passwordController.text.isNotEmpty ? null : () {},
          ),
        ),
      ),
    );
  }
}
