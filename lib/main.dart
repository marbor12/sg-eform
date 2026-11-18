import 'dart:ui' show PointerDeviceKind;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sg_eform/features/entry/email_screen.dart';
import 'core/theme/app_colors.dart';
import 'features/entry/email_screen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    cameras = await availableCameras();
  } catch (_) {
    cameras = []; // perangkat tanpa kamera atau izin ditolak
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor:
              Colors.transparent, // Background pembungkus jadi transparan
          elevation: 0, // Menghilangkan bayangan/shadow
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surface: Colors.white,
        ),
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      home: const EmailScreen(),
    ),
  );
}
