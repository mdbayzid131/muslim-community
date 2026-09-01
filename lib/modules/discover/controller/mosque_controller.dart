import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/mosque_model.dart';
import 'package:muslim_community/data/repositories/mosque_repository.dart';

class MosqueController extends GetxController {
  final MosqueRepository mosqueRepository;

  MosqueController({required this.mosqueRepository});

  final mosques = <MosqueModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNearbyMosques();
  }

  Future<void> fetchNearbyMosques({
    bool isSilent = false,
    String? search,
    double radius = 5000,
  }) async {
    if (!isSilent) isLoading.value = true;
    try {
      double latitude = 51.5074; // London fallback
      double longitude = -0.1278;

      try {
        final position = await Geolocator.getLastKnownPosition() ??
            await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low,
              timeLimit: const Duration(seconds: 3),
            );

        latitude = position.latitude;
        longitude = position.longitude;
      } catch (e) {
        Helpers.error("Geolocator for mosques error: $e");
      }

      final activeSearch = search ?? (searchQuery.value.isNotEmpty ? searchQuery.value : null);

      final response = await mosqueRepository.getNearbyMosques(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        search: activeSearch,
      );

      if (response.statusCode == 200) {
        final List list = response.data['data'] ?? response.data ?? [];
        if (list.isNotEmpty) {
          mosques.value = list.map((item) => MosqueModel.fromJson(item)).toList();
        } else {
          // If server returns empty list, show curated fallback matching search
          _loadFallbackMosques(activeSearch);
        }
      } else {
        _loadFallbackMosques(activeSearch);
      }
    } catch (e) {
      Helpers.error("Error fetching mosques: $e");
      _loadFallbackMosques(searchQuery.value);
    } finally {
      if (!isSilent) isLoading.value = false;
    }
  }

  void searchMosques(String query) {
    searchQuery.value = query;
    fetchNearbyMosques(search: query);
  }

  void _loadFallbackMosques(String? query) {
    final defaultMosques = [
      MosqueModel(
        id: '1',
        name: 'East London Mosque',
        address: '82-92 Whitechapel Rd, London E1 1JQ',
        description:
            'One of the largest mosques in the UK, welcoming thousands of worshippers daily.',
        image: 'assets/image/mosque2.png',
        distance: '1.2 km',
        nextPrayer: 'Asr at 15:30',
        latitude: 51.5186,
        longitude: -0.0658,
        rating: 4.8,
        totalRatings: 1850,
        fajr: '04:30',
        dhuhr: '13:15',
        asr: '15:30',
        maghrib: '20:15',
        isha: '21:45',
        jummah: '13:15',
        mapLink: 'https://maps.google.com/?q=East+London+Mosque',
        website: 'https://www.eastlondonmosque.org.uk',
      ),
      MosqueModel(
        id: '2',
        name: 'London Central Mosque (Regent\'s Park)',
        address: '146 Park Rd, London NW8 7RG',
        description:
            'The Islamic Cultural Centre and London Central Mosque in Regent\'s Park.',
        image: 'assets/image/mosque01.png',
        distance: '2.5 km',
        nextPrayer: 'Asr at 15:30',
        latitude: 51.5286,
        longitude: -0.1658,
        rating: 4.9,
        totalRatings: 2420,
        fajr: '04:15',
        dhuhr: '13:00',
        asr: '15:30',
        maghrib: '20:10',
        isha: '21:30',
        jummah: '13:00',
        mapLink: 'https://maps.google.com/?q=London+Central+Mosque',
        website: 'https://www.iccuk.org',
      ),
      MosqueModel(
        id: '3',
        name: 'Finsbury Park Mosque',
        address: '7-11 St Thomas\'s Rd, London N4 2QH',
        description:
            'A vibrant community mosque dedicated to serving local Muslims and promoting interfaith dialogue.',
        image: 'assets/image/mosque03.png',
        distance: '3.8 km',
        nextPrayer: 'Asr at 15:30',
        latitude: 51.5644,
        longitude: -0.1065,
        rating: 4.7,
        totalRatings: 940,
        fajr: '04:20',
        dhuhr: '13:10',
        asr: '15:30',
        maghrib: '20:15',
        isha: '21:40',
        jummah: '13:15',
        mapLink: 'https://maps.google.com/?q=Finsbury+Park+Mosque',
        website: 'https://finsburyparkmosque.org',
      ),
    ];

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      final filtered = defaultMosques.where((m) {
        return m.name.toLowerCase().contains(q) ||
            m.address.toLowerCase().contains(q);
      }).toList();
      mosques.value = filtered.isNotEmpty ? filtered : defaultMosques;
    } else {
      mosques.value = defaultMosques;
    }
  }

  Future<void> fetchMosques() => fetchNearbyMosques();
}
