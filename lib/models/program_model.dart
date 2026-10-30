class ProgramModel {
  final String id;
  final String name;
  final String category; // 'Pangan Pokok', 'Pendidikan', 'Kesehatan', 'Disabilitas', 'Modal Usaha'
  final String shortDescription;
  final String fullDescription;
  final String targetAudience;
  final String benefitSummary;
  final List<String> requirements;
  final List<String> requiredDocuments;
  final String quotaInfo;
  final String periodInfo;
  final String agency;
  final bool isPriority;

  const ProgramModel({
    required this.id,
    required this.name,
    required this.category,
    required this.shortDescription,
    required this.fullDescription,
    required this.targetAudience,
    required this.benefitSummary,
    required this.requirements,
    required this.requiredDocuments,
    required this.quotaInfo,
    required this.periodInfo,
    required this.agency,
    this.isPriority = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'shortDescription': shortDescription,
        'fullDescription': fullDescription,
        'targetAudience': targetAudience,
        'benefitSummary': benefitSummary,
        'requirements': requirements,
        'requiredDocuments': requiredDocuments,
        'quotaInfo': quotaInfo,
        'periodInfo': periodInfo,
        'agency': agency,
        'isPriority': isPriority,
      };

  factory ProgramModel.fromJson(Map<String, dynamic> json) => ProgramModel(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        shortDescription: json['shortDescription'] as String,
        fullDescription: json['fullDescription'] as String,
        targetAudience: json['targetAudience'] as String,
        benefitSummary: json['benefitSummary'] as String,
        requirements: List<String>.from(json['requirements'] as List),
        requiredDocuments: List<String>.from(json['requiredDocuments'] as List),
        quotaInfo: json['quotaInfo'] as String,
        periodInfo: json['periodInfo'] as String,
        agency: json['agency'] as String,
        isPriority: json['isPriority'] as bool? ?? false,
      );
}
