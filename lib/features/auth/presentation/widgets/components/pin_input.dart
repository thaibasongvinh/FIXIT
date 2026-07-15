import 'package:flutter/material.dart';
import 'package:fixit/shared/widgets/inputs/otp_input.dart';
import '../figma_auth_widgets.dart';

class FigmaAuthPINInput extends StatelessWidget {
  const FigmaAuthPINInput({
    super.key,
    required this.onChanged,
    this.length = 6,
    this.darkTheme = true,
  });

  final ValueChanged<String> onChanged;
  final int length;
  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    return OtpInput(
      onChanged: onChanged,
      length: length,
      primaryColor: Colors.blueAccent,
      darkTheme: darkTheme,
    );
  }
}
