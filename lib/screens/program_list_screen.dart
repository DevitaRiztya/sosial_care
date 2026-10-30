import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../services/bantu_akses_repository.dart';
import '../widgets/bantu_app_bar.dart';
import '../widgets/program_card.dart';
import '../widgets/empty_state_card.dart';
import 'program_detail_screen.dart';

class ProgramListScreen extends StatefulWidget {
  final BantuAksesRepository repository;

  const ProgramListScreen({super.key, required this.repository});

  @override
  State<ProgramListScreen> createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = const [
    'Semua',
    'Pangan Pokok',
    'Pendidikan',
    'Disabilitas',
    'Kesehatan',
    'Modal Usaha',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.repository.searchQuery;
  }

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
        final filteredList = widget.repository.filteredPrograms;
        final selectedCat = widget.repository.selectedCategory;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: BantuAppBar(
            title: 'Katalog Program Bantuan',
            subtitle: 'Daftar program resmi bansos yang dapat diajukan',
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderLight, width: 1),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => widget.repository.setSearchQuery(val),
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Cari nama program atau kata kunci...',
                      hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textPlaceholder),
                      prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18, color: AppColors.textMuted),
                              onPressed: () {
                                _searchController.clear();
                                widget.repository.setSearchQuery('');
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
          body: Column(
            children: [
              // Category Filter Bar (Clean horizontal scroll, subdued pill styling)
              Container(
                color: AppColors.surfaceWhite,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  height: 34,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = selectedCat == category;

                      return InkWell(
                        onTap: () => widget.repository.setSelectedCategory(category),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.forestGreen : AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected ? AppColors.forestGreen : AppColors.borderLight,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              category,
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

              // Results Count Bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  border: Border(
                    bottom: BorderSide(color: AppColors.divider, width: 1),
                  ),
                ),
                child: Text(
                  'Menampilkan ${filteredList.length} dari ${widget.repository.allPrograms.length} program bantuan',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),

              // Program List
              Expanded(
                child: filteredList.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: EmptyStateCard(
                            icon: Icons.search_off_rounded,
                            title: 'Program Tidak Ditemukan',
                            message:
                                'Tidak ada program bantuan sosial yang cocok dengan kata kunci atau kategori yang Anda pilih.',
                            actionText: 'Reset Filter & Pencarian',
                            onAction: () {
                              _searchController.clear();
                              widget.repository.setSearchQuery('');
                              widget.repository.setSelectedCategory('Semua');
                            },
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final prog = filteredList[index];
                          return ProgramCard(
                            program: prog,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProgramDetailScreen(
                                    program: prog,
                                    repository: widget.repository,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
