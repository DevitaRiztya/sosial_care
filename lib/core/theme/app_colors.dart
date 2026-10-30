import 'package:flutter/material.dart';

/// Sistem Warna Resmi BantuAkses
/// Dirancang sesuai standar aplikasi layanan publik:
/// - Forest Green (kredibilitas, keteduhan, perlindungan sosial)
/// - Warm Cream (kehangatan, ramah warga, nyaman di mata)
/// - Netral Abu-abu & Putih (struktur hierarki bersih tanpa gradien dekoratif berlebihan)
class AppColors {
  AppColors._();

  // Primary: Forest Green
  static const Color forestGreen = Color(0xFF1B4D3E);
  static const Color forestGreenLight = Color(0xFF2C6B56);
  static const Color forestGreenDark = Color(0xFF12352B);
  static const Color forestGreenSurface = Color(0xFFEBF3F0);
  static const Color forestGreenMuted = Color(0xFFD6E6E0);

  // Warm Cream & Latar Pendukung
  static const Color warmCream = Color(0xFFF9F6F0);
  static const Color warmCreamLight = Color(0xFFFCFAF6);
  static const Color warmCreamDark = Color(0xFFEDE6DA);

  // Surface & Background
  static const Color background = Color(0xFFF6F8F6);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceSubtle = Color(0xFFF9FAFB);

  // Neutral Text
  static const Color textPrimary = Color(0xFF1A202C); // Charcoal tegas dan kontras tinggi
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textMuted = Color(0xFF718096);
  static const Color textPlaceholder = Color(0xFFA0AEC0);

  // Borders & Dividers
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E0);
  static const Color divider = Color(0xFFEDF2F7);

  // Status Colors (Wajib dilengkapi label teks & deskripsi, bukan hanya warna)
  // 1. Disetujui / Selesai
  static const Color statusSuccess = Color(0xFF15803D);
  static const Color statusSuccessBg = Color(0xFFDCFCE7);
  static const Color statusSuccessBorder = Color(0xFF86EFAC);

  // 2. Dalam Proses / Verifikasi / Menunggu
  static const Color statusWarning = Color(0xFFB45309);
  static const Color statusWarningBg = Color(0xFFFEF3C7);
  static const Color statusWarningBorder = Color(0xFFFCD34D);

  // 3. Info / Tindakan Diperlukan
  static const Color statusInfo = Color(0xFF1D4ED8);
  static const Color statusInfoBg = Color(0xFFDBEAFE);
  static const Color statusInfoBorder = Color(0xFF93C5FD);

  // 4. Perlu Revisi / Ditolak
  static const Color statusDanger = Color(0xFFB91C1C);
  static const Color statusDangerBg = Color(0xFFFEE2E2);
  static const Color statusDangerBorder = Color(0xFFFCA5A5);
}
