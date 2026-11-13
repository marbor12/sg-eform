import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_top_bar.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.title,
    this.step,
    this.total,
    required this.heading,
    required this.intro,
    required this.target,
    this.outro = '.',
    required this.changeLabel,
    required this.infoText,
    required this.onVerified,
  });

  final String title; // judul di top bar
  final int? step; // nomor langkah (null = tanpa progres)
  final int? total;
  final String heading; // judul besar
  final String intro; // kalimat sebelum bagian tebal
  final String target; // bagian tebal (email / nomor HP, sudah disamarkan)
  final String outro; // kalimat sesudah bagian tebal
  final String changeLabel; // 'Ganti email' / 'Ganti nomor'
  final String infoText; // isi kotak info
  final void Function(BuildContext context) onVerified;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const _length = 6;
  static const _sentinel = ' '; // isi tetap field tersembunyi
  static const _resendSeconds = 45;

  final _controller = TextEditingController(text: _sentinel);
  final _focusNode = FocusNode();
  final List<String> _digits = List.filled(_length, '');
  int _active = 0;

  int _secondsLeft = _resendSeconds;
  Timer? _timer;

  bool get _complete => _digits.every((d) => d.isNotEmpty);
  String get _code => _digits.join();

  String get _timeText {
    final mm = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final ss = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  void initState() {
    super.initState();
    _controller.selection = const TextSelection.collapsed(offset: 1);
    _focusNode.addListener(() => setState(() {}));
    // tangkap tombol Backspace langsung (keyboard fisik / web)
    _focusNode.onKeyEvent = (node, event) {
      if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.backspace) {
        _backspace();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    _secondsLeft = _resendSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) t.cancel();
      setState(() {
        _secondsLeft = _secondsLeft > 0 ? _secondsLeft - 1 : 0;
      });
    });
  }

  void _resetField() {
    _controller.value = const TextEditingValue(
      text: _sentinel,
      selection: TextSelection.collapsed(offset: 1),
    );
  }

  void _backspace() {
    setState(() {
      if (_digits[_active].isNotEmpty) {
        _digits[_active] = '';
      } else if (_active > 0) {
        _active--;
        _digits[_active] = '';
      }
    });
  }

  void _onChanged(String value) {
    if (value.isEmpty) {
      // tombol hapus lewat keyboard layar
      _backspace();
    } else {
      setState(() {
        // ambil angka saja (juga menangani paste beberapa angka)
        final typed = value.replaceAll(RegExp(r'\D'), '');
        for (final ch in typed.split('')) {
          _digits[_active] = ch;
          if (_active < _length - 1) {
            _active++;
          } else {
            break;
          }
        }
      });
    }
    _resetField();
  }

  void _showKeyboard() {
    if (_focusNode.hasFocus) {
      SystemChannels.textInput.invokeMethod('TextInput.show');
    } else {
      _focusNode.requestFocus();
    }
  }

  void _selectBox(int i) {
    setState(() => _active = i);
    _showKeyboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTopBar(
                title: widget.title,
                step: widget.step,
                total: widget.total,
              ),
              const SizedBox(height: 28),
              Text(
                widget.heading,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: AppColors.muted,
                  ),
                  children: [
                    TextSpan(text: widget.intro),
                    TextSpan(
                      text: widget.target,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    TextSpan(text: widget.outro),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _showKeyboard,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        for (var i = 0; i < _length; i++) ...[
                          if (i > 0) const SizedBox(width: 8),
                          Expanded(
                            child: _OtpBox(
                              digit: _digits[i],
                              active: _focusNode.hasFocus && i == _active,
                              onTap: () => _selectBox(i),
                            ),
                          ),
                        ],
                      ],
                    ),
                    // penangkap ketikan; klik ditangani oleh kotak di bawahnya
                    Positioned.fill(
                      child: IgnorePointer(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          enableSuggestions: false,
                          enableInteractiveSelection: false,
                          showCursor: false,
                          style: const TextStyle(color: Colors.transparent),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: _onChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _secondsLeft > 0
                      ? Text(
                          'Kirim ulang dalam $_timeText',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.muted,
                          ),
                        )
                      : GestureDetector(
                          onTap: () => setState(_startTimer),
                          child: const Text(
                            'Kirim ulang kode',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      widget.changeLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.soft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.infoText,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.55,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: AppButton(
            label: 'Verifikasi',
            // _code berisi 6 angka yang diketik (nanti dikirim ke server)
            onPressed: _complete ? () => widget.onVerified(context) : null,
          ),
        ),
      ),
    );
  }
}

/// Satu kotak OTP (tampilan saja).
class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.digit,
    required this.active,
    required this.onTap,
  });

  final String digit;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filled = digit.isNotEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active
                ? AppColors.accent
                : (filled ? AppColors.primary : AppColors.border),
            width: (active || filled) ? 2 : 1,
          ),
        ),
        child: filled
            ? Text(
                digit,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              )
            : (active ? const _BlinkingCursor() : null),
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _c,
      child: Container(width: 2, height: 24, color: AppColors.primary),
    );
  }
}