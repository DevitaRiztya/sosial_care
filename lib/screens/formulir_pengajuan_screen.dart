import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/program_model.dart';
import '../services/bantu_akses_repository.dart';
import '../widgets/bantu_app_bar.dart';
import '../widgets/section_title.dart';

class FormulirPengajuanScreen extends StatefulWidget {
  final BantuAksesRepository repository;
  final ProgramModel? preselectedProgram;

  const FormulirPengajuanScreen({
    super.key,
    required this.repository,
    this.preselectedProgram,
  });

  @override
  State<FormulirPengajuanScreen> createState() => _FormulirPengajuanScreenState();
}

class _FormulirPengajuanScreenState extends State<FormulirPengajuanScreen> {
  int _currentStep = 1;
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  ProgramModel? _selectedProgram;

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _nikController;
  late TextEditingController _noKkController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _dependentsController;

  String _selectedIncome = 'Rp 800.000 - Rp 1.500.000';
  final List<String> _incomeOptions = [
    'Di bawah Rp 800.000',
    'Rp 800.000 - Rp 1.500.000',
    'Rp 1.500.000 - Rp 2.500.000',
    'Rp 2.500.000 - Rp 3.500.000',
    'Di atas Rp 3.500.000',
  ];

  // Document checklist simulation
  bool _docKtp = true;
  bool _docKk = true;
  bool _docSktm = false;
  bool _agreementAccepted = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedProgram = widget.preselectedProgram ?? widget.repository.allPrograms.first;
    final profile = widget.repository.profile;

    _nameController = TextEditingController(text: profile.name);
    _nikController = TextEditingController(text: profile.nik);
    _noKkController = TextEditingController(text: profile.noKk);
    _phoneController = TextEditingController(text: profile.phone);
    _addressController = TextEditingController(
      text: '${profile.fullAddress}, Kel. ${profile.kelurahan}, Kec. ${profile.kecamatan}',
    );
    _dependentsController = TextEditingController(text: '3');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _noKkController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dependentsController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (_formKeyStep1.currentState!.validate()) {
        setState(() => _currentStep = 2);
      }
    } else if (_currentStep == 2) {
      if (_formKeyStep2.currentState!.validate()) {
        setState(() => _currentStep = 3);
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _submitForm() async {
    if (!_agreementAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda wajib menyetujui pernyataan keabsahan data untuk melanjutkan.'),
          backgroundColor: AppColors.statusDanger,
        ),
      );
      return;
    }

    if (_selectedProgram == null) return;

    setState(() => _isSubmitting = true);

    final submittedDocs = <String>[];
    if (_docKtp) submittedDocs.add('KTP Elektronik Terlampir');
    if (_docKk) submittedDocs.add('Kartu Keluarga Terlampir');
    if (_docSktm) submittedDocs.add('Surat Keterangan Tidak Mampu / Dokumen Pendukung');

    final newApp = await widget.repository.submitNewApplication(
      program: _selectedProgram!,
      applicantName: _nameController.text.trim(),
      nik: _nikController.text.trim(),
      noKk: _noKkController.text.trim(),
      phone: _phoneController.text.trim(),
      fullAddress: _addressController.text.trim(),
      monthlyIncome: _selectedIncome,
      dependentsCount: int.tryParse(_dependentsController.text.trim()) ?? 0,
      submittedDocuments: submittedDocs,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    // Tampilkan Dialog Sukses Resmi
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.statusSuccessBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: AppColors.statusSuccess, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Pendaftaran Berhasil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Permohonan bantuan Anda telah resmi terdaftar dalam basis data sistem verifikasi.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warmCreamLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nomor Registrasi Anda:',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  SelectableText(
                    newApp.registrationCode,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.forestGreen,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Simpan nomor registrasi di atas untuk melacak progres verifikasi pada menu Cek Status.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Tutup dialog
              Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
            },
            child: const Text('Kembali ke Beranda'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BantuAppBar(
        title: 'Formulir Pendaftaran Bantuan',
        subtitle: 'Layanan terpadu permohonan bantuan sosial',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Step Progress Bar (Clean, formal, not overwhelming)
          Container(
            color: AppColors.surfaceWhite,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildStepIndicator(1, 'Identitas Diri'),
                _buildStepConnector(1),
                _buildStepIndicator(2, 'Sosial Ekonomi'),
                _buildStepConnector(2),
                _buildStepIndicator(3, 'Dokumen & Konfirmasi'),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderLight),

          // Form Steps Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: _buildCurrentStepContent(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: const BoxDecoration(
          color: AppColors.surfaceWhite,
          border: Border(
            top: BorderSide(color: AppColors.borderLight, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              if (_currentStep > 1) ...[
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: _prevStep,
                    child: const Text('Sebelumnya'),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : (_currentStep == 3 ? _submitForm : _nextStep),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(_currentStep == 3 ? 'Kirim Pendaftaran' : 'Lanjutkan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep == step;
    final isDone = _currentStep > step;

    return Expanded(
      flex: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone
                  ? AppColors.forestGreen
                  : (isActive ? AppColors.forestGreenLight : AppColors.surfaceSubtle),
              border: Border.all(
                color: isDone || isActive ? AppColors.forestGreen : AppColors.borderMedium,
                width: 1,
              ),
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: AppColors.surfaceWhite)
                  : Text(
                      '$step',
                      style: AppTypography.labelSmall.copyWith(
                        color: isActive ? AppColors.surfaceWhite : AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: isActive || isDone ? AppColors.textPrimary : AppColors.textMuted,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(int step) {
    final isDone = _currentStep > step;
    return Expanded(
      flex: 1,
      child: Container(
        height: 2,
        color: isDone ? AppColors.forestGreen : AppColors.borderLight,
        margin: const EdgeInsets.only(bottom: 16),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Langkah 1: Program & Identitas',
            subtitle: 'Pastikan data pemohon sesuai dengan KTP elektronik',
          ),

          // Pilihan Program Bantuan
          const Text('Pilih Program Bantuan', style: AppTypography.titleSmall),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ProgramModel>(
                value: _selectedProgram,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textMuted),
                items: widget.repository.allPrograms.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text(
                      p.name,
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedProgram = val);
                },
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Nama Lengkap Sesuai KTP
          const Text('Nama Lengkap (Sesuai KTP)*', style: AppTypography.titleSmall),
          const SizedBox(height: 6),
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Nama lengkap wajib diisi sesuai KTP';
              }
              if (val.trim().length < 3) {
                return 'Nama terlalu pendek';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Contoh: Siti Rahmawati',
            ),
          ),

          const SizedBox(height: 18),

          // NIK (16 Digit)
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
              if (val == null || val.trim().isEmpty) {
                return 'NIK wajib diisi';
              }
              if (val.trim().length != 16) {
                return 'NIK harus terdiri dari 16 digit angka valid';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: '16 digit angka NIK',
              helperText: 'NIK akan divalidasi ke basis data kependudukan Dukcapil',
            ),
          ),

          const SizedBox(height: 18),

          // Nomor Kartu Keluarga (16 Digit)
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
              if (val == null || val.trim().isEmpty) {
                return 'Nomor KK wajib diisi';
              }
              if (val.trim().length != 16) {
                return 'Nomor KK harus terdiri dari 16 digit angka valid';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: '16 digit angka No. KK',
            ),
          ),

          const SizedBox(height: 18),

          // Nomor Telepon / WhatsApp Aktif
          const Text('Nomor Telepon / WhatsApp Aktif*', style: AppTypography.titleSmall),
          const SizedBox(height: 6),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(14),
            ],
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Nomor telepon aktif wajib diisi';
              }
              if (val.trim().length < 10) {
                return 'Masukkan nomor telepon yang valid (minimal 10 digit)';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Contoh: 081234567890',
              helperText: 'Akan digunakan petugas untuk mengabarkan jadwal verifikasi',
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Langkah 2: Sosial & Ekonomi',
            subtitle: 'Informasi kondisi tempat tinggal dan pendapatan keluarga',
          ),

          // Alamat Domisili Lengkap
          const Text('Alamat Lengkap Domisili*', style: AppTypography.titleSmall),
          const SizedBox(height: 6),
          TextFormField(
            controller: _addressController,
            maxLines: 3,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Alamat domisili lengkap wajib diisi';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Sebutkan nama jalan, nomor rumah, RT, RW, Kelurahan, Kecamatan',
            ),
          ),

          const SizedBox(height: 18),

          // Rata-rata Pendapatan Keluarga per Bulan
          const Text('Rata-rata Pendapatan Keluarga per Bulan*', style: AppTypography.titleSmall),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedIncome,
                isExpanded: true,
                items: _incomeOptions.map((inc) {
                  return DropdownMenuItem(
                    value: inc,
                    child: Text(inc, style: AppTypography.bodyMedium),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedIncome = val);
                },
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Jumlah Tanggungan Keluarga
          const Text('Jumlah Anggota Keluarga Tanggungan*', style: AppTypography.titleSmall),
          const SizedBox(height: 6),
          TextFormField(
            controller: _dependentsController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Jumlah tanggungan wajib diisi';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Contoh: 3',
              helperText: 'Jumlah anak atau lansia yang menjadi tanggungan hidup',
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Langkah 3: Kelengkapan Berkas & Konfirmasi',
          subtitle: 'Periksa kembali data sebelum mengirim pendaftaran resmi',
        ),

        // Ringkasan Pengajuan Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Program yang Dipilih:', style: AppTypography.bodySmall),
              const SizedBox(height: 2),
              Text(
                _selectedProgram?.name ?? '-',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.forestGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Divider(height: 20, color: AppColors.divider),
              _buildSummaryRow('Nama Pemohon', _nameController.text.trim()),
              _buildSummaryRow('NIK Pemohon', _nikController.text.trim()),
              _buildSummaryRow('No. KK', _noKkController.text.trim()),
              _buildSummaryRow('Telepon', _phoneController.text.trim()),
              _buildSummaryRow('Penghasilan', _selectedIncome),
              _buildSummaryRow('Tanggungan', '${_dependentsController.text.trim()} Orang'),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Kelengkapan Dokumen Berkas
        const Text('Dokumen Pendukung yang Tersedia:', style: AppTypography.titleSmall),
        const SizedBox(height: 8),

        CheckboxListTile(
          value: _docKtp,
          onChanged: (val) => setState(() => _docKtp = val ?? true),
          title: const Text('Fotokopi / Foto KTP Elektronik Asli', style: AppTypography.bodySmall),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.forestGreen,
        ),
        CheckboxListTile(
          value: _docKk,
          onChanged: (val) => setState(() => _docKk = val ?? true),
          title: const Text('Fotokopi / Foto Kartu Keluarga (KK)', style: AppTypography.bodySmall),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.forestGreen,
        ),
        CheckboxListTile(
          value: _docSktm,
          onChanged: (val) => setState(() => _docSktm = val ?? false),
          title: const Text('Surat Keterangan Tidak Mampu / Surat Rekomendasi RT/RW', style: AppTypography.bodySmall),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.forestGreen,
        ),

        const SizedBox(height: 16),

        // Pernyataan Kebenaran Data
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warmCreamLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderMedium),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _agreementAccepted,
                onChanged: (val) => setState(() => _agreementAccepted = val ?? false),
                activeColor: AppColors.forestGreen,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Saya menyatakan dengan sesungguhnya bahwa seluruh data dan dokumen yang saya sampaikan adalah benar. Apabila di kemudian hari terbukti ada kepalsuan data, saya bersedia menerima sanksi sesuai ketentuan hukum yang berlaku.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
          ),
          const Text(': ', style: AppTypography.bodySmall),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
