import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/id_camera_frame.dart';

class NtbOcrScreen extends StatefulWidget {
  const NtbOcrScreen({super.key});

  @override
  State<NtbOcrScreen> createState() => _NtbOcrScreenState();
}

class _NtbOcrScreenState extends State<NtbOcrScreen> {
  final _name = TextEditingController(text: 'TAN WEI LING');
  final _id = TextEditingController(text: 'S•••••12A');
  final _dob = TextEditingController(text: '14/03/1990');
  final _nationality = TextEditingController(text: 'Singapore');
  final _address = TextEditingController(text: '[Alamat dari ID]');

  @override
  void dispose() {
    _name.dispose();
    _id.dispose();
    _dob.dispose();
    _nationality.dispose();
    _address.dispose();
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
              const AppTopBar(title: 'Verifikasi identitas', step: 1, total: 5),
              const SizedBox(height: 14),
              const IdCameraFrame(
                hint: 'Sisi depan terdeteksi · terbaca otomatis',
              ),
              const SizedBox(height: 14),

              // judul + lencana
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Hasil OCR — periksa & koreksi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successSoft,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Terbaca 98%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              AppTextField(label: 'Nama sesuai ID', controller: _name),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(label: 'NRIC / FIN', controller: _id),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppTextField(
                      label: 'Tanggal lahir',
                      controller: _dob,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AppTextField(label: 'Kewarganegaraan', controller: _nationality),
              const SizedBox(height: 14),
              AppTextField(label: 'Alamat', controller: _address),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
            bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: AppButton(
                  label: 'Scan ulang',
                  outlined: true,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kamera belum tersedia')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 14,
                child: AppButton(
                  label: 'Data sudah benar',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Halaman data diri belum dibuat')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
