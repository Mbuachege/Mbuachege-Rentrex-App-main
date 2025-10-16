// lib/controller/international_controller_copy.dart
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// ⬇️ make sure this path matches your model file (use your new map-ready model)
import '../model/popular_place.dart';

class InternationalControllerCopy extends GetxController {
  // UI state expected by PopularPlacesScreen / Home Map tab
  final isLoadingProperties = true.obs;
  final propertiesError = RxnString();
  final properties = <PropertyCardModel>[].obs;

  // Adjust these if your host changes
  static const String _apiBase = 'http://appvacation.digikatech.africa';
  static const String _localBase = 'http://appvacation.digikatech.africa';

  final _client = http.Client();

  @override
  void onInit() {
    super.onInit();
    fetchProperties();
  }

  @override
  void onClose() {
    _client.close();
    super.onClose();
  }

  Future<void> fetchProperties() async {
    isLoadingProperties.value = true;
    propertiesError.value = null;

    try {
      final uri = Uri.parse('$_apiBase/api/properties/property_units');
      final res = await _client.get(uri, headers: {
        'Accept': 'application/json'
      }).timeout(const Duration(seconds: 20));

      if (res.statusCode != 200) {
        propertiesError.value =
            'HTTP ${res.statusCode}: ${res.reasonPhrase ?? 'Error'}';
        properties.clear();
        return;
      }

      final dynamic decoded = jsonDecode(res.body);
      if (decoded is! List) {
        propertiesError.value = 'Unexpected response shape.';
        properties.clear();
        return;
      }

      // Group by propertyId and aggregate rows
      final Map<int, _PropertyAccumulator> byProperty = {};

      for (final row in decoded) {
        if (row is! Map<String, dynamic>) continue;

        final int? propertyId = _asInt(row['propertyId']);
        if (propertyId == null) continue;

        final acc = byProperty.putIfAbsent(
          propertyId,
          () => _PropertyAccumulator(
            propertyId: propertyId,
            name: (row['name'] as String?)?.trim() ?? 'Unknown',
            owner: (row['owner'] as String?)?.trim() ?? '',
          ),
        );

        // Merge property-level fields (first non-null wins)
        acc.description ??= (row['description'] as String?)?.trim();
        acc.address ??= (row['address'] as String?)?.trim();

        // Coordinates
        acc.lat ??= _toDouble(row['latitude']);
        acc.lng ??= _toDouble(row['longitude']);

        // Status / dates
        acc.status ??= _parseStatus(row['propertyStatus']?.toString());
        acc.propertyCreated ??= _toDate(row['propertyCreated']);

        // Images: prefer imageUrls array; fallback to comma-separated filenames
        final List<String> urls = _extractImageUrls(row).map(_fixHost).toList();
        acc.imageUrls.addAll(urls);

        // Unit snapshot: keep the **cheapest** unit (or first if no price)
        final unit = _UnitSnapshot(
          unitId: _asInt(row['unitId']),
          unitName: row['unitName']?.toString(),
          unitType: row['unitType']?.toString(),
          maxGuests: _asInt(row['maxGuests']),
          price: _toDouble(row['price']),
          unitStatus: _parseStatus(row['unitStatus']?.toString()),
          unitCreated: _toDate(row['unitCreated']),
        );
        acc.takeCheapestUnit(unit);
      }

      // Build final list (preserve insertion order & de-duplicate images)
      final result = <PropertyCardModel>[];
      for (final acc in byProperty.values) {
        final uniqueImages = LinkedHashSet<String>.from(acc.imageUrls).toList();

        result.add(
          PropertyCardModel(
            propertyId: acc.propertyId,
            name: acc.name,
            owner: acc.owner,
            description: acc.description,
            address: acc.address,
            latitude: acc.lat,
            longitude: acc.lng,
            status: acc.status ?? PropertyStatus.unknown,
            propertyCreated: acc.propertyCreated,
            unitId: acc.bestUnit?.unitId,
            unitName: acc.bestUnit?.unitName,
            unitType: acc.bestUnit?.unitType,
            maxGuests: acc.bestUnit?.maxGuests,
            price: acc.bestUnit?.price,
            unitStatus: acc.bestUnit!.unitStatus?.toString(),
            unitCreated: acc.bestUnit?.unitCreated,
            imageUrls: uniqueImages,
          ),
        );
      }

      // Optional: sort by newest
      // result.sort((a, b) => (b.propertyCreated ?? DateTime(0))
      //     .compareTo(a.propertyCreated ?? DateTime(0)));

      properties.assignAll(result);
    } on TimeoutException {
      propertiesError.value = 'Request timed out. Please try again.';
      properties.clear();
    } catch (e) {
      propertiesError.value = 'Failed to load: $e';
      properties.clear();
    } finally {
      isLoadingProperties.value = false;
    }
  }

  // ---------- helpers ----------

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  static DateTime? _toDate(dynamic v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }

  static PropertyStatus _parseStatus(String? s) {
    switch (s?.trim().toLowerCase()) {
      case 'listed':
        return PropertyStatus.listed;
      case 'closed':
        return PropertyStatus.closed;
      default:
        return PropertyStatus.unknown;
    }
  }

  static List<String> _extractImageUrls(Map<String, dynamic> row) {
    final dynamic list = row['imageUrls'];
    if (list is List) {
      return list
          .whereType<String>()
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    // Fallback: comma-separated "images" -> build public URLs
    final images = (row['images'] as String?) ?? '';
    final parts = images
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty) return const [];
    return parts.map((file) => '$_apiBase/public/properties/$file').toList();
  }

  static String _fixHost(String url) {
    // Rewrite localhost -> ngrok for devices/emulators
    return url.startsWith(_localBase)
        ? url.replaceFirst(_localBase, _apiBase)
        : url;
  }
}

class _PropertyAccumulator {
  final int propertyId;
  final String name;
  final String owner;

  String? description;
  String? address;
  double? lat;
  double? lng;
  PropertyStatus? status;
  DateTime? propertyCreated;

  final List<String> imageUrls = [];

  _UnitSnapshot? bestUnit;

  _PropertyAccumulator({
    required this.propertyId,
    required this.name,
    required this.owner,
  });

  void takeCheapestUnit(_UnitSnapshot candidate) {
    if (bestUnit == null) {
      bestUnit = candidate;
      return;
    }
    final current = bestUnit!;
    // Prefer lower price if both present; otherwise keep the one that has price
    final cHas = current.price != null;
    final nHas = candidate.price != null;
    if (!cHas && nHas) {
      bestUnit = candidate;
    } else if (cHas && nHas && (candidate.price! < current.price!)) {
      bestUnit = candidate;
    }
  }
}

class _UnitSnapshot {
  final int? unitId;
  final String? unitName;
  final String? unitType;
  final int? maxGuests;
  final double? price;
  PropertyStatus? unitStatus;
  final DateTime? unitCreated;

  _UnitSnapshot({
    this.unitId,
    this.unitName,
    this.unitType,
    this.maxGuests,
    this.price,
    this.unitStatus,
    this.unitCreated,
  });
}
