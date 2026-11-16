import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'features/entry/email_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      home: const EmailScreen(),
    ),
  );
}