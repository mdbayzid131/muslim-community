import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/modules/home/controller/prayer_time_controller.dart';

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
  final double rating;
  final int totalRatings;
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
    this.rating = 4.8,
    this.totalRatings = 0,
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
    } else if (json['distanceInMeters'] != null) {
      final meters = parseDouble(json['distanceInMeters']);
      if (meters >= 1000) {
        distanceStr = '${(meters / 1000).toStringAsFixed(1)} km';
      } else {
        distanceStr = '${meters.toInt()} m';
      }
    }

    final String nameStr =
        json['mosqueName'] ?? json['name'] ?? 'Unknown Mosque';

    String img = json['image'] ?? json['imagePath'] ?? json['photoUrl'] ?? '';
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

    final double ratingVal = parseDouble(json['rating'] ?? 4.8);
    final int ratingsCount = json['totalRatings'] is int
        ? json['totalRatings']
        : int.tryParse(json['totalRatings']?.toString() ?? '0') ?? 0;

    return MosqueModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? json['placeId']?.toString() ?? '',
      name: nameStr,
      address: json['address'] ?? json['vicinity'] ?? 'No address provided',
      description: json['description'] ??
          'A beautiful and serene mosque serving the local and wider community with daily prayers, educational classes, and community events.',
      image: img,
      distance: distanceStr,
      nextPrayer: nextPr,
      latitude: latVal,
      longitude: lngVal,
      rating: ratingVal > 0 ? ratingVal : 4.8,
      totalRatings: ratingsCount,
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

  factory MosqueModel.fromGooglePlace(
    Map<String, dynamic> json, {
    double? userLat,
    double? userLng,
  }) {
    final String placeId = json['place_id']?.toString() ?? '';
    final String name = json['name']?.toString() ?? 'Mosque';
    final String address = json['vicinity']?.toString() ??
        json['formatted_address']?.toString() ??
        'No address available';

    final geometry = json['geometry'] as Map<String, dynamic>?;
    final location = geometry?['location'] as Map<String, dynamic>?;
    final double placeLat = (location?['lat'] as num?)?.toDouble() ?? 0.0;
    final double placeLng = (location?['lng'] as num?)?.toDouble() ?? 0.0;

    // Calculate distance
    String distanceStr = '0.0 km';
    if (userLat != null && userLng != null && placeLat != 0.0 && placeLng != 0.0) {
      final double distanceInMeters = Geolocator.distanceBetween(
        userLat,
        userLng,
        placeLat,
        placeLng,
      );
      if (distanceInMeters >= 1000) {
        distanceStr = '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
      } else {
        distanceStr = '${distanceInMeters.round()} m';
      }
    }

    // Photo URL
    String photoUrl = '';
    final photos = json['photos'] as List?;
    if (photos != null && photos.isNotEmpty) {
      final photoRef = photos[0]['photo_reference']?.toString();
      if (photoRef != null && photoRef.isNotEmpty) {
        photoUrl =
            'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoRef&key=${ApiConstants.googlePlacesApiKey}';
      }
    }
    if (photoUrl.isEmpty) {
      final nameLower = name.toLowerCase();
      if (nameLower.contains('central')) {
        photoUrl = 'assets/image/mosque01.png';
      } else if (nameLower.contains('east')) {
        photoUrl = 'assets/image/mosque2.png';
      } else {
        photoUrl = 'assets/image/mosque03.png';
      }
    }

    final double ratingVal = (json['rating'] as num?)?.toDouble() ?? 4.8;
    final int ratingsCount = (json['user_ratings_total'] as num?)?.toInt() ?? 120;

    final String mapLink = placeLat != 0.0 && placeLng != 0.0
        ? 'https://www.google.com/maps/search/?api=1&query=$placeLat,$placeLng'
        : 'https://www.google.com/maps/place/?q=place_id:$placeId';

    String fajrVal = '04:15';
    String dhuhrVal = '13:05';
    String asrVal = '15:30';
    String maghribVal = '20:15';
    String ishaVal = '21:45';
    String jummahVal = '13:05';
    String nextPr = 'Asr at 15:30';

    try {
      if (Get.isRegistered<PrayerTimeController>()) {
        final pt = Get.find<PrayerTimeController>();
        if (pt.fajr.value != '--:--' && pt.fajr.value.isNotEmpty) fajrVal = pt.fajr.value;
        if (pt.dhuhr.value != '--:--' && pt.dhuhr.value.isNotEmpty) {
          dhuhrVal = pt.dhuhr.value;
          jummahVal = pt.dhuhr.value;
        }
        if (pt.asr.value != '--:--' && pt.asr.value.isNotEmpty) asrVal = pt.asr.value;
        if (pt.maghrib.value != '--:--' && pt.maghrib.value.isNotEmpty) maghribVal = pt.maghrib.value;
        if (pt.isha.value != '--:--' && pt.isha.value.isNotEmpty) ishaVal = pt.isha.value;
        if (pt.nextPrayerName.value.isNotEmpty && pt.nextPrayerTime.value.isNotEmpty) {
          nextPr = '${pt.nextPrayerName.value} at ${pt.nextPrayerTime.value}';
        }
      }
    } catch (_) {}

    return MosqueModel(
      id: placeId,
      name: name,
      address: address,
      description:
          'A local place of worship and community gathering providing daily prayers and community services.',
      image: photoUrl,
      distance: distanceStr,
      nextPrayer: nextPr,
      latitude: placeLat,
      longitude: placeLng,
      rating: ratingVal,
      totalRatings: ratingsCount,
      fajr: fajrVal,
      dhuhr: dhuhrVal,
      asr: asrVal,
      maghrib: maghribVal,
      isha: ishaVal,
      jummah: jummahVal,
      mapLink: mapLink,
      website: 'https://www.google.com/maps/place/?q=place_id:$placeId',
    );
  }
}
