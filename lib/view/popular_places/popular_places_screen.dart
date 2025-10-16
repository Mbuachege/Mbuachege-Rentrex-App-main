import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/international_controller copy.dart'; // Your new API-based controller
import '../../util/asset_image_paths.dart';
import '../../util/colors.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';

class PopularPlacesScreen extends StatelessWidget {
  PopularPlacesScreen({Key? key}) : super(key: key);

  // Use only the new controller
  final popularControllerss = Get.put(InternationalControllerCopy());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: ColorFile.whiteColor,
        elevation: 0,
        title: const Text(
          StringConfig.popularPlaces,
          style: TextStyle(
            decorationColor: ColorFile.onBordingColor,
            color: ColorFile.onBordingColor,
            fontFamily: satoshiBold,
            fontWeight: FontWeight.w400,
            fontSize: SizeFile.height22,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.only(
              left: SizeFile.height10,
              top: SizeFile.height20,
              bottom: SizeFile.height20,
            ),
            child: Image.asset(
              AssetImagePaths.backArrow2,
              height: SizeFile.height18,
              width: SizeFile.height18,
              color: ColorFile.onBordingColor,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (popularControllerss.isLoadingProperties.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (popularControllerss.propertiesError.value != null) {
          return Center(
            child: Text(
              'Error: ${popularControllerss.propertiesError.value}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (popularControllerss.properties.isEmpty) {
          return const Center(child: Text('No popular places found.'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: SizeFile.height8),
              GridView.builder(
                itemCount: popularControllerss.properties.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: SizeFile.height20),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: SizeFile.height12,
                  mainAxisSpacing: SizeFile.height12,
                ),
                itemBuilder: (BuildContext ctx, index) {
                  final item = popularControllerss.properties[index];
                  final img =
                      item.imageUrls.isNotEmpty ? item.imageUrls.first : '';
                  return GestureDetector(
                    onTap: () {
                      // Get.to(const PopularPlacePackageScreen());
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        // Use Image.network for API images
                        Image.network(
                          img,
                          height: SizeFile.height / 1.6,
                          width: SizeFile.width / 1.6,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 50),
                        ),
                        // Heart icon placeholder - optional, needs its own RxList if you want to keep this feature
                        Padding(
                          padding: const EdgeInsets.only(
                              right: SizeFile.height12, top: SizeFile.height8),
                          child:
                              Icon(Icons.favorite_border, color: Colors.white),
                        ),
                        Positioned(
                          bottom: MediaQuery.of(context).size.height / 70,
                          left: SizeFile.height20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  color: ColorFile.whiteColor,
                                  fontFamily: satoshiBold,
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeFile.height14,
                                ),
                              ),
                              const SizedBox(height: SizeFile.height6),
                              Row(
                                children: List.generate(
                                  5,
                                  (_) => Padding(
                                    padding: const EdgeInsets.only(right: 2),
                                    child: Image.asset(
                                      AssetImagePaths.starYellow,
                                      height: SizeFile.height9,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: SizeFile.height12),
            ],
          ),
        );
      }),
    );
  }
}
