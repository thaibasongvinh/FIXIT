import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    required this.onChanged,
    this.length = 6,
    this.primaryColor = const Color(0xFF005CB7),
    this.darkTheme = true, // Mặc định dùng cho giao diện tối
  });

  final ValueChanged<String> onChanged;
  final int length;
  final Color primaryColor;
  final bool darkTheme;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (index) {
      final node = FocusNode();
      node.addListener(() {
        if (mounted) setState(() {});
      });
      return node;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = widget.darkTheme ? Colors.white : Colors.black87;
    final Color borderColor = widget.darkTheme ? Colors.white.withOpacity(0.3) : Colors.black12;
    final Color focusedBorderColor = widget.darkTheme ? Colors.white : widget.primaryColor;
    final Color fillColor = widget.darkTheme ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.05);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return Container(
          width: 50,
          height: 60,
          decoration: BoxDecoration(
            boxShadow: [
              if (_focusNodes[index].hasFocus && widget.darkTheme)
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
            ],
          ),
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            cursorColor: textColor,
            autofocus: index == 0,
            keyboardType: const TextInputType.numberWithOptions(),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            onChanged: (value) {
              if (value.isNotEmpty && index < widget.length - 1) {
                _focusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
              widget.onChanged(_controllers.map((c) => c.text).join());
            },
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: borderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: focusedBorderColor,
                  width: 2.5,
                ),
              ),
              fillColor: fillColor,
              filled: true,
            ),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        );
      }),
    );
  }
}
