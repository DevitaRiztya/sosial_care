import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../services/bantu_akses_repository.dart';
import '../widgets/bantu_app_bar.dart';
import '../widgets/section_title.dart';

class PengaturanScreen extends StatelessWidget {
  final BantuAksesRepository repository;

  const PengaturanScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const BantuAppBar(
            title: 'Pengaturan & Aksesibilitas',
            subtitle: 'Kustomisasi kenyamanan membaca dan preferensi layanan',
            showBackButton: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Accessibility Section
              const SectionTitle(
                title: 'Aksesibilitas & Tampilan',
                subtitle: 'Dirancang agar mudah digunakan oleh lansia dan seluruh warga',
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: repository.isLargeText,
                      onChanged: (val) => repository.toggleLargeText(val),
                      activeTrackColor: AppColors.forestGreen,
                      activeThumbColor: AppColors.surfaceWhite,
                      title: const Text('Ukuran Teks Lebih Besar', style: AppTypography.titleSmall),
                      subtitle: const Text(
                        'Memperbesar ukuran teks untuk memudahkan pembacaan bagi lansia atau gangguan penglihatan.',
                        style: AppTypography.bodySmall,
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    SwitchListTile(
                      value: repository.isHighContrast,
                      onChanged: (val) => repository.toggleHighContrast(val),
                      activeTrackColor: AppColors.forestGreen,
                      activeThumbColor: AppColors.surfaceWhite,
                      title: const Text('Mode Kontras Tegas', style: AppTypography.titleSmall),
                      subtitle: const Text(
                        'Mempertegas batas border dan kontras warna pada tombol dan formulir.',
                        style: AppTypography.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Notifikasi Preferensi
              const SectionTitle(
                title: 'Saluran Pemberitahuan',
                subtitle: 'Pilih bagaimana Anda ingin menerima pembaruan status berkas',
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Pemberitahuan Aplikasi', style: AppTypography.titleSmall),
                      subtitle: const Text('Aktif untuk pengumuman jadwal dan status pengajuan.', style: AppTypography.bodySmall),
                      trailing: const Icon(Icons.check_circle_rounded, color: AppColors.forestGreen, size: 20),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    ListTile(
                      title: const Text('SMS / WhatsApp Konfirmasi', style: AppTypography.titleSmall),
                      subtitle: const Text('Petugas survei akan menghubungi nomor telepon terdaftar.', style: AppTypography.bodySmall),
                      trailing: const Icon(Icons.check_circle_rounded, color: AppColors.forestGreen, size: 20),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Pusat Bantuan & FAQ
              const SectionTitle(
                title: 'Bantuan & Layanan Pengaduan',
                subtitle: 'Informasi resmi dan pelaporan jika menemukan kendala',
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.help_outline_rounded, color: AppColors.forestGreen),
                      title: const Text('Tanya Jawab Seputar Bansos (FAQ)', style: AppTypography.titleSmall),
                      subtitle: const Text('Kriteria kelayakan, berkas yang dibutuhkan, alur seleksi.', style: AppTypography.bodySmall),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                      onTap: () => _showFaqModal(context),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    ListTile(
                      leading: const Icon(Icons.headset_mic_outlined, color: AppColors.forestGreen),
                      title: const Text('Layanan Pengaduan & Bebas Pungli', style: AppTypography.titleSmall),
                      subtitle: const Text('Call Center 1500-771 (Bebas pulsa / Senin - Jumat).', style: AppTypography.bodySmall),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Layanan Pengaduan Masyarakat'),
                            content: const Text(
                              'Jika Anda dimintai biaya atau pungutan liar dalam proses pendaftaran bantuan sosial, segera laporkan ke:\n\n• Hotline: 1500-771\n• WhatsApp Pengaduan: 0811-192-2026\n• Email: aduan@dinsos.go.id',
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tentang Aplikasi
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BantuAkses - Layanan Akses Bantuan Sosial',
                      style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Versi 1.0.0 (Build Resmi Layanan Publik)',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dikembangkan untuk menjamin transparansi, kemudahan, dan akuntabilitas penyaluran bantuan sosial kepada masyarakat yang berhak.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showFaqModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderMedium,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Pertanyaan Umum (FAQ)',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: const [
                      _FaqItem(
                        question: 'Apakah pendaftaran bantuan sosial dipungut biaya?',
                        answer:
                            'Tidak. Seluruh tahapan pendaftaran, verifikasi administrasi, hingga penyaluran bantuan sosial 100% GRATIS dan bebas dari segala bentuk pungutan liar.',
                      ),
                      _FaqItem(
                        question: 'Bagaimana cara mengetahui NIK saya terdaftar di DTKS?',
                        answer:
                            'Anda dapat melihat status pendaftaran DTKS langsung pada menu Profil di aplikasi ini. Jika belum terdaftar, Anda dapat mengajukan permohonan pendataan melalui RT/RW atau kelurahan setempat.',
                      ),
                      _FaqItem(
                        question: 'Berapa lama proses verifikasi pengajuan?',
                        answer:
                            'Proses verifikasi berkas dan survei faktual membutuhkan waktu rata-rata 3 hingga 7 hari kerja. Anda dapat memantau perkembangannya kapan saja melalui menu Cek Status.',
                      ),
                      _FaqItem(
                        question: 'Apa yang harus disiapkan saat petugas survei berkunjung?',
                        answer:
                            'Siapkan KTP elektronik asli dan Kartu Keluarga asli seluruh anggota keluarga yang tercantum dalam pengajuan untuk dicocokkan oleh petugas pendamping sosial.',
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            answer,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
