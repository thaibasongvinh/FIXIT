import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Stack(
      children: [
        // 1. Futuristic Gradient Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark 
                  ? [
                      const Color(0xFF0D1B3E), // Deep Navy Blue (Rich hơn)
                      const Color(0xFF010510), // Dark Midnight
                      const Color(0xFF000000), // Black
                    ]
                  : [
                      const Color(0xFFF0F4F8), 
                      const Color(0xFFE1E8F0),
                    ],
              stops: isDark ? [0.0, 0.6, 1.0] : null,
            ),
          ),
        ),
        
        // 2. Ambient Orbs (Tăng độ rực rỡ cho Dark Mode)
        Positioned(
          top: -100,
          right: -50,
          child: _AmbientOrb(
            size: 400,
            color: isDark 
                ? const Color(0xFF1E3A8A).withOpacity(0.2) // Blue Glow
                : Colors.blue.withOpacity(0.15),
          ),
        ),
        Positioned(
          bottom: 50,
          left: -150,
          child: _AmbientOrb(
            size: 500,
            color: isDark 
                ? const Color(0xFF0F172A).withOpacity(0.3) 
                : Colors.blueAccent.withOpacity(0.1),
          ),
        ),

        // 3. Subtle Light Ray (Chỉ cho Dark Mode để tạo độ "chất")
        if (isDark)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.8, -1.0),
                  radius: 1.5,
                  colors: [
                    Colors.blue.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        
        // 4. The Content
        child,
      ],
    );
  }
}

class _AmbientOrb extends StatelessWidget {
  final double size;
  final Color color;
  const _AmbientOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 100,
            spreadRadius: 50,
          ),
        ],
      ),
    );
  }
}
