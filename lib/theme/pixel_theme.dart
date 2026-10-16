import 'package:flutter/material.dart';

/// Pixel art color palettes
enum AppPixelTheme {
  leicaRed,     // Classic Leica Red & Silver Chrome
  mistralAmber, // Retro warm amber / orange
  monochrom,    // Pure Leica Monochrom high-contrast B&W
  cyberBlue,    // Retro 80s arcade cyan/blue
}

extension AppPixelThemeX on AppPixelTheme {
  String get name {
    switch (this) {
      case AppPixelTheme.leicaRed:
        return 'Leica Classic (Đỏ & Bạc)';
      case AppPixelTheme.mistralAmber:
        return 'Retro Amber (Cam Ấm)';
      case AppPixelTheme.monochrom:
        return 'Leica Monochrom (Đen Trắng)';
      case AppPixelTheme.cyberBlue:
        return 'Cyber 8-Bit (Xanh Lạnh)';
    }
  }

  Color get primary {
    switch (this) {
      case AppPixelTheme.leicaRed:
        return const Color(0xFFD9222A); // Iconic Leica Red
      case AppPixelTheme.mistralAmber:
        return const Color(0xFFF27B13); // Warm retro amber
      case AppPixelTheme.monochrom:
        return const Color(0xFF2C2D30); // Deep Monochrom slate
      case AppPixelTheme.cyberBlue:
        return const Color(0xFF0F82C9); // Cyan / Blue
    }
  }

  Color get secondary {
    switch (this) {
      case AppPixelTheme.leicaRed:
        return const Color(0xFF2B2C33);
      case AppPixelTheme.mistralAmber:
        return const Color(0xFFFFAE19);
      case AppPixelTheme.monochrom:
        return const Color(0xFF5A5C66);
      case AppPixelTheme.cyberBlue:
        return const Color(0xFF00C7B7);
    }
  }

  Color get bgCanvas {
    switch (this) {
      case AppPixelTheme.leicaRed:
      case AppPixelTheme.mistralAmber:
        return const Color(0xFFF5F3EC); // Warm vintage paper
      case AppPixelTheme.monochrom:
        return const Color(0xFFEEEEEE);
      case AppPixelTheme.cyberBlue:
        return const Color(0xFFEFF5F9);
    }
  }

  Color get cardBg {
    return Colors.white;
  }

  Color get border {
    return const Color(0xFF141416); // Deep pixel black
  }
}

class PixelThemeData {
  final AppPixelTheme theme;
  final bool isDark;

  const PixelThemeData({
    required this.theme,
    this.isDark = false,
  });

  Color get primary => theme.primary;
  Color get secondary => theme.secondary;
  Color get border => isDark ? const Color(0xFF383A42) : theme.border;
  Color get bg => isDark ? const Color(0xFF16171B) : theme.bgCanvas;
  Color get surface => isDark ? const Color(0xFF22242B) : theme.cardBg;
  Color get surfaceAlt => isDark ? const Color(0xFF2A2D36) : const Color(0xFFEBE8DD);
  Color get textPrimary => isDark ? const Color(0xFFF2F3F5) : const Color(0xFF1A1B20);
  Color get textSecondary => isDark ? const Color(0xFFA0A4B2) : const Color(0xFF6B6E7B);

  // Status indicators for matrix (◎ ○ △ ×)
  Color get statusBest => const Color(0xFF1EA858);   // Green ◎
  Color get statusGood => const Color(0xFF2575FC);   // Blue ○
  Color get statusFair => const Color(0xFFF39C12);   // Amber △
  Color get statusAvoid => const Color(0xFFE74C3C);  // Red ×

  static const double borderWidth = 2.0;
  static const double shadowOffset = 3.0;

  BoxDecoration pixelBox({
    Color? color,
    bool pressed = false,
    bool hasShadow = true,
    Color? customBorder,
  }) {
    return BoxDecoration(
      color: color ?? surface,
      borderRadius: BorderRadius.zero,
      border: Border.all(
        color: customBorder ?? border,
        width: borderWidth,
      ),
      boxShadow: hasShadow && !pressed
          ? [
              BoxShadow(
                color: border,
                offset: const Offset(shadowOffset, shadowOffset),
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ]
          : null,
    );
  }
}
