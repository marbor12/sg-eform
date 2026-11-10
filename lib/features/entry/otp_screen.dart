import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_top_bar.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.email});

  final String email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // weiling.tan@email.com -> we•••••@email.com
  String _maskEmail(String email) {
    final at = email.indexOf('@');
    if (at < 2) return email;
    return '${email.substring(0, 2)}•••••${email.substring(at)}';
  }

  @override
  Widget build(BuildContext context) {
    final text = _otpController.text;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTopBar(title: 'Verifikasi email'),
              const SizedBox(height: 28),
              const Text(
                'Masukkan kode OTP',
                style: TextStyle(
                  fontSize: 24,
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
                    const TextSpan(text: 'Kode dikirim ke '),
                    TextSpan(
                      text: _maskEmail(widget.email),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const TextSpan(text: '. Berlaku 5 menit.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _focusNode.requestFocus(),
                child: Stack(
                  children: [
                    // 6 kotak (hanya tampilan)
                    Row(
                      children: List.generate(6, (i) {
                        final filled = i < text.length;
                        final active = i == text.length;

                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: i == 0 ? 0 : 8),
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: filled
                                    ? AppColors.primary
                                    : (active
                                        ? AppColors.accent
                                        : AppColors.border),
                                width: (filled || active) ? 2 : 1,
                              ),
                            ),
                            child: Text(
                              filled ? text[i] : '',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    // field tak terlihat yang menerima ketikan
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0,
                        child: TextField(
                          controller: _otpController,
                          focusNode: _focusNode,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}