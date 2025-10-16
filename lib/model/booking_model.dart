class Booking {
  final int id;
  final int unitId;
  final int guestId;
  final String unitName;
  final String propertyName;
  final String guestName;
  final String guestEmail;
  final String lockId;
  final String address;
  final double latitude;
  final double longitude;
  final DateTime checkIn;
  final DateTime checkOut;
  final double totalPrice;
  final String status;
  final String payment;
  final String review;
  final DateTime created;

  Booking({
    required this.id,
    required this.unitId,
    required this.guestId,
    required this.unitName,
    required this.propertyName,
    required this.guestName,
    required this.guestEmail,
    required this.lockId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
    required this.payment,
    required this.review,
    required this.created,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      unitId: json['unitId'],
      guestId: json['guestId'],
      unitName: json['unitName'],
      propertyName: json['propertyName'],
      guestName: json['guestName'],
      guestEmail: json['guestEmail'],
      lockId: json['lockId'],
      address: json['address'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'],
      payment: json['payment'],
      review: json['review'],
      created: DateTime.parse(json['created']),
    );
  }
}
