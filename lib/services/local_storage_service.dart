import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/application_model.dart';
import '../models/notification_model.dart';
import '../models/user_profile_model.dart';
import 'mock_data_service.dart';

class LocalStorageService {
  static const String _keyApplications = 'bantu_akses_applications';
  static const String _keyNotifications = 'bantu_akses_notifications';
  static const String _keyProfile = 'bantu_akses_profile';
  static const String _keyLargeText = 'bantu_akses_large_text';
  static const String _keyHighContrast = 'bantu_akses_high_contrast';
  static const String _keyIsLoggedIn = 'bantu_akses_is_logged_in';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final service = LocalStorageService(prefs);
    await service._ensureInitialData();
    return service;
  }

  Future<void> _ensureInitialData() async {
    // Inisialisasi data profil jika belum ada
    if (!_prefs.containsKey(_keyProfile)) {
      await saveProfile(MockDataService.defaultProfile);
    }

    // Inisialisasi daftar pengajuan jika belum ada
    if (!_prefs.containsKey(_keyApplications)) {
      await saveApplications(MockDataService.defaultApplications);
    }

    // Inisialisasi notifikasi jika belum ada
    if (!_prefs.containsKey(_keyNotifications)) {
      await saveNotifications(MockDataService.defaultNotifications);
    }
  }

  // Applications
  List<ApplicationModel> getApplications() {
    final jsonString = _prefs.getString(_keyApplications);
    if (jsonString == null) return MockDataService.defaultApplications;
    try {
      final List decoded = jsonDecode(jsonString) as List;
      return decoded.map((e) => ApplicationModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return MockDataService.defaultApplications;
    }
  }

  Future<void> saveApplications(List<ApplicationModel> applications) async {
    final encoded = jsonEncode(applications.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyApplications, encoded);
  }

  Future<void> addApplication(ApplicationModel app) async {
    final current = getApplications();
    current.insert(0, app);
    await saveApplications(current);
  }

  // Notifications
  List<NotificationModel> getNotifications() {
    final jsonString = _prefs.getString(_keyNotifications);
    if (jsonString == null) return MockDataService.defaultNotifications;
    try {
      final List decoded = jsonDecode(jsonString) as List;
      return decoded.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return MockDataService.defaultNotifications;
    }
  }

  Future<void> saveNotifications(List<NotificationModel> notifications) async {
    final encoded = jsonEncode(notifications.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyNotifications, encoded);
  }

  Future<void> markNotificationAsRead(String id) async {
    final list = getNotifications();
    final updated = list.map((item) {
      if (item.id == id) {
        return item.copyWith(isRead: true);
      }
      return item;
    }).toList();
    await saveNotifications(updated);
  }

  Future<void> markAllNotificationsAsRead() async {
    final list = getNotifications();
    final updated = list.map((item) => item.copyWith(isRead: true)).toList();
    await saveNotifications(updated);
  }

  // Profile
  UserProfileModel getProfile() {
    final jsonString = _prefs.getString(_keyProfile);
    if (jsonString == null) return MockDataService.defaultProfile;
    try {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserProfileModel.fromJson(decoded);
    } catch (_) {
      return MockDataService.defaultProfile;
    }
  }

  Future<void> saveProfile(UserProfileModel profile) async {
    final encoded = jsonEncode(profile.toJson());
    await _prefs.setString(_keyProfile, encoded);
  }

  // Accessibility Settings
  bool get isLargeTextEnabled => _prefs.getBool(_keyLargeText) ?? false;
  Future<void> setLargeTextEnabled(bool value) async {
    await _prefs.setBool(_keyLargeText, value);
  }

  bool get isHighContrastEnabled => _prefs.getBool(_keyHighContrast) ?? false;
  Future<void> setHighContrastEnabled(bool value) async {
    await _prefs.setBool(_keyHighContrast, value);
  }

  // Auth State
  bool get isLoggedIn => _prefs.getBool(_keyIsLoggedIn) ?? false;
  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_keyIsLoggedIn, value);
  }
}
