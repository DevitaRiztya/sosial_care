import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/location_model.dart';
import '../services/bantu_akses_repository.dart';
import '../widgets/bantu_app_bar.dart';
import '../widgets/empty_state_card.dart';

class LokasiPoskoScreen extends StatelessWidget {
  final BantuAksesRepository repository;

  const LokasiPoskoScreen({super.key, required this.repository});

  static const List<String> _locationFilters = [
    'Semua',
    'Kantor Dinas Sosial',
    'Posko Penyaluran',
    'Fasilitas Kesehatan',
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final filteredLocations = repository.filteredLocations;
        final selectedType = repository.selectedLocationType;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const BantuAppBar(
            title: 'Lokasi Posko & Layanan',
            subtitle: 'Kantor dinas sosial, e-warong, dan faskes rujukan terdekat',
            showBackButton: true,
          ),
          body: Column(
            children: [
              // Filter Horizontal Bar
              Container(
                color: AppColors.surfaceWhite,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  height: 34,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _locationFilters.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final type = _locationFilters[index];
                      final isSelected = selectedType == type;

                      return InkWell(
                        onTap: () => repository.setSelectedLocationType(type),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.forestGreen : AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected ? AppColors.forestGreen : AppColors.borderLight,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              type,
                              style: AppTypography.labelSmall.copyWith(
                                color: isSelected ? AppColors.surfaceWhite : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.divider),

              // Locations List
              Expanded(
                child: filteredLocations.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: EmptyStateCard(
                            icon: Icons.location_off_outlined,
                            title: 'Lokasi Tidak Ditemukan',
                            message: 'Tidak ada posko atau layanan pada kategori ini di sekitar wilayah Anda.',
                            actionText: 'Lihat Semua Lokasi',
                            onAction: () => repository.setSelectedLocationType('Semua'),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredLocations.length,
                        itemBuilder: (context, index) {
                          final loc = filteredLocations[index];
                          return _buildLocationCard(context, loc);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationCard(BuildContext context, LocationModel loc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Type & Distance
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.forestGreenSurface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  loc.type,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.forestGreenDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.near_me_outlined, size: 14, color: AppColors.forestGreen),
                  const SizedBox(width: 4),
                  Text(
                    '${loc.distanceKm} km',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.forestGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Location Name
          Text(
            loc.name,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),

          // Address
          Text(
            loc.address,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 10),

          // Operating Hours & Status
          Row(
            children: [
              const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  loc.operatingHours,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: loc.isOpen ? AppColors.statusSuccessBg : AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  loc.isOpen ? 'Buka' : 'Tutup',
                  style: AppTypography.labelSmall.copyWith(
                    color: loc.isOpen ? AppColors.statusSuccess : AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: '${loc.name}, ${loc.address}'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Alamat posko berhasil disalin ke clipboard.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 14),
                  label: const Text('Salin Alamat', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(loc.name, style: const TextStyle(fontSize: 16)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hubungi nomor layanan posko:', style: TextStyle(fontSize: 13)),
                            const SizedBox(height: 6),
                            SelectableText(
                              loc.phone,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.phone_outlined, size: 14),
                  label: const Text('Hubungi', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
