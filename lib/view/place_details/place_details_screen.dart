import 'package:flutter/material.dart';
import 'package:prime_travel_flutter_ui_kit/services/firebase_db_service.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  final FirebaseDbService _dbService = FirebaseDbService();
  List<Map<String, dynamic>> properties = [];
  List<Map<String, dynamic>> units = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    properties = await _dbService.getProperties();
    units = await _dbService.getUnits();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Properties")),
      body: ListView.builder(
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];
          final relatedUnits = units
              .where((u) =>
                  u['PropertyId'].toString() == property['id'].toString())
              .toList();

          return Card(
            margin: const EdgeInsets.all(8),
            child: ExpansionTile(
              title: Text(property['Name'] ?? 'No Name'),
              subtitle: Text(property['Address'] ?? ''),
              children: relatedUnits.map((u) {
                return ListTile(
                  title: Text(u['UnitName'] ?? u['Name'] ?? 'Unit'),
                  subtitle: Text('Price: ${u['Price'] ?? 'N/A'}'),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
