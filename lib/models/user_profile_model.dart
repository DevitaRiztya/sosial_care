class UserProfileModel {
  final String name;
  final String nik;
  final String noKk;
  final String phone;
  final String email;
  final String fullAddress;
  final String rtRw;
  final String kelurahan;
  final String kecamatan;
  final bool isDtksRegistered;
  final String dtksCategory;
  final List<String> verifiedDocuments;

  const UserProfileModel({
    required this.name,
    required this.nik,
    required this.noKk,
    required this.phone,
    required this.email,
    required this.fullAddress,
    required this.rtRw,
    required this.kelurahan,
    required this.kecamatan,
    required this.isDtksRegistered,
    required this.dtksCategory,
    required this.verifiedDocuments,
  });

  String get maskedNik {
    if (nik.length >= 16) {
      return '${nik.substring(0, 6)}******${nik.substring(12)}';
    }
    return nik;
  }

  String get maskedNoKk {
    if (noKk.length >= 16) {
      return '${noKk.substring(0, 6)}******${noKk.substring(12)}';
    }
    return noKk;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'nik': nik,
        'noKk': noKk,
        'phone': phone,
        'email': email,
        'fullAddress': fullAddress,
        'rtRw': rtRw,
        'kelurahan': kelurahan,
        'kecamatan': kecamatan,
        'isDtksRegistered': isDtksRegistered,
        'dtksCategory': dtksCategory,
        'verifiedDocuments': verifiedDocuments,
      };

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        name: json['name'] as String,
        nik: json['nik'] as String,
        noKk: json['noKk'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
        fullAddress: json['fullAddress'] as String,
        rtRw: json['rtRw'] as String,
        kelurahan: json['kelurahan'] as String,
        kecamatan: json['kecamatan'] as String,
        isDtksRegistered: json['isDtksRegistered'] as bool,
        dtksCategory: json['dtksCategory'] as String,
        verifiedDocuments: List<String>.from(json['verifiedDocuments'] as List),
      );
}
