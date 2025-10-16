import 'package:firebase_database/firebase_database.dart';

class FirebaseDbService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<List<Map<String, dynamic>>> getProperties() async {
    final snapshot = await _db.child('properties').get();
    if (!snapshot.exists) return [];

    final value = snapshot.value;

    if (value is List) {
      // If it's a list, filter out nulls and convert each item to a Map
      return value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } else if (value is Map) {
      // If it's a map, convert entries to a list
      final data = Map<String, dynamic>.from(value);
      return data.entries
          .map((e) => {'Id': e.key, ...Map<String, dynamic>.from(e.value)})
          .toList();
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUnits() async {
    final snapshot = await _db.child('units').get();
    if (!snapshot.exists) return [];

    final value = snapshot.value;

    if (value is List) {
      return value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } else if (value is Map) {
      final data = Map<String, dynamic>.from(value);
      return data.entries
          .map((e) => {'Id': e.key, ...Map<String, dynamic>.from(e.value)})
          .toList();
    } else {
      return [];
    }
  }
}
