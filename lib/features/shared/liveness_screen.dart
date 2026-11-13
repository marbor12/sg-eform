import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_top_bar.dart';

enum PillState { done, current, todo }

/// Data satu label langkah liveness.
class LivenessPill {
  final String label;
  final PillState state;

  const LivenessPill(this.label, this.state);
}

class LivenessScreen extends StatelessWidget {
  const LivenessScreen({
    super.key,
    required this.step,
    required this.total,
    required this.title,
    required this.subtitle,
    required this.pills,
    required this.footer,
    required this.onPassed,
  });

  final int step;
  final int total;
  final String title;
  final String subtitle;
  final List<LivenessPill> pills;
  final String footer;
  final void Function(BuildContext context) onPassed;

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
                step: step,
                total: total,
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
                      // TODO: ganti dengan hasil SDK liveness. Sementara,
                      // ketuk lingkaran untuk mensimulasikan lolos.
                      GestureDetector(
                        onTap: () => onPassed(context),
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
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xBFFFFFFF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < pills.length; i++) ...[
                            if (i > 0) const SizedBox(width: 8),
                            _Pill(pills[i]),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Text(
                footer,
                textAlign: TextAlign.center,
                style: const TextStyle(
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

/// Label kecil status langkah liveness (3 keadaan).
class _Pill extends StatelessWidget {
  const _Pill(this.data);

  final LivenessPill data;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    switch (data.state) {
      case PillState.done:
        bg = const Color(0x384FB3A9); // tosca 22%
        fg = const Color(0xFFBFEAE4);
      case PillState.current:
        bg = const Color(0x1FFFFFFF); // putih 12%
        fg = Colors.white;
      case PillState.todo:
        bg = const Color(0x14FFFFFF); // putih 8%
        fg = const Color(0xB3FFFFFF); // putih 70%
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        data.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
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