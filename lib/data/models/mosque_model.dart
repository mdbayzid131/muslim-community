class MosqueModel {
  final String id;
  final String name;
  final String address;
  final String description;
  final String image;
  final String distance;
  final String nextPrayer;
  final double latitude;
  final double longitude;
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String jummah;
  final String mapLink;
  final String website;

  MosqueModel({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.image,
    required this.distance,
    required this.nextPrayer,
    required this.latitude,
    required this.longitude,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.jummah,
    required this.mapLink,
    required this.website,
  });

  factory MosqueModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    final distVal = json['distanceInKm'] ?? json['distance'];
    String distanceStr = '0.0 km';
    if (distVal is num) {
      distanceStr = '${distVal.toStringAsFixed(1)} km';
    } else if (distVal is String) {
      distanceStr = distVal;
    }

    final String nameStr =
        json['mosqueName'] ?? json['name'] ?? 'Unknown Mosque';

    String img = json['image'] ?? json['imagePath'] ?? '';
    if (img.isEmpty) {
      final String nameLower = nameStr.toLowerCase();
      if (nameLower.contains('central')) {
        img = 'assets/image/mosque01.png';
      } else if (nameLower.contains('east')) {
        img = 'assets/image/mosque2.png';
      } else {
        img = 'assets/image/mosque03.png';
      }
    }

    final Map<String, dynamic> prayers =
        json['prayerTimes'] ?? json['prayers'] ?? {};

    String nextPr = json['nextPrayer'] ?? json['prayerTime'] ?? '';
    if (nextPr.isEmpty) {
      final asrTime = prayers['asr'] ?? '15:30';
      nextPr = 'Asr at $asrTime';
    }

    final double latVal = parseDouble(json['latitude'] ?? json['lat']);
    final double lngVal = parseDouble(json['longitude'] ?? json['lng']);

    final String mapLinkStr = json['mapLink'] ??
        (latVal != 0.0 && lngVal != 0.0
            ? 'https://www.google.com/maps/search/?api=1&query=$latVal,$lngVal'
            : '');

    return MosqueModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: nameStr,
      address: json['address'] ?? 'No address provided',
      description: json['description'] ??
          'A beautiful and serene mosque serving the local and wider community with daily prayers, educational classes, and community events.',
      image: img,
      distance: distanceStr,
      nextPrayer: nextPr,
      latitude: latVal,
      longitude: lngVal,
      fajr: prayers['fajr'] ?? json['fajr'] ?? '04:15',
      dhuhr: prayers['dhuhr'] ?? json['dhuhr'] ?? '13:05',
      asr: prayers['asr'] ?? json['asr'] ?? '15:30',
      maghrib: prayers['maghrib'] ?? json['maghrib'] ?? '20:15',
      isha: prayers['isha'] ?? json['isha'] ?? '21:45',
      jummah: prayers['jummah'] ?? json['jummah'] ?? '13:15',
      mapLink: mapLinkStr,
      website: json['website'] ?? '',
    );
  }
}
