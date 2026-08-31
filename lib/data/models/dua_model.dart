class DuaModel {
  final String id;
  final String title;
  final String waqt;
  final String details;
  final String audioUrl;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  DuaModel({
    required this.id,
    required this.title,
    required this.waqt,
    required this.details,
    required this.audioUrl,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      waqt: json['waqt'] ?? '',
      details: json['details'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
