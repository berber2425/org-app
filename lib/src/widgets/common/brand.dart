import 'package:org_app/src/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Brand extends StatelessWidget {
  const Brand({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Berber",
      style: GoogleFonts.bungeeInline(
        fontSize: 25,
        color: AppColors.brandPrimary,
      ),
    );
  }
}
