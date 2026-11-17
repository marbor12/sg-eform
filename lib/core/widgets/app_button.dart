import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AppButtonVariant { filled, outlinePrimary, outlineNeutral }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined; // lama: outlined: true = outlinePrimary
  final AppButtonVariant variant;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.outlined = false,
    this.variant = AppButtonVariant.filled,
  });

  @override
  Widget build(BuildContext context) {
    // outlined: true di halaman lama dianggap outlinePrimary
    final v = outlined ? AppButtonVariant.outlinePrimary : variant;
    final isOutline = v != AppButtonVariant.filled;
    final neutral = v == AppButtonVariant.outlineNeutral;

    // ===== VARIASI GARIS TEPI =====
    if (isOutline) {
      final borderColor = neutral ? AppColors.border : AppColors.primary;
      final textColor = neutral ? AppColors.text : AppColors.primary;

      return SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: textColor,
            side: BorderSide(color: borderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }

    // ===== VARIASI PENUH (primary) =====
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              loading ? AppColors.primary : AppColors.muted,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}