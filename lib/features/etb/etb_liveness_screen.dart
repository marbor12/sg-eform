import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/app_text_field.dart';
import 'etb_password_screen.dart';

class EtbLivenessScreen extends StatelessWidget {
  const EtbLivenessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.text,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: AppTopBar(
                title: 'Verifikasi wajah',
                step: 2,
                total: 3,
                dark: true,
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const EtbPasswordScreen(email: 'user@example.com'),
                            ),
                          );
                        },
                        child: Container(
                          width: 280,
                          height: 280,
                          clipBehavior: Clip.antiAlias,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0x0DFFFFFF),
                            border: Border.all(
                              color: const Color(0xFF4FB3A9),
                              width: 4,
                            ),
                          ),
                          child: CustomPaint(
                            size: const Size(120, 140),
                            painter: _FacePainter(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Toleh ke kiri perlahan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 280),
                        child: Text(
                          'Wajah dicocokkan dengan foto di NRIC dan data nasabah.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xBFFFFFFF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Pill('Hadap depan ✓', done: true),
                          SizedBox(width: 8),
                          _Pill('Kedip ✓', done: true),
                          SizedBox(width: 8),
                          _Pill('Toleh kiri', done: false),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Text(
                'Nasabah existing: tidak perlu validasi cabang bila face match lolos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: Color(0xB3FFFFFF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Label kecil status langkah liveness.
class _Pill extends StatelessWidget {
  const _Pill(this.label, {required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: done ? const Color(0x384FB3A9) : const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: done ? const Color(0xFFBFEAE4) : Colors.white,
        ),
      ),
    );
  }
}

/// Siluet kepala dan bahu (ukuran gambar 120 x 140).
class _FacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x73FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // kepala
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(60, 58), width: 72, height: 88),
      paint,
    );

    // bahu
    final shoulders = Path()
      ..moveTo(14, 140)
      ..relativeCubicTo(4, -26, 22, -38, 46, -38)
      ..relativeCubicTo(24, 0, 42, 12, 46, 38);
    canvas.drawPath(shoulders, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}