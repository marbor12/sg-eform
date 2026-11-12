import 'package:flutter/material.dart';
import 'package:sg_eform/features/home/home_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/icon_circle.dart';

class EtbSuccessScreen extends StatelessWidget {
  const EtbSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(                       // tanpa const
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 120, 28, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // sesuaikan nama parameter dengan icon_circle.dart-mu
              IconCircle(
                icon: Icons.check,
                color: Colors.white,
                background: AppColors.primary,
                size: 96,// warna latar primary, ikon putih, ukuran 96
              ),
              const SizedBox(height: 16),
              const Text(
                'Aplikasi siap dipakai',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Perangkat ini sudah terdaftar dan rekening Anda terhubung. '
                'Anda bisa cek saldo dan mengajukan eForm remittance.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 28),
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Savings SGD',
                      style: TextStyle(fontSize: 13, color: AppColors.muted),
                    ),
                    Text(
                      '•••• 4182',
                      style: TextStyle(
                        fontSize: 13,
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
            label: 'Masuk ke beranda',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}