import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../services/bantu_akses_repository.dart';
import 'registrasi_screen.dart';

class LoginScreen extends StatefulWidget {
  final BantuAksesRepository repository;

  const LoginScreen({super.key, required this.repository});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemoAccount() {
    setState(() {
      _identifierController.text = widget.repository.profile.nik;
      _passwordController.text = 'Password123!';
      _errorMessage = null;
    });
  }

  Future<void> _handleLogin() async {
    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulasi delay autentikasi
    await Future.delayed(const Duration(milliseconds: 600));

    final success = await widget.repository.login(
      identifier: _identifierController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (!success) {
      setState(() {
        _errorMessage = 'NIK atau kata sandi tidak sesuai dengan data kependudukan.';
      });
    }
  }

  Future<void> _handleGuestAccess() async {
    await widget.repository.loginAsGuest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Emblem & Official Portal Header
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.verified_user_rounded,
                          color: AppColors.surfaceWhite,
                          size: 34,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'BantuAkses',
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.forestGreen,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Portal Resmi Layanan Bantuan Sosial & Perlindungan Warga',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 28),

                  // Login Form Card (Clean white card, 1px subtle border, no heavy shadows)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight, width: 1),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Masuk ke Akun Warga',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Gunakan NIK 16 digit atau nomor telepon yang terdaftar pada DTKS.',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Quick Autofill Demo Chip
                          InkWell(
                            onTap: _fillDemoAccount,
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.forestGreenSurface,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.forestGreenMuted),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.flash_on_rounded, size: 14, color: AppColors.forestGreen),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      'Isi otomatis akun simulasi (Siti Rahmawati - DTKS)',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.forestGreenDark,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // NIK / Handphone Input
                          const Text('NIK atau Nomor Handphone*', style: AppTypography.titleSmall),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _identifierController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                            ],
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'NIK atau nomor handphone wajib diisi';
                              }
                              if (val.trim().length < 10) {
                                return 'Nomor identitas minimal 10 digit angka';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: '16 digit NIK sesuai KTP elektronik',
                              prefixIcon: Icon(Icons.badge_outlined, size: 20, color: AppColors.textMuted),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Password Input
                          const Text('Kata Sandi / PIN*', style: AppTypography.titleSmall),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Kata sandi wajib diisi';
                              }
                              if (val.trim().length < 6) {
                                return 'Kata sandi minimal 6 karakter';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Masukkan kata sandi akun',
                              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: AppColors.textMuted),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  size: 20,
                                  color: AppColors.textMuted,
                                ),
                                onPressed: () {
                                  setState(() => _obscurePassword = !_obscurePassword);
                                },
                              ),
                            ),
                          ),

                          // Error message banner if any
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.statusDangerBg,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.statusDangerBorder),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline_rounded, size: 16, color: AppColors.statusDanger),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.statusDanger,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),

                          // Submit Button (Primary Forest Green)
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Masuk ke Layanan'),
                          ),

                          const SizedBox(height: 16),

                          // Divider "atau"
                          Row(
                            children: [
                              const Expanded(child: Divider(color: AppColors.borderLight)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('atau', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                              ),
                              const Expanded(child: Divider(color: AppColors.borderLight)),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Guest Access Button (Warm Cream / Clean outline)
                          OutlinedButton.icon(
                            onPressed: _handleGuestAccess,
                            icon: const Icon(Icons.search_rounded, size: 18),
                            label: const Text('Mode Penelusuran Publik (Tamu)'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Register Link
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Belum memiliki akun warga? ',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RegistrasiScreen(repository: widget.repository),
                            ),
                          );
                        },
                        child: Text(
                          'Daftar Akun Baru',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.forestGreen,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Data Privacy Public Service Footer
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      const Icon(Icons.shield_outlined, size: 14, color: AppColors.textMuted),
                      Text(
                        'Terhubung dengan Sistem Terpadu Dukcapil & DTKS Kemensos',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
