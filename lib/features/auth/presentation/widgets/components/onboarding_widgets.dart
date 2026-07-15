import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../figma_auth_widgets.dart';

class FigmaAuthUploadBox extends StatelessWidget {
  const FigmaAuthUploadBox({
    super.key,
    required this.title,
    this.onTap,
  });

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: kFixitText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: kFixitBlue),
              borderRadius: BorderRadius.circular(12),
              color: kFixitLightBlue.withValues(alpha: 0.3),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo, color: kFixitBlue),
                Gap(10),
                Text(
                  'Upload your certificate',
                  style: TextStyle(
                    color: kFixitBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FigmaAuthLocationButton extends StatelessWidget {
  const FigmaAuthLocationButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isPrimary = false,
  });

  final String text;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: isPrimary ? kFixitBlue : kFixitBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: isPrimary ? kFixitLightBlue.withValues(alpha: 0.1) : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary ? kFixitBlue : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class FigmaAuthDivider extends StatelessWidget {
  const FigmaAuthDivider({super.key, required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? const Color(0xFFE9E9E9);
    final textColor = color?.withOpacity(0.6) ?? kFixitMutedText;

    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: dividerColor, height: 1)),
      ],
    );
  }
}
