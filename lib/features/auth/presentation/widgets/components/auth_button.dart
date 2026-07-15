import 'package:flutter/material.dart';
import 'package:fixit/shared/widgets/buttons/app_primary_button.dart';
import 'package:fixit/shared/widgets/buttons/social_login_button.dart';
import '../figma_auth_widgets.dart';

class FigmaAuthPrimaryButton extends StatelessWidget {
  const FigmaAuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: kFixitBlue,
    );
  }
}

class FigmaAuthSocialButton extends StatelessWidget {
  const FigmaAuthSocialButton({
    super.key,
    required this.onPressed,
    required this.imagePath,
    required this.label,
  });

  final VoidCallback onPressed;
  final String imagePath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      onPressed: onPressed, 
      imagePath: imagePath, 
      label: label,
    );
  }
}
