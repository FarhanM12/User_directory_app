// lib/constants/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextTheme textTheme = TextTheme(
    titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
    bodyMedium: GoogleFonts.poppins(fontSize: 16),
    titleMedium: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
  );
}
