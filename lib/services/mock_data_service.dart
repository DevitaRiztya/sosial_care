import '../models/program_model.dart';
import '../models/application_model.dart';
import '../models/location_model.dart';
import '../models/notification_model.dart';
import '../models/user_profile_model.dart';

class MockDataService {
  MockDataService._();

  static UserProfileModel defaultProfile = const UserProfileModel(
    name: 'Siti Rahmawati',
    nik: '3201145607890003',
    noKk: '3201140203040001',
    phone: '081234567890',
    email: 'siti.rahmawati@email.com',
    fullAddress: 'Jl. Melati No. 14, RT 03 / RW 05',
    rtRw: '03 / 05',
    kelurahan: 'Cibubur',
    kecamatan: 'Ciracas',
    isDtksRegistered: true,
    dtksCategory: 'Desil 2 (Sangat Rentan)',
    verifiedDocuments: ['KTP Elektronik', 'Kartu Keluarga', 'Surat Keterangan Domisili'],
  );

  static List<ProgramModel> defaultPrograms = const [
    ProgramModel(
      id: 'prog-01',
      name: 'Bantuan Pangan Nontunai (BPNT) Sembako',
      category: 'Pangan Pokok',
      shortDescription: 'Paket sembako bulanan (beras, telur, kacang-kacangan) bagi keluarga pra-sejahtera terdaftar.',
      fullDescription:
          'Program Bantuan Pangan Nontunai disalurkan setiap bulan melalui e-Warong resmi untuk memenuhi kebutuhan gizi dasar keluarga penerima manfaat. Penerima berhak mendapatkan komoditas pangan pokok dengan nilai setara Rp 200.000 per bulan.',
      targetAudience: 'Keluarga dengan tingkat desil 1-3 dalam DTKS Kementerian Sosial',
      benefitSummary: 'Paket pangan pokok bulanan senilai Rp 200.000 / bulan',
      requirements: [
        'Warga Negara Indonesia dengan NIK dan KK valid',
        'Terdaftar dalam Data Terpadu Kesejahteraan Sosial (DTKS)',
        'Bukan merupakan ASN, TNI, POLRI, atau pegawai BUMN/BUMD',
        'Memiliki Kartu Keluarga Sejahtera (KKS) atau surat keterangan penetapan',
      ],
      requiredDocuments: ['KTP Pemohon', 'Kartu Keluarga', 'Surat Keterangan DTKS / Domisili'],
      quotaInfo: 'Alokasi Tahap 4: 15.000 KPM Wilayah DKI & Sekitarnya',
      periodInfo: 'Penyaluran: Tanggal 5 - 20 setiap bulan',
      agency: 'Dinas Sosial & Pusdatin Kesos',
      isPriority: true,
    ),
    ProgramModel(
      id: 'prog-02',
      name: 'Bantuan Pendidikan Siswa Sejahtera (BPSS)',
      category: 'Pendidikan',
      shortDescription: 'Dukungan perlengkapan sekolah dan dana pendidikan bagi siswa SD hingga SMA sederajat.',
      fullDescription:
          'Program beasiswa perlengkapan dan operasional sekolah ditujukan untuk mencegah angka putus sekolah pada anak usia pendidikan dasar hingga menengah. Bantuan disalurkan per semester langsung ke rekening tabungan siswa di bank mitra pemerintah.',
      targetAudience: 'Peserta didik aktif tingkat SD, SMP, SMA/SMK dari keluarga pra-sejahtera',
      benefitSummary: 'Dana bantuan pendidikan Rp 450.000 - Rp 1.000.000 / semester',
      requirements: [
        'Anak usia 6-21 tahun yang terdaftar di sekolah negeri/swasta resmi',
        'Memiliki Nomor Induk Siswa Nasional (NISN)',
        'Orang tua berpenghasilan di bawah upah minimum regional',
        'Surat keterangan aktif sekolah dari kepala sekolah',
      ],
      requiredDocuments: ['KTP Orang Tua/Wali', 'Kartu Keluarga', 'Kartu Pelajar / Surat Keterangan Sekolah'],
      quotaInfo: 'Tersedia 3.200 kuota beasiswa semester ganjil',
      periodInfo: 'Pendaftaran gelombang 2 hingga 15 November 2026',
      agency: 'Dinas Pendidikan & Dinas Sosial',
      isPriority: true,
    ),
    ProgramModel(
      id: 'prog-03',
      name: 'Bantuan Alat Bantu Disabilitas Fisik & Sensorik',
      category: 'Disabilitas',
      shortDescription: 'Penyediaan kursi roda, kruk, alat bantu dengar, dan tongkat adaptif gratis.',
      fullDescription:
          'Pemerintah menyediakan sarana mobilitas dan aksesibilitas untuk penyandang disabilitas fisik maupun sensorik. Alat bantu disesuaikan dengan hasil asesmen medis dan diantar langsung ke alamat penerima atau melalui posko kelurahan terdekat.',
      targetAudience: 'Penyandang disabilitas dari keluarga rentan sosial dan lansia tidak mandiri',
      benefitSummary: 'Alat bantu adaptif fisik/sensorik sesuai rekomendasi medis',
      requirements: [
        'Penyandang disabilitas dengan KTP/KIA domisili setempat',
        'Surat rekomendasi medis atau hasil asesmen pekerja sosial',
        'Belum pernah menerima alat bantu sejenis dalam 2 tahun terakhir',
      ],
      requiredDocuments: ['KTP / Akta Kelahiran', 'Kartu Keluarga', 'Surat Keterangan Medis / Faskes'],
      quotaInfo: 'Penyaluran bertahap 850 unit alat bantu mobilitas',
      periodInfo: 'Buka sepanjang tahun anggaran berjalan',
      agency: 'Balai Rehabilitasi Sosial & Dinas Sosial',
      isPriority: true,
    ),
    ProgramModel(
      id: 'prog-04',
      name: 'Bantuan Layanan Kesehatan Khusus Lansia Mandiri',
      category: 'Kesehatan',
      shortDescription: 'Pemeriksaan kesehatan berkala dan paket nutrisi tambahan khusus lansia usia 60+.',
      fullDescription:
          'Fasilitas pemantauan kesehatan rutin di puskesmas rujukan beserta subsidi suplemen gizi, vitamin, dan pemenuhan makanan sehat bergizi seimbang untuk meningkatkan kualitas hidup lansia pra-sejahtera.',
      targetAudience: 'Warga lanjut usia (60 tahun ke atas) berpenghasilan rendah atau sebatang kara',
      benefitSummary: 'Paket nutrisi bulanan & pemeriksaan tensi/darah berkala gratis',
      requirements: [
        'Berusia minimal 60 tahun terhitung saat pengajuan',
        'Memiliki KTP dan bertempat tinggal di wilayah sasaran',
        'Terdaftar di Posyandu Lansia atau Puskesmas setempat',
      ],
      requiredDocuments: ['KTP Lansia', 'Kartu Keluarga', 'Buku Pemeriksaan Lansia (jika ada)'],
      quotaInfo: 'Kuota 4.500 penerima manfaat wilayah binaan',
      periodInfo: 'Jadwal distribusi: Minggu kedua setiap bulan',
      agency: 'Dinas Kesehatan bekerjasama dengan Dinas Sosial',
      isPriority: false,
    ),
    ProgramModel(
      id: 'prog-05',
      name: 'Bantuan Stimulan Modal Usaha Ekonomi Produktif (UEP)',
      category: 'Modal Usaha',
      shortDescription: 'Bantuan modal peralatan dan pelatihan keterampilan bagi usaha mikro rumahan pra-sejahtera.',
      fullDescription:
          'Program pemberdayaan ekonomi keluarga untuk membantu usaha mikro keluarga pra-sejahtera berkembang secara mandiri. Meliputi bantuan sarana usaha (bukan pinjaman) dan pendampingan pengelolaan keuangan oleh penyuluh sosial lapangan.',
      targetAudience: 'Kepala keluarga atau anggota keluarga yang memiliki embrio usaha rumahan',
      benefitSummary: 'Bantuan modal alat usaha senilai Rp 2.500.000 & pendampingan',
      requirements: [
        'Memiliki usaha mikro yang telah berjalan minimal 3 bulan',
        'Keluarga terdaftar dalam DTKS kategori pra-sejahtera',
        'Sanggup mengikuti 2 sesi pembekalan kewirausahaan dasar',
        'Tidak sedang menerima kredit perbankan komersial berbunga',
      ],
      requiredDocuments: ['KTP & KK', 'Surat Keterangan Usaha dari RT/RW', 'Foto Tempat Usaha / Produk'],
      quotaInfo: 'Kuota 1.200 wirausaha mikro pemula',
      periodInfo: 'Seleksi berkas ditutup akhir bulan ini',
      agency: 'Dinas Koperasi, UKM, & Dinas Sosial',
      isPriority: false,
    ),
  ];

  static List<ApplicationModel> defaultApplications = [
    ApplicationModel(
      id: 'app-01',
      registrationCode: 'REG-2026-0819',
      programId: 'prog-01',
      programName: 'Bantuan Pangan Nontunai (BPNT) Sembako',
      applicantName: 'Siti Rahmawati',
      nik: '3201145607890003',
      noKk: '3201140203040001',
      phone: '081234567890',
      fullAddress: 'Jl. Melati No. 14, RT 03 / RW 05, Kel. Cibubur, Kec. Ciracas',
      monthlyIncome: 'Rp 800.000 - Rp 1.500.000',
      dependentsCount: 3,
      status: ApplicationStatus.surveiLapangan,
      statusLabel: 'Verifikasi Faktual Lapangan',
      statusDescription:
          'Petugas pendamping sosial sedang menjadwalkan kunjungan verifikasi lapangan untuk memvalidasi kondisi tempat tinggal dan data keluarga.',
      submissionDate: '18 Oktober 2026',
      lastUpdatedDate: '26 Oktober 2026',
      submittedDocuments: ['KTP Pemohon', 'Kartu Keluarga', 'Surat Keterangan DTKS'],
      timeline: const [
        StatusStep(
          title: 'Pengajuan Berkas Diterima',
          description: 'Berkas permohonan telah terdaftar secara sistematis dalam basis data.',
          date: '18 Okt 2026, 09.30 WIB',
          isCompleted: true,
          isCurrent: false,
        ),
        StatusStep(
          title: 'Verifikasi Data Kependudukan',
          description: 'NIK dan No. KK berhasil dicocokkan dengan basis data Dukcapil dan DTKS.',
          date: '21 Okt 2026, 14.15 WIB',
          isCompleted: true,
          isCurrent: false,
        ),
        StatusStep(
          title: 'Verifikasi Faktual Lapangan',
          description: 'Pemeriksaan lapangan bersama RT/RW setempat. Petugas akan menghubungi sebelum kunjungan.',
          date: '26 Okt 2026, 11.00 WIB',
          isCompleted: false,
          isCurrent: true,
        ),
        StatusStep(
          title: 'Keputusan Verifikator Wilayah',
          description: 'Penetapan status kelayakan penerima manfaat oleh tim verifikator dinas sosial.',
          date: null,
          isCompleted: false,
          isCurrent: false,
        ),
        StatusStep(
          title: 'Penyaluran Bantuan Sosial',
          description: 'Pengambilan paket pangan sembako di e-Warong resmi terdekat.',
          date: null,
          isCompleted: false,
          isCurrent: false,
        ),
      ],
    ),
    ApplicationModel(
      id: 'app-02',
      registrationCode: 'REG-2026-0542',
      programId: 'prog-02',
      programName: 'Bantuan Pendidikan Siswa Sejahtera (BPSS)',
      applicantName: 'Siti Rahmawati (Untuk: Dimas Pratama)',
      nik: '3201145607890003',
      noKk: '3201140203040001',
      phone: '081234567890',
      fullAddress: 'Jl. Melati No. 14, RT 03 / RW 05, Kel. Cibubur, Kec. Ciracas',
      monthlyIncome: 'Rp 800.000 - Rp 1.500.000',
      dependentsCount: 3,
      status: ApplicationStatus.disetujui,
      statusLabel: 'Disetujui - Menunggu Jadwal Salur',
      statusDescription:
          'Pengajuan beasiswa pendidikan telah lolos verifikasi dan disetujui. Dana akan disalurkan pada jadwal penyaluran semester berjalan.',
      submissionDate: '02 September 2026',
      lastUpdatedDate: '24 Oktober 2026',
      submittedDocuments: ['KTP Orang Tua', 'Kartu Keluarga', 'Surat Keterangan Sekolah Aktif'],
      timeline: const [
        StatusStep(
          title: 'Pengajuan Berkas Diterima',
          description: 'Dokumen pendaftaran telah diterima sistem.',
          date: '02 Sep 2026, 10.12 WIB',
          isCompleted: true,
          isCurrent: false,
        ),
        StatusStep(
          title: 'Validasi NISN & Data Siswa',
          description: 'Data peserta didik terkonfirmasi aktif di Dapodik.',
          date: '10 Sep 2026, 13.40 WIB',
          isCompleted: true,
          isCurrent: false,
        ),
        StatusStep(
          title: 'Verifikasi Kondisi Ekonomi',
          description: 'Penilaian kelayakan sosial ekonomi keluarga memenuhi kriteria bantuan.',
          date: '28 Sep 2026, 09.20 WIB',
          isCompleted: true,
          isCurrent: false,
        ),
        StatusStep(
          title: 'Penerbitan Surat Keputusan (SK)',
          description: 'Penerima resmi ditetapkan dalam SK Kepala Dinas Pendidikan.',
          date: '24 Okt 2026, 15.00 WIB',
          isCompleted: true,
          isCurrent: true,
        ),
        StatusStep(
          title: 'Penyaluran Dana ke Rekening Siswa',
          description: 'Pencairan dana bantuan pendidikan ke rekening Bank DKI siswa.',
          date: null,
          isCompleted: false,
          isCurrent: false,
        ),
      ],
    ),
  ];

  static List<LocationModel> defaultLocations = const [
    LocationModel(
      id: 'loc-01',
      name: 'Kantor Suku Dinas Sosial Jakarta Timur',
      type: 'Kantor Dinas Sosial',
      address: 'Jl. Pemuda No. 74, Rawamangun, Pulo Gadung',
      district: 'Jakarta Timur',
      operatingHours: 'Senin - Jumat, 08.00 - 15.30 WIB',
      phone: '(021) 4892434',
      distanceKm: 2.4,
      isOpen: true,
    ),
    LocationModel(
      id: 'loc-02',
      name: 'Posko Penyaluran Bantuan & e-Warong Ciracas',
      type: 'Posko Penyaluran',
      address: 'Jl. Raya Bogor KM 24, Komplek Pasar Ciracas',
      district: 'Ciracas',
      operatingHours: 'Senin - Sabtu, 08.30 - 16.00 WIB',
      phone: '0813-8822-1920',
      distanceKm: 1.1,
      isOpen: true,
    ),
    LocationModel(
      id: 'loc-03',
      name: 'Puskesmas Kecamatan Ciracas (Rujukan Nutrisi)',
      type: 'Fasilitas Kesehatan',
      address: 'Jl. H. Baping No. 42, RT 06 / RW 09, Ciracas',
      district: 'Ciracas',
      operatingHours: 'Setiap Hari 24 Jam (Layanan Umum s/d 16.00)',
      phone: '(021) 8710321',
      distanceKm: 1.8,
      isOpen: true,
    ),
    LocationModel(
      id: 'loc-04',
      name: 'Balai Rehabilitasi Sosial & Alat Bantu Bina Netra',
      type: 'Kantor Dinas Sosial',
      address: 'Jl. Ceger Raya No. 12, Cipayung',
      district: 'Cipayung',
      operatingHours: 'Senin - Jumat, 08.00 - 15.00 WIB',
      phone: '(021) 8443912',
      distanceKm: 3.7,
      isOpen: true,
    ),
  ];

  static List<NotificationModel> defaultNotifications = const [
    NotificationModel(
      id: 'notif-01',
      title: 'Jadwal Survei Lapangan Pengajuan BPNT',
      message:
          'Pengajuan registrasi REG-2026-0819 telah memasuki tahap survei lapangan. Pastikan dokumen asli KTP dan KK dapat diperlihatkan kepada petugas.',
      category: 'Status Pengajuan',
      date: '26 Okt 2026',
      isRead: false,
      relatedCode: 'REG-2026-0819',
    ),
    NotificationModel(
      id: 'notif-02',
      title: 'SK Penetapan Bantuan Pendidikan Terbit',
      message:
          'Selamat, pengajuan beasiswa siswa Dimas Pratama (REG-2026-0542) telah resmi disetujui. Unduh bukti persetujuan pada menu Cek Status.',
      category: 'Status Pengajuan',
      date: '24 Okt 2026',
      isRead: false,
      relatedCode: 'REG-2026-0542',
    ),
    NotificationModel(
      id: 'notif-03',
      title: 'Pemberitahuan: Layanan Bebas Pungutan Liar',
      message:
          'Seluruh proses pendaftaran, verifikasi, dan penyaluran bantuan sosial adalah GRATIS. Laporkan oknum pemungut biaya melalui nomor pengaduan resmi 1500-771.',
      category: 'Pengumuman Resmi',
      date: '20 Okt 2026',
      isRead: true,
    ),
  ];
}
