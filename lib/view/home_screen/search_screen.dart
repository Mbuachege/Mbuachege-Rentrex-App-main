import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/model/home_place_model.dart';
import 'package:prime_travel_flutter_ui_kit/view/place_details/property_details_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<HomePlaceModel> properties; // ✅ Add this line

  const SearchScreen({Key? key, required this.properties})
      : super(key: key); // ✅ Add this constructor

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final filtered = widget.properties.where((p) {
      return p.title.toLowerCase().contains(query.toLowerCase()) ||
          p.address.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Search Houses")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by title or address...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => query = val),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("No results found"))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return ListTile(
                        leading: Image.network(
                          item.imageUrls.first,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item.title),
                        subtitle: Text(item.address),
                        onTap: () => Get.to(
                          () => PropertyDetailsScreen(property: item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
