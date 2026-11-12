import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'features/entry/email_screen.dart';
import 'features/home/home_screen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EmailScreen(),
  ));
}

