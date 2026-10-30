enum ApplicationStatus {
  diajukan,
  verifikasiAdministrasi,
  surveiLapangan,
  disetujui,
  disalurkan,
  ditolak,
}

class StatusStep {
  final String title;
  final String description;
  final String? date;
  final bool isCompleted;
  final bool isCurrent;

  const StatusStep({
    required this.title,
    required this.description,
    this.date,
    required this.isCompleted,
    required this.isCurrent,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'date': date,
        'isCompleted': isCompleted,
        'isCurrent': isCurrent,
      };

  factory StatusStep.fromJson(Map<String, dynamic> json) => StatusStep(
        title: json['title'] as String,
        description: json['description'] as String,
        date: json['date'] as String?,
        isCompleted: json['isCompleted'] as bool,
        isCurrent: json['isCurrent'] as bool,
      );
}

class ApplicationModel {
  final String id;
  final String registrationCode; // Contoh: REG-2026-0819
  final String programId;
  final String programName;
  final String applicantName;
  final String nik;
  final String noKk;
  final String phone;
  final String fullAddress;
  final String monthlyIncome;
  final int dependentsCount;
  final ApplicationStatus status;
  final String statusLabel;
  final String statusDescription;
  final String submissionDate;
  final String lastUpdatedDate;
  final List<String> submittedDocuments;
  final List<StatusStep> timeline;

  const ApplicationModel({
    required this.id,
    required this.registrationCode,
    required this.programId,
    required this.programName,
    required this.applicantName,
    required this.nik,
    required this.noKk,
    required this.phone,
    required this.fullAddress,
    required this.monthlyIncome,
    required this.dependentsCount,
    required this.status,
    required this.statusLabel,
    required this.statusDescription,
    required this.submissionDate,
    required this.lastUpdatedDate,
    required this.submittedDocuments,
    required this.timeline,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'registrationCode': registrationCode,
        'programId': programId,
        'programName': programName,
        'applicantName': applicantName,
        'nik': nik,
        'noKk': noKk,
        'phone': phone,
        'fullAddress': fullAddress,
        'monthlyIncome': monthlyIncome,
        'dependentsCount': dependentsCount,
        'status': status.name,
        'statusLabel': statusLabel,
        'statusDescription': statusDescription,
        'submissionDate': submissionDate,
        'lastUpdatedDate': lastUpdatedDate,
        'submittedDocuments': submittedDocuments,
        'timeline': timeline.map((e) => e.toJson()).toList(),
      };

  factory ApplicationModel.fromJson(Map<String, dynamic> json) => ApplicationModel(
        id: json['id'] as String,
        registrationCode: json['registrationCode'] as String,
        programId: json['programId'] as String,
        programName: json['programName'] as String,
        applicantName: json['applicantName'] as String,
        nik: json['nik'] as String,
        noKk: json['noKk'] as String,
        phone: json['phone'] as String,
        fullAddress: json['fullAddress'] as String,
        monthlyIncome: json['monthlyIncome'] as String,
        dependentsCount: json['dependentsCount'] as int,
        status: ApplicationStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => ApplicationStatus.diajukan,
        ),
        statusLabel: json['statusLabel'] as String,
        statusDescription: json['statusDescription'] as String,
        submissionDate: json['submissionDate'] as String,
        lastUpdatedDate: json['lastUpdatedDate'] as String,
        submittedDocuments: List<String>.from(json['submittedDocuments'] as List),
        timeline: (json['timeline'] as List)
            .map((e) => StatusStep.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
