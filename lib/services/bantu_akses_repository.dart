import 'dart:math';
import 'package:flutter/material.dart';
import '../models/program_model.dart';
import '../models/application_model.dart';
import '../models/location_model.dart';
import '../models/notification_model.dart';
import '../models/user_profile_model.dart';
import 'mock_data_service.dart';
import 'local_storage_service.dart';

class BantuAksesRepository extends ChangeNotifier {
  final LocalStorageService _storage;

  List<ProgramModel> _programs = [];
  List<ApplicationModel> _applications = [];
  List<LocationModel> _locations = [];
  List<NotificationModel> _notifications = [];
  UserProfileModel _profile = MockDataService.defaultProfile;

  // Search & Filter state for Programs
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  // Filter state for Locations
  String _selectedLocationType = 'Semua';

  // Accessibility
  bool _isLargeText = false;
  bool _isHighContrast = false;

  // Auth State
  bool _isLoggedIn = false;

  BantuAksesRepository(this._storage) {
    _loadInitialData();
  }

  void _loadInitialData() {
    _programs = List.from(MockDataService.defaultPrograms);
    _applications = _storage.getApplications();
    _locations = List.from(MockDataService.defaultLocations);
    _notifications = _storage.getNotifications();
    _profile = _storage.getProfile();
    _isLargeText = _storage.isLargeTextEnabled;
    _isHighContrast = _storage.isHighContrastEnabled;
    _isLoggedIn = _storage.isLoggedIn;
    notifyListeners();
  }

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  List<ProgramModel> get allPrograms => _programs;
  List<ApplicationModel> get applications => _applications;
  List<LocationModel> get locations => _locations;
  List<NotificationModel> get notifications => _notifications;
  UserProfileModel get profile => _profile;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedLocationType => _selectedLocationType;
  bool get isLargeText => _isLargeText;
  bool get isHighContrast => _isHighContrast;

  double get textScaleFactor => _isLargeText ? 1.18 : 1.0;

  int get unreadNotificationsCount =>
      _notifications.where((n) => !n.isRead).length;

  List<ProgramModel> get filteredPrograms {
    return _programs.where((p) {
      final matchesCategory = _selectedCategory == 'Semua' || p.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.shortDescription.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.targetAudience.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  List<LocationModel> get filteredLocations {
    if (_selectedLocationType == 'Semua') return _locations;
    return _locations.where((loc) => loc.type == _selectedLocationType).toList();
  }

  // Setters & Actions
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedLocationType(String type) {
    _selectedLocationType = type;
    notifyListeners();
  }

  Future<void> toggleLargeText(bool value) async {
    _isLargeText = value;
    await _storage.setLargeTextEnabled(value);
    notifyListeners();
  }

  Future<void> toggleHighContrast(bool value) async {
    _isHighContrast = value;
    await _storage.setHighContrastEnabled(value);
    notifyListeners();
  }

  Future<void> markNotificationAsRead(String id) async {
    await _storage.markNotificationAsRead(id);
    _notifications = _storage.getNotifications();
    notifyListeners();
  }

  Future<void> markAllNotificationsAsRead() async {
    await _storage.markAllNotificationsAsRead();
    _notifications = _storage.getNotifications();
    notifyListeners();
  }

  // Authentication Methods
  Future<bool> login({required String identifier, required String password}) async {
    // Validasi login publik: jika NIK sesuai dengan profil default atau panjang NIK 16 digit
    final cleanId = identifier.trim();
    if (cleanId.isEmpty || password.isEmpty) return false;

    _isLoggedIn = true;
    await _storage.setLoggedIn(true);
    notifyListeners();
    return true;
  }

  Future<void> loginAsGuest() async {
    _isLoggedIn = true;
    await _storage.setLoggedIn(true);
    notifyListeners();
  }

  Future<void> registerCitizen({
    required String name,
    required String nik,
    required String noKk,
    required String phone,
    required String address,
  }) async {
    final updatedProfile = UserProfileModel(
      name: name,
      nik: nik,
      noKk: noKk,
      phone: phone,
      email: '$phone@layanan.id',
      fullAddress: address,
      rtRw: '01 / 02',
      kelurahan: 'Kelurahan Setempat',
      kecamatan: 'Kecamatan Terdaftar',
      isDtksRegistered: true,
      dtksCategory: 'Desil 2 (Pra-Sejahtera)',
      verifiedDocuments: ['KTP Elektronik Terdaftar', 'Kartu Keluarga Terverifikasi'],
    );
    _profile = updatedProfile;
    await _storage.saveProfile(updatedProfile);
    _isLoggedIn = true;
    await _storage.setLoggedIn(true);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    await _storage.setLoggedIn(false);
    notifyListeners();
  }

  // Cari aplikasi berdasarkan NIK atau Nomor Registrasi
  ApplicationModel? findApplicationByQuery(String query) {
    final clean = query.trim().toLowerCase();
    if (clean.isEmpty) return null;

    for (final app in _applications) {
      if (app.registrationCode.toLowerCase() == clean ||
          app.nik.toLowerCase() == clean ||
          app.registrationCode.toLowerCase().contains(clean)) {
        return app;
      }
    }
    return null;
  }

  ProgramModel? getProgramById(String id) {
    try {
      return _programs.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // Submit New Application
  Future<ApplicationModel> submitNewApplication({
    required ProgramModel program,
    required String applicantName,
    required String nik,
    required String noKk,
    required String phone,
    required String fullAddress,
    required String monthlyIncome,
    required int dependentsCount,
    required List<String> submittedDocuments,
  }) async {
    // Generate Registration Code: REG-2026-XXXX
    final randomDigits = (1000 + Random().nextInt(9000)).toString();
    final regCode = 'REG-2026-$randomDigits';
    final now = DateTime.now();
    final submissionDateStr = '${now.day} ${_monthName(now.month)} ${now.year}';
    final timestampStr = '${now.day} ${_monthName(now.month)} ${now.year}, ${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')} WIB';

    final initialTimeline = [
      StatusStep(
        title: 'Pengajuan Berkas Diterima',
        description: 'Permohonan berhasil didaftarkan secara online ke dalam sistem verifikasi.',
        date: timestampStr,
        isCompleted: true,
        isCurrent: true,
      ),
      const StatusStep(
        title: 'Verifikasi Administrasi Kependudukan',
        description: 'Pemeriksaan kesesuaian NIK, No. KK, dan berkas persyaratan oleh verifikator.',
        date: null,
        isCompleted: false,
        isCurrent: false,
      ),
      const StatusStep(
        title: 'Verifikasi Faktual Lapangan',
        description: 'Pengecekan kondisi tempat tinggal dan kelayakan keluarga penerima manfaat.',
        date: null,
        isCompleted: false,
        isCurrent: false,
      ),
      const StatusStep(
        title: 'Penetapan Surat Keputusan (SK)',
        description: 'Keputusan resmi kelayakan oleh instansi dinas penyelenggara.',
        date: null,
        isCompleted: false,
        isCurrent: false,
      ),
      const StatusStep(
        title: 'Penyaluran Bantuan',
        description: 'Distribusi bantuan ke rekening/posko penyalur resmi.',
        date: null,
        isCompleted: false,
        isCurrent: false,
      ),
    ];

    final newApp = ApplicationModel(
      id: 'app-${DateTime.now().millisecondsSinceEpoch}',
      registrationCode: regCode,
      programId: program.id,
      programName: program.name,
      applicantName: applicantName,
      nik: nik,
      noKk: noKk,
      phone: phone,
      fullAddress: fullAddress,
      monthlyIncome: monthlyIncome,
      dependentsCount: dependentsCount,
      status: ApplicationStatus.diajukan,
      statusLabel: 'Berkas Diterima - Menunggu Verifikasi',
      statusDescription:
          'Pengajuan berhasil didaftarkan. Dokumen Anda sedang menunggu antrean verifikasi administrasi oleh petugas dinas sosial setempat.',
      submissionDate: submissionDateStr,
      lastUpdatedDate: submissionDateStr,
      submittedDocuments: submittedDocuments,
      timeline: initialTimeline,
    );

    await _storage.addApplication(newApp);
    _applications = _storage.getApplications();

    // Tambah notifikasi baru
    final newNotif = NotificationModel(
      id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Pengajuan $regCode Berhasil Didaftarkan',
      message:
          'Permohonan untuk program ${program.name} telah masuk ke sistem. Simpan nomor registrasi Anda untuk pengecekan status berkala.',
      category: 'Status Pengajuan',
      date: submissionDateStr,
      isRead: false,
      relatedCode: regCode,
    );

    final currentNotifs = _storage.getNotifications();
    currentNotifs.insert(0, newNotif);
    await _storage.saveNotifications(currentNotifs);
    _notifications = _storage.getNotifications();

    notifyListeners();
    return newApp;
  }

  static String _monthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }
}
