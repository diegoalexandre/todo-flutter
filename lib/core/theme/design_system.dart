import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF3A90F7);
  static const Color primaryPurple = Color(0xFF7A44F2);
  static const Color cardBackground = Colors.white;
  static const Color pageBackground = Color(0xFFF5F5F5);
  static const Color textPrimary = Colors.black87;
  static const Color textMuted = Colors.black54;
  static const Color white = Colors.white;
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFD32F2F);
}

class AppGradients {
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.primaryBlue,
      AppColors.primaryPurple,
    ],
  );

  static const LinearGradient wave = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.primaryBlue,
      AppColors.primaryPurple,
    ],
  );

  static const LinearGradient iconCard = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF6A8AF7),
      AppColors.primaryPurple,
    ],
  );
}

class AppTextStyles {
  static const TextStyle splashTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle splashSubtitle = TextStyle(
    fontSize: 16,
    color: AppColors.white,
  );

  static const TextStyle loginTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle muted = TextStyle(
    fontSize: 14,
    color: AppColors.textMuted,
  );

  static const TextStyle banner = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w500,
  );
}

class AppSpacing {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppRadii {
  static const double card = 16;
  static const double icon = 48;
}
