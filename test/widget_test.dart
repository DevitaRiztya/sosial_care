import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosial_care/main.dart';
import 'package:sosial_care/services/local_storage_service.dart';
import 'package:sosial_care/services/bantu_akses_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('BantuAksesApp auth flow and navigation test', (WidgetTester tester) async {
    // Set standard mobile device dimensions (400 x 850)
    tester.view.physicalSize = const Size(400, 850);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    SharedPreferences.setMockInitialValues({});
    final storage = await LocalStorageService.init();
    final repository = BantuAksesRepository(storage);

    await tester.pumpWidget(BantuAksesApp(repository: repository));
    await tester.pumpAndSettle();

    // Verify LoginScreen appears first when not logged in
    expect(find.text('Masuk ke Akun Warga'), findsOneWidget);
    final guestButton = find.text('Mode Penelusuran Publik (Tamu)');
    expect(guestButton, findsOneWidget);

    // Scroll until visible and tap
    await tester.ensureVisible(guestButton);
    await tester.pumpAndSettle();
    await tester.tap(guestButton);
    await tester.pumpAndSettle();

    // Verify MainNavScreen and Beranda are displayed
    expect(find.text('BantuAkses'), findsOneWidget);
    expect(find.text('Daftar Bantuan Baru'), findsOneWidget);
    expect(find.text('Cek Status Pengajuan'), findsOneWidget);
    expect(find.text('Beranda'), findsOneWidget);
  });
}
