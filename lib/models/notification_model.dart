class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String category; // 'Status Pengajuan', 'Penyaluran', 'Pengumuman Resmi'
  final String date;
  final bool isRead;
  final String? relatedCode;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.date,
    this.isRead = false,
    this.relatedCode,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      category: category,
      date: date,
      isRead: isRead ?? this.isRead,
      relatedCode: relatedCode,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'category': category,
        'date': date,
        'isRead': isRead,
        'relatedCode': relatedCode,
      };

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        category: json['category'] as String,
        date: json['date'] as String,
        isRead: json['isRead'] as bool? ?? false,
        relatedCode: json['relatedCode'] as String?,
      );
}
