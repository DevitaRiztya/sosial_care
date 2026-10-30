import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'services/local_storage_service.dart';
import 'services/bantu_akses_repository.dart';
import 'screens/main_nav_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar and system navigation bar colors for consistency
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final storage = await LocalStorageService.init();
  final repository = BantuAksesRepository(storage);

  runApp(BantuAksesApp(repository: repository));
}

class BantuAksesApp extends StatelessWidget {
  final BantuAksesRepository repository;

  const BantuAksesApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        return MaterialApp(
          title: 'BantuAkses',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: repository.isLoggedIn
              ? MainNavScreen(repository: repository)
              : LoginScreen(repository: repository),
        );
      },
    );
  }
}
