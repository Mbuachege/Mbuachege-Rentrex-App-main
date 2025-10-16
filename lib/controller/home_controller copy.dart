// lib/controller/home_controller.dart
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';
import '../model/home_place_model.dart';

class HomeControllerCopy extends GetxController {
  final appbarTitle = ''.obs;

  // Observable lists
  final homeSecondList = <HomePlaceModel>[].obs;
  final internationalTripList = <HomePlaceModel>[].obs;
  final popularPlacesList = <HomePlaceModel>[].obs;

  // Toggle states
  final selectPopularItems = <bool>[].obs;
  final selectedItems = <bool>[].obs;
  final selectTripItems = <bool>[].obs;

  // Loading states
  final isLoading = false.obs;
  final loadError = RxnString();

  late HubConnection _hubConnection;
  final isConnectedToHub = false.obs;
  // API Base (replace localhost with your server URL)
  static const String _baseUrl = 'http://appvacation.digikatech.africa';
  final _client = http.Client();

  @override
  void onClose() {
    _client.close();
    super.onClose();
  }

  /// 🔹 Combine all lists for map + listings (deduplicated)
  List<HomePlaceModel> get allProperties {
    final all = [
      ...homeSecondList,
      ...internationalTripList,
      ...popularPlacesList
    ];

    // Deduplicate by propertyId
    final unique = <int, HomePlaceModel>{};
    for (final p in all) {
      unique[p.propertyId] = p;
    }

    return unique.values.toList();
  }

  Future<void> initializeSignalR() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          'http://appvacation.digikatech.africa/bookingHub',
          options: HttpConnectionOptions(
            transport: HttpTransportType.WebSockets,
            skipNegotiation: true,
          ),
        )
        .build();

    _hubConnection.onclose(({Exception? error}) {
      isConnectedToHub.value = false;
      print('SignalR disconnected: $error');
    });

    _hubConnection.on('PropertyBooked', (arguments) async {
      final propertyId = arguments?[0];
      print('Property booked: $propertyId');
      await fetchHomeData(lat: 0.0, longi: 0.0);
    });

    try {
      await _hubConnection.start();
      isConnectedToHub.value = true;
      print('✅ Connected to SignalR hub');
    } catch (e) {
      print('❌ Failed to connect to hub: $e');
    }
  }

  /// 🔹 Fetch home data using the new endpoint
  ///
  Future<void> fetchHomeData({
    required double lat,
    required double longi,
  }) async {
    isLoading.value = true;
    loadError.value = null;

    try {
      final uri =
          Uri.parse('$_baseUrl/api/properties/all?lat=$lat&longi=$longi');

      final res = await _client.get(uri, headers: {
        'Accept': 'application/json'
      }).timeout(const Duration(seconds: 20));
      print("API Response: ${res.body}");

      if (res.statusCode != 200) {
        loadError.value =
            'HTTP ${res.statusCode}: ${res.reasonPhrase ?? 'Error'}';
        _clearLists();
        return;
      }

      final decoded = jsonDecode(res.body);
      if (decoded is! List) {
        loadError.value = 'Unexpected response format.';
        _clearLists();
        return;
      }

      // Convert to models (keep API order)
      final props = decoded
          .whereType<Map<String, dynamic>>()
          .map((r) => _mapToModel(r))
          .where((p) => p != null)
          .cast<HomePlaceModel>()
          .toList();

      // ✅ No sorting
      // ✅ No duplication, just split in order
      final featured = props.take(5).toList();
      final international = props
          .where((p) => p.region.toLowerCase() != 'kenya')
          .take(5)
          .toList();
      final popular = props.length > 5 ? props.skip(5).take(5).toList() : [];

      // Assign lists
      homeSecondList.assignAll(featured);
      internationalTripList.assignAll(international);
      popularPlacesList.assignAll(popular as Iterable<HomePlaceModel>);

      // Toggle states
      selectedItems.assignAll(List.filled(homeSecondList.length, false));
      selectTripItems
          .assignAll(List.filled(internationalTripList.length, false));
      selectPopularItems
          .assignAll(List.filled(popularPlacesList.length, false));
    } on TimeoutException {
      loadError.value = 'Request timed out. Please try again.';
      _clearLists();
    } catch (e) {
      loadError.value = 'Failed to load: $e';
      _clearLists();
    } finally {
      isLoading.value = false;
    }
  }

  void _clearLists() {
    homeSecondList.clear();
    internationalTripList.clear();
    popularPlacesList.clear();
    selectedItems.clear();
    selectTripItems.clear();
    selectPopularItems.clear();
  }

  HomePlaceModel? _mapToModel(Map<String, dynamic> r) {
    final pid = r['propertyId'] is int
        ? r['propertyId'] as int
        : int.tryParse(r['propertyId']?.toString() ?? '');
    if (pid == null) return null;

    final images = _extractImageUrls(r);

    // Parse averageRatingModel safely
    AverageRatingModel? avgRating;
    if (r['averageRatingModel'] != null) {
      final m = Map<String, dynamic>.from(r['averageRatingModel']);
      avgRating = AverageRatingModel(
        propertyId: m['propertyId'] is int
            ? m['propertyId']
            : int.tryParse(m['propertyId']?.toString() ?? '') ?? 0,
        averageRating: m['averageRating'] is num
            ? (m['averageRating'] as num).toDouble()
            : double.tryParse(m['averageRating']?.toString() ?? '') ?? 0,
        totalReviews: m['totalReviews'] is int
            ? m['totalReviews']
            : int.tryParse(m['totalReviews']?.toString() ?? '') ?? 0,
      );
    }

    // Parse propertyRatings safely
    final List<PropertyRating> ratings = [];
    if (r['propertyRatings'] is List) {
      for (final item in r['propertyRatings']) {
        if (item is Map) {
          final m = Map<String, dynamic>.from(item);
          ratings.add(PropertyRating(
            id: m['id'] is int
                ? m['id']
                : int.tryParse(m['id']?.toString() ?? '') ?? 0,
            bookingId: m['bookingId'] is int
                ? m['bookingId']
                : int.tryParse(m['bookingId']?.toString() ?? '') ?? 0,
            guestId: m['guestId'] is int
                ? m['guestId']
                : int.tryParse(m['guestId']?.toString() ?? '') ?? 0,
            unitId: m['unitId'] is int
                ? m['unitId']
                : int.tryParse(m['unitId']?.toString() ?? '') ?? 0,
            stars: m['stars'] is int
                ? m['stars']
                : int.tryParse(m['stars']?.toString() ?? '') ?? 0,
            comment: m['comment']?.toString() ?? '',
            firstName: m['firstName']?.toString() ?? '',
            created: DateTime.tryParse(m['created']?.toString() ?? ''),
            propertyId: m['propertyId'] is int
                ? m['propertyId']
                : int.tryParse(m['propertyId']?.toString() ?? '') ?? 0,
          ));
        }
      }
    }

    return HomePlaceModel(
      propertyId: pid,
      unitId: r['unitId'] is int
          ? r['unitId']
          : int.tryParse(r['unitId']?.toString() ?? '') ?? 0,
      title: r['name']?.toString() ?? 'Unknown',
      address: r['address']?.toString() ?? '',
      imageUrls: images,
      region: _regionFromAddress(r['address'] ?? ''),
      unitsCount: 1,
      priceFrom: double.tryParse(r['price']?.toString() ?? ''),
      description: r['description']?.toString(),
      latitude: double.tryParse(r['latitude']?.toString() ?? ''),
      longitude: double.tryParse(r['longitude']?.toString() ?? ''),
      status: r['propertyStatus']?.toString(),
      propertyCreated:
          DateTime.tryParse(r['propertyCreated']?.toString() ?? ''),
      owner: r['owner']?.toString(),
      averageRatingModel: avgRating,
      propertyRatings: ratings,
    );
  }

  // 🔹 Extract and fix image URLs
  static List<String> _extractImageUrls(Map<String, dynamic> r) {
    final List<String> urls = [];

    // Case 1: array of full URLs
    if (r['imageUrls'] is List) {
      for (final u in r['imageUrls']) {
        if (u is String && u.trim().isNotEmpty) {
          final fixed =
              u.replaceFirst('http://appvacation.digikatech.africa', _baseUrl);
          urls.add(fixed);
        }
      }
    }

    // Case 2: comma-separated filenames
    if (r['images'] is String) {
      final parts = (r['images'] as String)
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty);

      for (final f in parts) {
        final full = '$_baseUrl/public/properties/$f';
        urls.add(full);
      }
    }

    return urls;
  }

  static String _regionFromAddress(String address) {
    final parts = address
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return parts.isEmpty ? '' : parts.last;
  }
}
