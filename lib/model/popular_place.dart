// property_card_model.dart
enum PropertyStatus { listed, closed, unknown }

PropertyStatus _parseStatus(String? s) {
  if (s == null) return PropertyStatus.unknown;
  switch (s.trim().toLowerCase()) {
    case 'listed':
      return PropertyStatus.listed;
    case 'closed':
      return PropertyStatus.closed;
    default:
      return PropertyStatus.unknown;
  }
}

class PropertyCardModel {
  // Core
  final int propertyId;
  final String name;
  final String owner;

  // Useful for list + details + map InfoWindow
  final String? description;
  final String? address;

  // Map
  final double? latitude;
  final double? longitude;

  // Status/timestamps
  final PropertyStatus status;
  final DateTime? propertyCreated;

  // Unit snapshot (your API returns a row per unit)
  final int? unitId;
  final String? unitName;
  final String? unitType;
  final int? maxGuests;
  final double? price;
  final String? unitStatus;
  final DateTime? unitCreated;

  // Images (prefer imageUrls; fallback to split "images")
  final List<String> imageUrls;

  const PropertyCardModel({
    required this.propertyId,
    required this.name,
    required this.owner,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.status = PropertyStatus.unknown,
    this.propertyCreated,
    this.unitId,
    this.unitName,
    this.unitType,
    this.maxGuests,
    this.price,
    this.unitStatus,
    this.unitCreated,
    required this.imageUrls,
  });

  factory PropertyCardModel.fromJson(Map<String, dynamic> j) {
    double? toDouble(dynamic v) =>
        v == null ? null : (v is num ? v.toDouble() : double.tryParse('$v'));
    int? toInt(dynamic v) =>
        v == null ? null : (v is int ? v : int.tryParse('$v'));
    DateTime? toDate(dynamic v) =>
        v == null ? null : DateTime.tryParse(v.toString());

    List<String> images() {
      final list = (j['imageUrls'] as List?)
              ?.map((e) => e.toString())
              .where((e) => e.trim().isNotEmpty)
              .toList() ??
          const [];
      if (list.isNotEmpty) return list;
      final imgs = j['images']?.toString();
      if (imgs == null || imgs.trim().isEmpty) return const [];
      return imgs
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    return PropertyCardModel(
      propertyId: toInt(j['propertyId']) ?? 0,
      name: j['name']?.toString() ?? '',
      owner: j['owner']?.toString() ?? '',
      description: j['description']?.toString(),
      address: j['address']?.toString(),
      latitude: toDouble(j['latitude']),
      longitude: toDouble(j['longitude']),
      status: _parseStatus(j['propertyStatus']?.toString()),
      propertyCreated: toDate(j['propertyCreated']),
      unitId: toInt(j['unitId']),
      unitName: j['unitName']?.toString(),
      unitType: j['unitType']?.toString(),
      maxGuests: toInt(j['maxGuests']),
      price: toDouble(j['price']),
      unitStatus: j['unitStatus']?.toString(),
      unitCreated: toDate(j['unitCreated']),
      imageUrls: images(),
    );
  }

  bool get hasCoordinates => latitude != null && longitude != null;

  PropertyCardModel copyWith({
    String? name,
    String? owner,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    PropertyStatus? status,
    DateTime? propertyCreated,
    int? unitId,
    String? unitName,
    String? unitType,
    int? maxGuests,
    double? price,
    String? unitStatus,
    DateTime? unitCreated,
    List<String>? imageUrls,
  }) {
    return PropertyCardModel(
      propertyId: propertyId,
      name: name ?? this.name,
      owner: owner ?? this.owner,
      description: description ?? this.description,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      propertyCreated: propertyCreated ?? this.propertyCreated,
      unitId: unitId ?? this.unitId,
      unitName: unitName ?? this.unitName,
      unitType: unitType ?? this.unitType,
      maxGuests: maxGuests ?? this.maxGuests,
      price: price ?? this.price,
      unitStatus: unitStatus ?? this.unitStatus,
      unitCreated: unitCreated ?? this.unitCreated,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}
