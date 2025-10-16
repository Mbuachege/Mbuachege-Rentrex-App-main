class HomePlaceModel {
  // Identity
  final int propertyId;
  final int unitId;
  final String title;

  // Display
  final String address;
  final List<String> imageUrls;
  final String region;

  // Aggregates
  final int unitsCount;
  final double? priceFrom;

  // Map + meta
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? status;
  final DateTime? propertyCreated;
  final String? owner;

  // 🔹 New fields
  final AverageRatingModel? averageRatingModel;
  final List<PropertyRating> propertyRatings;

  const HomePlaceModel({
    required this.propertyId,
    required this.unitId,
    required this.title,
    required this.address,
    required this.imageUrls,
    required this.region,
    required this.unitsCount,
    required this.priceFrom,
    this.description,
    this.latitude,
    this.longitude,
    this.status,
    this.propertyCreated,
    this.owner,
    this.averageRatingModel,
    this.propertyRatings = const [],
  });

  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';
  bool get hasCoordinates => latitude != null && longitude != null;

  HomePlaceModel copyWith({
    String? title,
    String? address,
    List<String>? imageUrls,
    String? region,
    int? unitsCount,
    double? priceFrom,
    double? latitude,
    double? longitude,
    String? status,
    DateTime? propertyCreated,
    String? owner,
    AverageRatingModel? averageRatingModel,
    List<PropertyRating>? propertyRatings,
  }) {
    return HomePlaceModel(
      propertyId: propertyId,
      unitId: unitId,
      title: title ?? this.title,
      address: address ?? this.address,
      imageUrls: imageUrls ?? this.imageUrls,
      region: region ?? this.region,
      unitsCount: unitsCount ?? this.unitsCount,
      priceFrom: priceFrom ?? this.priceFrom,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      propertyCreated: propertyCreated ?? this.propertyCreated,
      owner: owner ?? this.owner,
      averageRatingModel: averageRatingModel ?? this.averageRatingModel,
      propertyRatings: propertyRatings ?? this.propertyRatings,
    );
  }

  // 🔹 JSON factory
  factory HomePlaceModel.fromJson(Map<String, dynamic> json) {
    return HomePlaceModel(
      propertyId: json['propertyId'],
      unitId: json['unitId'],
      title: json['name'] ?? '',
      address: json['address'] ?? '',
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      region: json['region'] ?? '',
      unitsCount: json['unitsCount'] ?? 0,
      priceFrom: (json['price'] as num?)?.toDouble(),
      description: json['description'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['propertyStatus'],
      propertyCreated: json['propertyCreated'] != null
          ? DateTime.tryParse(json['propertyCreated'])
          : null,
      owner: json['owner'],
      averageRatingModel: json['averageRatingModel'] != null
          ? AverageRatingModel.fromJson(json['averageRatingModel'])
          : null,
      propertyRatings: (json['propertyRatings'] as List<dynamic>?)
              ?.map((e) => PropertyRating.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// 🔹 Average rating summary
class AverageRatingModel {
  final int propertyId;
  final double averageRating;
  final int totalReviews;

  const AverageRatingModel({
    required this.propertyId,
    required this.averageRating,
    required this.totalReviews,
  });

  factory AverageRatingModel.fromJson(Map<String, dynamic> json) {
    return AverageRatingModel(
      propertyId: json['propertyId'],
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'],
    );
  }
}

// 🔹 Individual ratings
class PropertyRating {
  final int id;
  final int bookingId;
  final int guestId;
  final int unitId;
  final int stars;
  final String comment;
  final String firstName;
  final DateTime? created;
  final int propertyId;

  const PropertyRating({
    required this.id,
    required this.bookingId,
    required this.guestId,
    required this.unitId,
    required this.stars,
    required this.comment,
    required this.firstName,
    required this.created,
    required this.propertyId,
  });

  factory PropertyRating.fromJson(Map<String, dynamic> json) {
    return PropertyRating(
      id: json['id'],
      bookingId: json['bookingId'],
      guestId: json['guestId'],
      unitId: json['unitId'],
      stars: json['stars'],
      comment: json['comment'] ?? '',
      firstName: json['firstName'] ?? '',
      created:
          json['created'] != null ? DateTime.tryParse(json['created']) : null,
      propertyId: json['propertyId'],
    );
  }
}
