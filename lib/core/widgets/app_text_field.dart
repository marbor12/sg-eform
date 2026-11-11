import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.obscure = false,
    this.suffix,
    this.errorText,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final bool obscure;
  final Widget? suffix;
  final String? errorText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        
      ],
    );
  }
}