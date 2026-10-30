import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/application_model.dart';
import '../services/bantu_akses_repository.dart';
import '../widgets/bantu_app_bar.dart';
import '../widgets/status_timeline_widget.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/info_notice_banner.dart';

class StatusPengajuanScreen extends StatefulWidget {
  final BantuAksesRepository repository;

  const StatusPengajuanScreen({super.key, required this.repository});

  @override
  State<StatusPengajuanScreen> createState() => _StatusPengajuanScreenState();
}

class _StatusPengajuanScreenState extends State<StatusPengajuanScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _activeSearchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.repository,
      builder: (context, _) {
        final allApps = widget.repository.applications;
        final filteredApps = _activeSearchQuery.isEmpty
            ? allApps
            : allApps.where((a) {
                final q = _activeSearchQuery.toLowerCase();
                return a.registrationCode.toLowerCase().contains(q) ||
                    a.nik.toLowerCase().contains(q) ||
                    a.programName.toLowerCase().contains(q);
              }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: BantuAppBar(
            title: 'Lacak Status Pengajuan',
            subtitle: 'Pantau tahapan verifikasi dan jadwal penyaluran bansos',
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() => _activeSearchQuery = val.trim());
                    },
                    style: AppTypography.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Cari no. registrasi (REG-2026-...) atau NIK...',
                      hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textPlaceholder),
                      prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18, color: AppColors.textMuted),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _activeSearchQuery = '');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const InfoNoticeBanner(
                title: 'Informasi Tahapan Verifikasi',
                message:
                    'Proses verifikasi membutuhkan waktu 3-7 hari kerja tergantung kelengkapan berkas kependudukan dan jadwal survei lapangan oleh tim dinas sosial.',
              ),
              const SizedBox(height: 16),

              // Daftar Pengajuan
              if (filteredApps.isEmpty)
                EmptyStateCard(
                  icon: Icons.assignment_late_outlined,
                  title: 'Data Pengajuan Tidak Ditemukan',
                  message: _activeSearchQuery.isEmpty
                      ? 'Anda belum memiliki riwayat pengajuan bantuan sosial aktif.'
                      : 'Tidak ditemukan pengajuan dengan nomor registrasi atau NIK "$_activeSearchQuery".',
                  actionText: _activeSearchQuery.isNotEmpty ? 'Tampilkan Semua Pengajuan' : null,
                  onAction: () {
                    _searchController.clear();
                    setState(() => _activeSearchQuery = '');
                  },
                )
              else
                ...filteredApps.map((app) => _buildApplicationCard(context, app)),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildApplicationCard(BuildContext context, ApplicationModel app) {
    Color statusBg;
    Color statusBorder;
    Color statusTextColor;
    IconData statusIcon;

    switch (app.status) {
      case ApplicationStatus.disetujui:
      case ApplicationStatus.disalurkan:
        statusBg = AppColors.statusSuccessBg;
        statusBorder = AppColors.statusSuccessBorder;
        statusTextColor = AppColors.statusSuccess;
        statusIcon = Icons.check_circle_outline_rounded;
        break;
      case ApplicationStatus.ditolak:
        statusBg = AppColors.statusDangerBg;
        statusBorder = AppColors.statusDangerBorder;
        statusTextColor = AppColors.statusDanger;
        statusIcon = Icons.cancel_outlined;
        break;
      case ApplicationStatus.diajukan:
      case ApplicationStatus.verifikasiAdministrasi:
      case ApplicationStatus.surveiLapangan:
        statusBg = AppColors.statusWarningBg;
        statusBorder = AppColors.statusWarningBorder;
        statusTextColor = AppColors.statusWarning;
        statusIcon = Icons.hourglass_top_rounded;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: No Registrasi & Tanggal
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.tag_rounded, size: 16, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        app.registrationCode,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: app.registrationCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Nomor registrasi berhasil disalin'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Icon(Icons.copy_rounded, size: 15, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Text(
                  app.submissionDate,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Program Name
                Text(
                  app.programName,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pemohon: ${app.applicantName} (NIK: ${app.nik})',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 12),

                // Explicit Status Box (With Text Label and Full Human Description)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(statusIcon, size: 18, color: statusTextColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              app.statusLabel,
                              style: AppTypography.titleSmall.copyWith(
                                color: statusTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        app.statusDescription,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Timeline Section
                const Text('Alur Tahapan Pengajuan:', style: AppTypography.titleSmall),
                const SizedBox(height: 12),
                StatusTimelineWidget(steps: app.timeline),

                const SizedBox(height: 16),
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 12),

                // Actions: Unduh Bukti / Hubungi Bantuan
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Bukti pendaftaran ${app.registrationCode} disimpan ke perangkat.'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download_rounded, size: 16),
                        label: const Text('Unduh Tanda Terima', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 38),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
