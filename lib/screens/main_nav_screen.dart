import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../services/bantu_akses_repository.dart';
import 'beranda_screen.dart';
import 'program_list_screen.dart';
import 'status_pengajuan_screen.dart';
import 'profil_screen.dart';

class MainNavScreen extends StatefulWidget {
  final BantuAksesRepository repository;

  const MainNavScreen({super.key, required this.repository});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.repository,
      builder: (context, _) {
        final pages = [
          BerandaScreen(
            repository: widget.repository,
            onNavigateTab: _onTabSelected,
          ),
          ProgramListScreen(repository: widget.repository),
          StatusPengajuanScreen(repository: widget.repository),
          ProfilScreen(repository: widget.repository),
        ];

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(widget.repository.textScaleFactor),
          ),
          child: Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: pages,
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: AppColors.surfaceWhite,
                border: Border(
                  top: BorderSide(color: AppColors.borderLight, width: 1),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _onTabSelected,
                selectedItemColor: AppColors.forestGreen,
                unselectedItemColor: AppColors.textMuted,
                backgroundColor: AppColors.surfaceWhite,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 11,
                unselectedFontSize: 10,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home_rounded),
                    label: 'Beranda',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book_outlined),
                    activeIcon: Icon(Icons.menu_book_rounded),
                    label: 'Program',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.track_changes_outlined),
                    activeIcon: Icon(Icons.track_changes_rounded),
                    label: 'Cek Status',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline_rounded),
                    activeIcon: Icon(Icons.person_rounded),
                    label: 'Profil',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
