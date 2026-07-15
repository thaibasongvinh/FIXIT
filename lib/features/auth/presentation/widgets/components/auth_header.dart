import 'package:flutter/material.dart';
import 'package:fixit/shared/widgets/typography/section_title.dart';
import '../figma_auth_widgets.dart';

class FigmaAuthHeader extends StatelessWidget {
  const FigmaAuthHeader({
    super.key,
    this.onBack,
    this.currentStep = 1,
    this.totalSteps = 9,
    this.color,
  });

  final VoidCallback? onBack;
  final int currentStep;
  final int totalSteps;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (onBack != null)
            Positioned(
              left: 0,
              child: IconButton(
                onPressed: onBack,
                icon: Icon(Icons.arrow_back, color: color ?? kFixitBlue, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 34, height: 34),
                visualDensity: VisualDensity.compact,
              ),
            ),
          Image.asset(
            'assets/images/app_icon.png',
            height: 45,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class FigmaAuthTitle extends StatelessWidget {
  const FigmaAuthTitle({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return SectionTitle(
      text: text,
      color: kFixitText,
    );
  }
}
