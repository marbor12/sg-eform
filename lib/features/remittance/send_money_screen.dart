import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_top_bar.dart';

class SendMoneyScreen extends StatelessWidget {
  const SendMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // baris atas (Back + judul)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: AppTopBar(title: 'Kirim uang'),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.soft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Isi halaman Kirim uang di sini.',
                        style: TextStyle(fontSize: 13, color: AppColors.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // tombol bawah
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: AppButton(
                label: 'Lanjut',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Belum tersambung')),
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