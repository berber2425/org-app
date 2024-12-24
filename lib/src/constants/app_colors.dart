import 'package:org_app/src/utils/extensions.dart';
import 'package:flutter/material.dart';

extension ColorTo on Color {
  Color toWhite([double? t]) => Color.lerp(this, Colors.white, t ?? 0.15)!;

  Color toBlack([double? t]) => Color.lerp(this, Colors.black, t ?? 0.15)!;

  Color to(Color color, [double? t]) => Color.lerp(this, color, t ?? 0.15)!;
}

class AppColors {
  // Ana Renkler
  static const Color brandPrimary = Color(0xFF9B6B9D); // Zarif mor
  static const Color brandSecondary = Color(0xFFF5D0C5); // Pastel pembe
  static const Color brandAccent = Color(0xFFD4AF37); // Altın

  // Destek Renkleri
  static const Color supportWhite = Color.fromARGB(
    255,
    255,
    255,
    255,
  ); // Sıcak beyaz
  static const Color supportBlack = Color(0xFF2D2D2D); // Yumuşak siyah
  static const Color supportGrey = Color(0xFFE5E5E5); // Açık gri
  static const Color supportDarkGrey = Color(0xFF757575); // Koyu gri
  static const Color supportCream = Color(0xFFF9F5F2); // Krem

  // Yüzey Renkleri
  static const Color surfacePrimary = supportWhite;
  static const Color surfaceSecondary = supportGrey;
  static const Color surfaceSubtitle = supportDarkGrey;
  static const Color surfaceWarning = Color(0xFFFFE0E0); // Açık kırmızı
  // Metin Renkleri
  static const Color textPrimary = supportBlack;
  static const Color textSecondary = supportDarkGrey;
  static const Color textSubtitle = Color(0xFF9E9E9E);
  static const Color textAccent = brandPrimary;
  static const Color textCta = brandAccent;
  static const Color textFixedWhite = supportWhite;
  static const Color textFixedBlack = supportBlack;
  // Gradyanlar
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF9B6B9D), // Mor
      Color(0xFFF5D0C5), // Pembe
      Color(0xFFD4AF37), // Altın
    ],
    stops: [0, 0.5, 1],
  );

  static LinearGradient primaryInactiveGradient = LinearGradient(
    colors: [
      Color(0xFF9B6B9D).op(0.6), // Mor
      Color(0xFFF5D0C5).op(0.6), // Pembe
      Color(0xFFD4AF37).op(0.6), // Altın
    ],
    stops: [0, 0.5, 1],
  );

  static LinearGradient profileGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF9B6B9D), // Mor
      Color(0xFFF5D0C5), // Pembe
    ],
    stops: [0, 1],
  );

  static const Color brandRed = Color(0xFFE53935); // Ana kırmızı
  static const Color brandRedLight = Color(0xFFFF6B6B); // Açık kırmızı
  static const Color brandRedDark = Color(0xFFD32F2F); // Koyu kırmızı
  static const Color brandRedSurface = Color(0xFFFFEBEE); // Kırmızı yüzey

  // Hata Durumları için Gradyan
  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandRed, brandRedLight],
  );
  // Hata Durumları için Gölgelendirme
  static List<BoxShadow> errorShadow = [
    BoxShadow(
      color: brandRed.op(0.2),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
}
