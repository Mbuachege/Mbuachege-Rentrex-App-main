// lib/View/booked_properties/view_booked_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/controller/home_controller%20copy.dart';
import 'package:prime_travel_flutter_ui_kit/util/font_family.dart';
import '../../model/home_place_model.dart';
import '../../util/colors.dart';
import '../place_details/property_details_screen.dart';

class ViewPendingPage extends StatelessWidget {
  final HomeControllerCopy controller = Get.find<HomeControllerCopy>();

  ViewPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Houses"),
        backgroundColor: ColorFile.whiteColor,
        elevation: 1,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.loadError.value != null) {
          return Center(child: Text(controller.loadError.value!));
        }

// 🔹 Filter only booked/unavailable/pending/reserved
        final bookedProperties = controller.allProperties.where((prop) {
          final s = prop.status?.toLowerCase() ?? '';
          return s.contains("unavailable") ||
              s.contains("pending") ||
              s.contains("reserved");
        }).toList();

        if (bookedProperties.isEmpty) {
          return const Center(child: Text("No booked houses at the moment."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: bookedProperties.length,
          itemBuilder: (context, index) {
            final HomePlaceModel prop = bookedProperties[index];
            final image = prop.imageUrls.isNotEmpty ? prop.imageUrls.first : "";
            final price = prop.priceFrom ?? 0.0;
            final rating = prop.averageRatingModel?.averageRating ?? 0.0;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorFile.borderColor),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: image.isEmpty
                        ? Container(
                            height: 160,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 50),
                          )
                        : Image.network(
                            image,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                          ),
                  ),

                  // 🔹 Details
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          prop.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: satoshiBold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        // Region
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                prop.region,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontFamily: satoshiRegular,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Rating
                        Row(
                          children: List.generate(5, (i) {
                            if (i < rating.round()) {
                              return const Icon(Icons.star,
                                  size: 16, color: Colors.amber);
                            } else {
                              return const Icon(Icons.star_border,
                                  size: 16,
                                  color: Color.fromARGB(255, 12, 12, 12));
                            }
                          }),
                        ),
                        const SizedBox(height: 12),

                        // Price + button row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PropertyDetailsScreen(property: prop),
                                  ),
                                );
                              },
                              child: const Text(
                                "View Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
