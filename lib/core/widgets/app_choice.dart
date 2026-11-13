import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppChoice extends StatelessWidget {
  final String label;
  final  bool selected;
  final VoidCallback onTap;

  const AppChoice({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.soft : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? AppColors.primary : AppColors.text,
          ),
        ),
      )
    );
  }
}