import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.step,
    this.total,
    this.dark = false,
  });

  final String title;
  final int? step;
  final int? total;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Colors.white : AppColors.text;
    final subColor = dark ? const Color(0xB3FFFFFF) : AppColors.muted;
    final track = dark ? const Color(0x26FFFFFF) : AppColors.soft;
    final hasStep = step != null && total != null;

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 48,
              child: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: Icon(Icons.chevron_left, size: 28, color: fg),
              ),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ),
            SizedBox(
              width: 48,
              child: hasStep
                  ? Text(
                      '$step/$total',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: subColor,
                      ),
                    )
                  : null,
            ),
          ],
        ),
        if (hasStep) ...[
          const SizedBox(height: 8),
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: track,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: step! / total!,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}