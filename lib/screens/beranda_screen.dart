import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../services/bantu_akses_repository.dart';
import '../widgets/primary_action_card.dart';
import '../widgets/program_card.dart';
import '../widgets/section_title.dart';
import '../widgets/info_notice_banner.dart';
import 'program_detail_screen.dart';
import 'formulir_pengajuan_screen.dart';
import 'notifikasi_screen.dart';
import 'lokasi_posko_screen.dart';

class BerandaScreen extends StatelessWidget {
  final BantuAksesRepository repository;
  final Function(int tabIndex)? onNavigateTab;

  const BerandaScreen({
    super.key,
    required this.repository,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final profile = repository.profile;
        final priorityPrograms = repository.allPrograms.take(3).toList();
        final unreadCount = repository.unreadNotificationsCount;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // Clean Public Service Header
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.forestGreen,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Identity & Notification
                        Row(
                          children: [
                            // Official Portal Badge
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.forestGreenLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.verified_user_rounded,
                                      size: 13,
                                      color: AppColors.warmCreamDark,
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        'PORTAL RESMI LAYANAN SOSIAL',
                                        style: AppTypography.labelSmall.copyWith(
                                          color: AppColors.surfaceWhite,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Notification Button
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => NotifikasiScreen(repository: repository),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.forestGreenLight,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.notifications_none_rounded,
                                      color: AppColors.surfaceWhite,
                                      size: 20,
                                    ),
                                  ),
                                  if (unreadCount > 0)
                                    Positioned(
                                      top: -2,
                                      right: -2,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: AppColors.statusDanger,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '$unreadCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Main Headline: Strong, Formal, yet Compact
                        Text(
                          'BantuAkses',
                          style: AppTypography.displayMedium.copyWith(
                            color: AppColors.surfaceWhite,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Akses mudah, transparan, dan terpercaya untuk seluruh bantuan sosial dan perlindungan kependudukan.',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.warmCreamLight,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Citizen Identity Brief Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.forestGreenDark.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.forestGreenLight, width: 0.8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_outline_rounded,
                                size: 16,
                                color: AppColors.warmCreamDark,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${profile.name} • NIK: ${profile.maskedNik}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.surfaceWhite,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.forestGreenLight,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  'Terdaftar DTKS',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.surfaceWhite,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Main Body Content
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Dua Aksi Utama (Very prominent, clear visual hierarchy)
                    const SectionTitle(
                      title: 'Layanan Utama',
                      subtitle: 'Pilih aksi yang ingin Anda lakukan',
                    ),
                    PrimaryActionCard(
                      title: 'Daftar Bantuan Baru',
                      description: 'Ajukan permohonan program bantuan sosial dengan alur ringkas & dokumen kependudukan.',
                      icon: Icons.assignment_turned_in_rounded,
                      isPrimary: true,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FormulirPengajuanScreen(repository: repository),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    PrimaryActionCard(
                      title: 'Cek Status Pengajuan',
                      description: 'Lacak tahapan verifikasi berkas dan jadwal penyaluran bansos secara transparan.',
                      icon: Icons.track_changes_rounded,
                      isPrimary: false,
                      onTap: () {
                        if (onNavigateTab != null) {
                          onNavigateTab!(2); // Tab Cek Status
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    // Public Service Advisory
                    const InfoNoticeBanner(
                      title: 'Pemberitahuan Layanan Bebas Pungli',
                      message:
                          'Seluruh pendaftaran dan penyaluran bantuan sosial tidak dipungut biaya apa pun. Laporkan ke posko terdekat bila menemukan oknum pemungut biaya.',
                      icon: Icons.shield_outlined,
                    ),

                    const SizedBox(height: 24),

                    // Program Pilihan dalam Layout Ringkas
                    SectionTitle(
                      title: 'Program Pilihan Prioritas',
                      subtitle: 'Program bantuan yang sedang membuka pendaftaran',
                      actionText: 'Lihat Semua Program (${repository.allPrograms.length})',
                      onAction: () {
                        if (onNavigateTab != null) {
                          onNavigateTab!(1); // Tab Program
                        }
                      },
                    ),

                    // List ringkas program pilihan
                    ...priorityPrograms.map(
                      (prog) => ProgramCard(
                        program: prog,
                        compact: true,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProgramDetailScreen(
                                program: prog,
                                repository: repository,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Quick Section: Posko Layanan Terdekat
                    Container(
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
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.forestGreenSurface,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  size: 18,
                                  color: AppColors.forestGreen,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Butuh Konsultasi Langsung?',
                                      style: AppTypography.titleSmall.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Temukan kantor Dinsos atau posko penyalur terdekat di wilayah Anda.',
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 12,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LokasiPoskoScreen(repository: repository),
                                ),
                              );
                            },
                            icon: const Icon(Icons.near_me_outlined, size: 16),
                            label: const Text('Buka Daftar Posko Terdekat'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 42),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
