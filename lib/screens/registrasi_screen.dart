import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../services/bantu_akses_repository.dart';
import '../widgets/bantu_app_bar.dart';

class RegistrasiScreen extends StatefulWidget {
  final BantuAksesRepository repository;

  const RegistrasiScreen({super.key, required this.repository});

  @override
  State<RegistrasiScreen> createState() => _RegistrasiScreenState();
}

class _RegistrasiScreenState extends State<RegistrasiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  final _noKkController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _noKkController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 600));

    await widget.repository.registerCitizen(
      name: _nameController.text.trim(),
      nik: _nikController.text.trim(),
      noKk: _noKkController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    Navigator.of(context).pop(); // Tutup halaman registrasi, repository.isLoggedIn sudah true
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BantuAppBar(
        title: 'Pendaftaran Akun Warga Baru',
        subtitle: 'Registrasi data kependudukan pemohon bantuan',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Lengkapi Data Kependudukan',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pastikan data yang Anda masukkan sesuai dengan KTP elektronik dan Kartu Keluarga yang berlaku.',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),

                  const SizedBox(height: 20),

                  // Nama Lengkap
                  const Text('Nama Lengkap (Sesuai KTP)*', style: AppTypography.titleSmall),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Nama lengkap wajib diisi';
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Nama lengkap sesuai KTP'),
                  ),

                  const SizedBox(height: 16),

                  // NIK
                  const Text('Nomor Induk Kependudukan (NIK)*', style: AppTypography.titleSmall),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nikController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                    ],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'NIK wajib diisi';
                      if (val.trim().length != 16) return 'NIK harus terdiri dari 16 digit';
                      return null;
                    },
                    decoration: const InputDecoration(hintText: '16 digit angka NIK'),
                  ),

                  const SizedBox(height: 16),

                  // Nomor KK
                  const Text('Nomor Kartu Keluarga (No. KK)*', style: AppTypography.titleSmall),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _noKkController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                    ],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'No. KK wajib diisi';
                      if (val.trim().length != 16) return 'No. KK harus terdiri dari 16 digit';
                      return null;
                    },
                    decoration: const InputDecoration(hintText: '16 digit angka Kartu Keluarga'),
                  ),

                  const SizedBox(height: 16),

                  // Nomor Handphone
                  const Text('Nomor Handphone / WhatsApp*', style: AppTypography.titleSmall),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(14),
                    ],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Nomor HP wajib diisi';
                      if (val.trim().length < 10) return 'Nomor HP minimal 10 digit';
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Contoh: 081234567890'),
                  ),

                  const SizedBox(height: 16),

                  // Alamat Domisili
                  const Text('Alamat Domisili KTP*', style: AppTypography.titleSmall),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Alamat domisili wajib diisi';
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Nama jalan, nomor rumah, RT, RW, Kelurahan'),
                  ),

                  const SizedBox(height: 16),

                  // Kata Sandi
                  const Text('Kata Sandi Akun*', style: AppTypography.titleSmall),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Kata sandi wajib diisi';
                      if (val.trim().length < 6) return 'Minimal 6 karakter';
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Minimal 6 karakter',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          size: 20,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Daftarkan Akun Warga'),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
