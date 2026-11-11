import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class IconCircle extends StatelessWidget {
  const IconCircle({
    super.key,
    required this.icon,
    this.color = AppColors.primary,
    this.background = AppColors.soft,
    this.size = 88,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: size * 0.45),
    );
  }
}