import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? label;
  final bool isPassword;
  final bool obscure;
  final VoidCallback? onToggleVisibility;
  final String? Function(String?)? validator;

  final bool darkTheme;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Function(String)? onChanged;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.label,
    this.isPassword = false,
    this.obscure = false,
    this.onToggleVisibility,
    this.validator,
    this.darkTheme = false,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
    this.autofillHints,
    this.textInputAction,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        widget.darkTheme ? Colors.white : const Color(0xFF424242);
    final Color hintColor = widget.darkTheme
        ? Colors.white.withOpacity(0.5)
        : const Color(0xFF707070);
    final Color iconColor =
        widget.darkTheme ? Colors.white : const Color(0xFF252525);
    final Color labelColor = widget.darkTheme
        ? Colors.white.withOpacity(0.7)
        : const Color(0xFF757575);
    final Color fillColor =
        widget.darkTheme ? Colors.white.withOpacity(0.05) : Colors.white;
    final Color borderColor =
        widget.darkTheme ? Colors.white.withOpacity(0.1) : const Color(0xFFD7D7D7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              color: labelColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Focus(
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (_isFocused && widget.darkTheme)
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
              ],
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.obscure,
              validator: widget.validator,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              onChanged: widget.onChanged,
              autofillHints: widget.autofillHints,
              textInputAction: widget.textInputAction,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: hintColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(widget.icon, color: iconColor, size: 22),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          widget.obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: iconColor.withOpacity(0.6),
                          size: 22,
                        ),
                        onPressed: widget.onToggleVisibility,
                      )
                    : null,
                filled: true,
                fillColor: fillColor,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                errorStyle: const TextStyle(
                  color: Color(0xFFFF5252),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: widget.darkTheme ? Colors.white : const Color(0xFF005CB7),
                      width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFFF5252), width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      const BorderSide(color: Color(0xFFFF5252), width: 1.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
