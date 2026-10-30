import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/program_model.dart';
import '../services/bantu_akses_repository.dart';
import '../widgets/bantu_app_bar.dart';
import '../widgets/section_title.dart';
import '../widgets/info_notice_banner.dart';
import 'formulir_pengajuan_screen.dart';

class ProgramDetailScreen extends StatelessWidget {
  final ProgramModel program;
  final BantuAksesRepository repository;

  const ProgramDetailScreen({
    super.key,
    required this.program,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BantuAppBar(
        title: 'Detail Program Bantuan',
        subtitle: program.agency,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category & Agency Tag
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.forestGreenSurface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.forestGreenMuted, width: 0.8),
                  ),
                  child: Text(
                    program.category,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.forestGreenDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    program.agency,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Program Title
            Text(
              program.name,
              style: AppTypography.displayMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // Benefit Summary Box (Clean Warm Cream background)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warmCreamLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderMedium, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.warmCreamDark,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.card_giftcard_rounded,
                      color: AppColors.forestGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bentuk Bantuan yang Diterima',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          program.benefitSummary,
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Deskripsi Lengkap
            const SectionTitle(title: 'Deskripsi Program'),
            Text(
              program.fullDescription,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // Sasaran Penerima
            const SectionTitle(title: 'Sasaran Penerima Manfaat'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people_alt_outlined, size: 20, color: AppColors.forestGreen),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      program.targetAudience,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Persyaratan Kelayakan
            const SectionTitle(title: 'Kriteria & Syarat Pendaftaran'),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight, width: 1),
              ),
              child: Column(
                children: program.requirements.map((req) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.check_circle_outline_rounded,
                            size: 16,
                            color: AppColors.forestGreen,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            req,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Dokumen yang Diperlukan
            const SectionTitle(title: 'Dokumen Persyaratan'),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight, width: 1),
              ),
              child: Column(
                children: program.requiredDocuments.map((doc) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            doc,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: AppColors.borderLight, width: 0.8),
                          ),
                          child: Text(
                            'Wajib',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Jadwal & Kuota Info
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warmCreamLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderMedium, width: 1),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.forestGreen),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          program.periodInfo,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.people_outline_rounded, size: 16, color: AppColors.forestGreen),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          program.quotaInfo,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Public Service Guarantee Notice
            const InfoNoticeBanner(
              title: 'Transparansi Penyaluran',
              message:
                  'Pendaftaran tidak dipungut biaya. Pengisian data akan dicocokkan langsung dengan basis data kependudukan dan DTKS.',
            ),

            const SizedBox(height: 80), // Space for Sticky Bottom Bar
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: const BoxDecoration(
          color: AppColors.surfaceWhite,
          border: Border(
            top: BorderSide(color: AppColors.borderLight, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FormulirPengajuanScreen(
                    repository: repository,
                    preselectedProgram: program,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit_document, size: 18),
            label: const Text('Daftar Program Ini Sekarang'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ),
      ),
    );
  }
}
