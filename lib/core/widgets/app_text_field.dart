import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? trailing;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.trailing,
    this.errorText,
    this.onChanged,
  });

  OutlineInputBorder _border(Color color, double width) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color, width: width),
  );

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
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 15,
            color: readOnly ? AppColors.muted : AppColors.text,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: readOnly,
            fillColor: AppColors.bg,
            errorText: errorText,
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
            border: _border(AppColors.border, 1),
            enabledBorder: _border(AppColors.border, 1),
            focusedBorder: readOnly
                ? _border(AppColors.border, 1)
                : _border(AppColors.primary, 2),
            errorBorder: _border(AppColors.error, 1),
            focusedErrorBorder: _border(AppColors.error, 2),
          ),
        ),
      ],
    );
  }
}