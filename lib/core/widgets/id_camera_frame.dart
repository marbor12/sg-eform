import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';

class IdCameraFrame extends StatelessWidget {
  final String hint;

  const IdCameraFrame({super.key, required this.hint});

  Widget _bar(double widthFactor, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.text,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: const Color(0x8CFFFFFF),
              strokeWidth: 2,
              dashPattern: const [6, 4],
              radius: const Radius.circular(10),
              padding: EdgeInsets.zero,
            ),
            child: Container(
              width: 260,
              height: 156,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 62,
                        height: 78,
                        decoration: BoxDecoration(
                          color: const Color(0x29FFFFFF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            children: [
                              _bar(0.8, const Color(0x4DFFFFFF)),
                              const SizedBox(height: 8),
                              _bar(0.6, const Color(0x4DFFFFFF)),
                              const SizedBox(height: 8),
                              _bar(0.7, const Color(0x4DFFFFFF)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _bar(0.9, const Color(0x38FFFFFF)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Posisikan NRIC / FIN di dalam bingkai',
            style: TextStyle(color: Color(0xD9FFFFFF), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
