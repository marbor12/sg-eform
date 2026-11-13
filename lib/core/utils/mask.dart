import 'package:flutter/material.dart';

String maskEmail(String email) {
  final at = email.indexOf('@');
  if (at < 2) return email;
  return '${email.substring(0, 2)}•••••${email.substring(at)}';
}