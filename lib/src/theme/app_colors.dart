import 'package:flutter/material.dart';

class AppColors {
  // Ana renkler
  static const Color primary = Color(0xFF2C3E50);
  static const Color secondary = Color(0xFF1ABC9C);
  static const Color accent = Color(0xFFE74C3C);

  // Nötr renkler
  static const Color background = Color(0xFFF5F6F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);

  // Durum renkleri
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF1C40F);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);

  // Gölgelendirme
  static const Color shadow = Color(0x1A000000);

  // Gradients
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2C3E50), Color(0xFF3498DB)],
    stops: [0.0, 1.0],
  );

  static const Gradient highlightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1ABC9C), // Parlak turkuaz
      Color(0xFF2980B9), // Canlı mavi
      Color(0xFF8E44AD), // Mor tonu
    ],
    stops: [0.0, 0.5, 1.0],
    transform: GradientRotation(-0.4), // Daha dinamik bir açı
  );

  // Highlight butonu için gölge rengi
  static const Color highlightShadow = Color(
    0xFF2980B9,
  ); // Mavi tonu gölge için

  /// Yüzey varyant rengi
  static const surfaceVariant = Color(0xFFF4F4F5);

  /// Kenarlık varyant rengi
  static const outlineVariant = Color(0xFFE4E4E7);

  /// Yüzey üzeri rengi
  static const onSurface = Color(0xFF18181B);
}
