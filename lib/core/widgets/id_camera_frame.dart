import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'live_camera.dart';

class IdCameraFrame extends StatelessWidget {
  final String hint;
  final void Function(CameraController)? onCameraReady;

  const IdCameraFrame({
    super.key, 
    required this.hint,
    this.onCameraReady,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      width: double.infinity,
      clipBehavior: Clip.antiAlias, 
      decoration: BoxDecoration(
        color: AppColors.text,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          LiveCamera(lens: CameraLensDirection.back, onReady: onCameraReady),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  color: const Color(0xB3FFFFFF),
                  strokeWidth: 2,
                  dashPattern: const [6, 4],
                  radius: const Radius.circular(10),
                  padding: EdgeInsets.zero,
                ),
                child: const SizedBox(width: 260, height: 156),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x66000000),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  hint,
                  style: const TextStyle(
                    color: Color(0xD9FFFFFF),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}