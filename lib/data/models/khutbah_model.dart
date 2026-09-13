class KhutbahModel {
  final String id;
  final String title;
  final String mosqueName;
  final String imam;
  final DateTime date;
  final String description;
  final String audioUrl;
  final String thumbnailUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  KhutbahModel({
    required this.id,
    required this.title,
    required this.mosqueName,
    required this.imam,
    required this.date,
    required this.description,
    required this.audioUrl,
    required this.thumbnailUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  String get speaker => imam;

  factory KhutbahModel.fromJson(Map<String, dynamic> json) {
    return KhutbahModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString().trim() ?? 'Blessed Khutbah',
      mosqueName: json['mosqueName']?.toString().trim() ?? 'Local Mosque',
      imam: (json['imam'] ?? json['speaker'])?.toString().trim() ?? 'Sheikh',
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      description: json['description']?.toString().trim() ?? '',
      audioUrl: (json['audioUrl'] ?? json['audio'])?.toString().trim() ?? '',
      thumbnailUrl: (json['thumbnailUrl'] ?? json['thumbnail'] ?? json['image'])
              ?.toString()
              .trim() ??
          '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'mosqueName': mosqueName,
      'imam': imam,
      'date': date.toIso8601String(),
      'description': description,
      'audioUrl': audioUrl,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
