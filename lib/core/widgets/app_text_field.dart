import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Widget? trailing; 

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.keyboardType,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 15,
            color: readOnly ? AppColors.muted : AppColors.text,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: readOnly,
            fillColor: AppColors.bg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            suffixIcon: trailing == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: trailing,
                  ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: readOnly ? AppColors.border : AppColors.primary,
                width: readOnly ? 1 : 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}