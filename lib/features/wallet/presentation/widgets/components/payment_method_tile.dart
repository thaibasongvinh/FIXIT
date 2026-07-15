import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PaymentMethodTile extends StatelessWidget {
  final String id;
  final String title;
  final String? assetPath;
  final IconData? icon;
  final Color? iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.id,
    required this.title,
    this.assetPath,
    this.icon,
    this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF2450A4) : const Color(0xFFE0E0E0),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (assetPath != null && assetPath!.isNotEmpty)
              Image.asset(
                assetPath!, 
                width: 32, 
                height: 32, 
                errorBuilder: (_, __, ___) => Icon(icon, color: iconColor, size: 28)
              )
            else
              Icon(icon, color: iconColor, size: 28),
            const Gap(16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF5C5C5C),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_rounded, color: Color(0xFF2450A4), size: 24),
          ],
        ),
      ),
    );
  }
}
