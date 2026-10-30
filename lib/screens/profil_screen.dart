import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../services/bantu_akses_repository.dart';
import '../widgets/bantu_app_bar.dart';
import '../widgets/section_title.dart';
import 'pengaturan_screen.dart';

class ProfilScreen extends StatelessWidget {
  final BantuAksesRepository repository;

  const ProfilScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final profile = repository.profile;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: BantuAppBar(
            title: 'Profil Kependudukan',
            subtitle: 'Data terpadu kesejahteraan sosial pemohon',
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: AppColors.surfaceWhite),
                tooltip: 'Pengaturan',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PengaturanScreen(repository: repository),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Citizen Identification Card (Clean official style, no exaggerated shadow)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderLight, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.forestGreenSurface,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.forestGreenMuted, width: 1),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person_rounded,
                                size: 30,
                                color: AppColors.forestGreen,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.name,
                                  style: AppTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'NIK: ${profile.maskedNik}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'No. KK: ${profile.maskedNoKk}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1, color: AppColors.divider),
                      const SizedBox(height: 12),

                      // DTKS Status Banner
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.forestGreenSurface,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.forestGreenMuted),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              size: 18,
                              color: AppColors.forestGreen,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Terdaftar dalam DTKS Kemensos',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.forestGreenDark,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    profile.dtksCategory,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Data Domisili
                const SectionTitle(title: 'Data Domisili & Kontak'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderLight, width: 1),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Alamat Lengkap', profile.fullAddress),
                      const Divider(height: 16, color: AppColors.divider),
                      _buildInfoRow('RT / RW', profile.rtRw),
                      const Divider(height: 16, color: AppColors.divider),
                      _buildInfoRow('Kelurahan', profile.kelurahan),
                      const Divider(height: 16, color: AppColors.divider),
                      _buildInfoRow('Kecamatan', profile.kecamatan),
                      const Divider(height: 16, color: AppColors.divider),
                      _buildInfoRow('No. Handphone', profile.phone),
                      const Divider(height: 16, color: AppColors.divider),
                      _buildInfoRow('Email', profile.email),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Dokumen Kependudukan Terverifikasi
                const SectionTitle(
                  title: 'Dokumen Kependudukan',
                  subtitle: 'Telah terverifikasi dengan Dinas Kependudukan & Pencatatan Sipil',
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderLight, width: 1),
                  ),
                  child: Column(
                    children: profile.verifiedDocuments.map((doc) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.file_present_rounded,
                              size: 18,
                              color: AppColors.forestGreen,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                doc,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.statusSuccessBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Terverifikasi',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.statusSuccess,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
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

                // Akses Cepat Pengaturan
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PengaturanScreen(repository: repository),
                      ),
                    );
                  },
                  icon: const Icon(Icons.tune_rounded, size: 16),
                  label: const Text('Buka Pengaturan & Aksesibilitas Aplikasi'),
                ),

                const SizedBox(height: 12),

                // Tombol Keluar Akun
                OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Konfirmasi Keluar'),
                        content: const Text(
                          'Apakah Anda yakin ingin keluar dari akun warga BantuAkses?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusDanger),
                            onPressed: () {
                              Navigator.pop(ctx);
                              repository.logout();
                            },
                            child: const Text('Ya, Keluar'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, size: 16, color: AppColors.statusDanger),
                  label: const Text('Keluar dari Akun', style: TextStyle(color: AppColors.statusDanger)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.statusDangerBorder),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ),
        const Text(': ', style: AppTypography.bodySmall),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
