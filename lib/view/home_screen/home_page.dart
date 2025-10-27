// lib/View/home_screen/home_page.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:prime_travel_flutter_ui_kit/View/home_screen/search_screen.dart';
import 'package:prime_travel_flutter_ui_kit/controller/home_controller%20copy.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/view/my_booking_screen/view_available_screen.dart';
import 'package:prime_travel_flutter_ui_kit/view/my_booking_screen/view_booked_screen.dart';
import 'package:prime_travel_flutter_ui_kit/view/my_booking_screen/view_pending_screen.dart';
import '../../model/home_place_model.dart';
import '../../util/asset_image_paths.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';
import '../place_details/property_details_screen.dart';

const bool kDebugLog = true;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = Get.put(HomeControllerCopy());

  GoogleMapController? _mapController;
  bool _mapReady = false;
  LatLng? _userLatLng;
  late final String status;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initLocationIfNeeded();
    });
    homeController.initializeSignalR();
  }

  Future<void> _initLocationIfNeeded() async {
    try {
      final status = await Permission.location.status;
      if (status.isGranted) {
        await _fetchAndLogCurrentPosition();
        return;
      }
      final req = await Permission.location.request();
      if (req.isGranted) {
        await _fetchAndLogCurrentPosition();
      }
    } catch (e) {
      if (kDebugLog) debugPrint('Location init error: $e');
    }
  }

  Future<void> _fetchAndLogCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;
    LocationPermission geoPerm = await Geolocator.checkPermission();
    if (geoPerm == LocationPermission.denied) {
      geoPerm = await Geolocator.requestPermission();
      if (geoPerm == LocationPermission.denied) return;
    }
    if (geoPerm == LocationPermission.deniedForever) return;

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: _currentLocationSettings(),
      ).timeout(const Duration(seconds: 10));

      _userLatLng = LatLng(pos.latitude, pos.longitude);
      homeController.fetchHomeData(lat: pos.latitude, longi: pos.longitude);
    } catch (e) {
      if (kDebugLog) debugPrint('Error getting current location: $e');
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchAndLogCurrentPosition();
    await Future.delayed(const Duration(seconds: 3)); // so spinner is visible
    homeController.initializeSignalR();
  }

  LocationSettings _currentLocationSettings() {
    if (kIsWeb) return WebSettings(accuracy: LocationAccuracy.high);
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidSettings(accuracy: LocationAccuracy.high);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return AppleSettings(accuracy: LocationAccuracy.best);
      default:
        return const LocationSettings(accuracy: LocationAccuracy.high);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'booked':
        return const Color.fromARGB(255, 180, 63, 55);
      case 'pending':
        return Colors.orange;
      case 'available':
        return Colors.green;
      default:
        return Colors.green;
    }
  }

  CameraPosition _initialCameraPosition() {
    if (_userLatLng != null) {
      return CameraPosition(
        target: _userLatLng!,
        zoom: 14,
      );
    }
    // fallback: Nairobi if user location is not ready
    return const CameraPosition(
      target: LatLng(1.286389, 36.817223),
      zoom: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorFile.whiteColor,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: SizeFile.height10),

              // ===== Search Row =====
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: SizeFile.height20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() => SearchScreen(
                          properties: homeController.allProperties)),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.33,
                        height: SizeFile.height38,
                        padding: const EdgeInsets.symmetric(
                            horizontal: SizeFile.height10),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(SizeFile.height10),
                          border: Border.all(
                              width: SizeFile.height1,
                              color: ColorFile.borderColor),
                          color: ColorFile.whiteColor,
                        ),
                        child: Row(
                          children: [
                            Image.asset(AssetImagePaths.searchIcon,
                                height: SizeFile.height14,
                                width: SizeFile.height14,
                                color: ColorFile.onBording2Color),
                            const SizedBox(width: SizeFile.height10),
                            const Text(
                              StringConfig.searchPlaces,
                              style: TextStyle(
                                color: ColorFile.onBording2Color,
                                fontFamily: satoshiRegular,
                                fontSize: SizeFile.height13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: SizeFile.height42,
                      height: SizeFile.height38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SizeFile.height10),
                        border:
                            Border.all(width: 1, color: ColorFile.borderColor),
                        color: ColorFile.whiteColor,
                      ),
                      child: Image.asset(AssetImagePaths.voiceIcon,
                          color: ColorFile.blackColor,
                          height: SizeFile.height18,
                          width: SizeFile.height18),
                    ),
                  ],
                ),
              ),

              // ===== Loading / Error =====
              Obx(() {
                if (homeController.isLoading.value) {
                  return const LinearProgressIndicator(minHeight: 2);
                }
                if (homeController.loadError.value != null) {
                  return Text(homeController.loadError.value!,
                      style: const TextStyle(color: Colors.red));
                }
                return const SizedBox.shrink();
              }),

              const TabBar(
                indicatorColor: ColorFile.appColor,
                labelColor: ColorFile.appColor,
                unselectedLabelColor: ColorFile.onBordingColor,
                tabs: [
                  Text("Map View", style: TextStyle(fontFamily: satoshiMedium)),
                  Text("List View",
                      style: TextStyle(fontFamily: satoshiMedium)),
                ],
              ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: Obx(() => TabBarView(
                        children: [
                          _buildMapTab(),
                          _buildListTab(),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== MAP TAB =====================
  Widget _buildMapTab() {
    return Obx(() {
      final items = homeController.allProperties;
      final markers = _markersFromItems(items);

      return Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              _mapReady = true;

              if (markers.isNotEmpty) {
                _scheduleFit(markers);
              } else if (_userLatLng != null) {
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: _userLatLng!, zoom: 14),
                  ),
                );
              }
            },
            initialCameraPosition: _initialCameraPosition(),
            markers: markers,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            mapType: MapType.normal,
            gestureRecognizers: {
              Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer()),
            },
          ),

          // 🔹 Loading overlay while fetching data
          if (homeController.isLoading.value)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.6),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

          // 🔹 Carousel stays even if data is still loading
          if (items.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              height: 140,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.85),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildCarouselCard(item);
                },
              ),
            ),
        ],
      );
    });
  }

  Widget _buildCarouselCard(HomePlaceModel item) {
    return GestureDetector(
      onTap: () {
        // Center map on property
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(item.latitude ?? 0.0, item.longitude ?? 0.0),
          ),
        );

        // Navigate to Property Details page
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.to(() => PropertyDetailsScreen(
                property: item,
              ));
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.network(
                item.imageUrl,
                width: 120,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // 🔹 Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            (item.status?.toLowerCase().contains("available") ??
                                    false)
                                ? Colors.green.withOpacity(0.15)
                                : Colors.red.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.status ?? "Unknown",
                        style: TextStyle(
                          color: (item.status
                                      ?.toLowerCase()
                                      .contains("available") ??
                                  false)
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // 🔹 Rating Row
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          item.averageRatingModel?.averageRating
                                  .toStringAsFixed(1) ??
                              "0.0",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "(${item.averageRatingModel?.totalReviews ?? 0} reviews)",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // 🔹 Address
                    Text(
                      item.address,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scheduleFit(Set<Marker> markers) {
    if (!_mapReady || _mapController == null || markers.isEmpty) return;
    scheduleMicrotask(() => _fitToAllMarkersSafely(markers));
  }

  Future<void> _fitToAllMarkersSafely(Set<Marker> markers) async {
    if (_mapController == null || markers.isEmpty) return;
    try {
      final lats = markers.map((m) => m.position.latitude).toList();
      final lngs = markers.map((m) => m.position.longitude).toList();
      final bounds = LatLngBounds(
        southwest: LatLng(lats.reduce((a, b) => a < b ? a : b),
            lngs.reduce((a, b) => a < b ? a : b)),
        northeast: LatLng(lats.reduce((a, b) => a > b ? a : b),
            lngs.reduce((a, b) => a > b ? a : b)),
      );
      await _mapController!
          .animateCamera(CameraUpdate.newLatLngBounds(bounds, 64));
    } catch (_) {}
  }

// ===================== LIST TAB =====================
  Widget _buildListTab() {
    final all = homeController.allProperties;

    final nearThree = all.take(3).toList();
    final available = all
        .where((p) => (p.status ?? '').toLowerCase() == "available")
        .toList();
    final pending = all
        .where((p) => (p.status ?? '').toLowerCase().contains("pending"))
        .toList();
    final booked = all
        .where((p) => (p.status ?? '').toLowerCase().contains("booked"))
        .toList();

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // important!
        padding: const EdgeInsets.symmetric(horizontal: SizeFile.height16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==== NEAR YOU ====
            _SectionHeader(
              title: StringConfig.nearYou,
            ),
            const SizedBox(height: SizeFile.height12),
            _HorizontalPropertyCards(items: nearThree),
            const SizedBox(height: SizeFile.height24),

            // ==== AVAILABLE (Grid 2 columns) ====
            _SectionHeader(
              title: "Available Houses",
              onViewAll: () async {
                await Future.delayed(const Duration(milliseconds: 50));
                Get.to(() => ViewAvailablePage());
              },
            ),

            const SizedBox(height: SizeFile.height12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: available.length,
              itemBuilder: (context, i) {
                final item = available[i];
                return _PropertyCard(item: item);
              },
            ),
            const SizedBox(height: SizeFile.height24),

            // ==== PENDING ====
            _SectionHeader(
                title: "Pending",
                onViewAll: () => Get.to(() => ViewPendingPage())),
            const SizedBox(height: SizeFile.height12),
            _HorizontalPropertyCards(items: pending),
            const SizedBox(height: SizeFile.height24),

            // ==== BOOKED ====
            _SectionHeader(
                title: "Booked",
                onViewAll: () => Get.to(() => ViewBookedPage())),
            const SizedBox(height: SizeFile.height12),
            _HorizontalPropertyCards(items: booked),
            const SizedBox(height: SizeFile.height24),
          ],
        ),
      ),
    );
  }

  Set<Marker> _markersFromItems(List<HomePlaceModel> items) {
    return items
        .where((i) => i.latitude != null && i.longitude != null)
        .map((i) => Marker(
              markerId: MarkerId('prop_${i.propertyId}'),
              position: LatLng(i.latitude!, i.longitude!),
              infoWindow: InfoWindow(
                title: i.title,
                snippet: i.region,
                onTap: () => Get.to(() => PropertyDetailsScreen(property: i)),
              ),
            ))
        .toSet();
  }
}

// ===== Empty State =====
class _EmptyMapState extends StatelessWidget {
  const _EmptyMapState();
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('No properties found on the map.'));
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  final bool showViewAll;
  const _SectionHeader({
    required this.title,
    this.onViewAll,
    this.showViewAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontFamily: satoshiBold, fontSize: SizeFile.height16)),
        if (showViewAll && onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: const Text(
              "View more",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: ColorFile.appColor,
                  fontFamily: satoshiBold,
                  fontSize: SizeFile.height12),
            ),
          ),
      ],
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final HomePlaceModel item;
  const _PropertyCard({required this.item});

  Color _statusColor(String? status) {
    final s = (status ?? '').toLowerCase();
    if (s.contains('booked') || s.contains('unavailable')) {
      return Colors.redAccent;
    }
    if (s.contains('pending') || s.contains('reserved')) {
      return Colors.orangeAccent;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        (item.imageUrls.isNotEmpty && item.imageUrls.first.isNotEmpty)
            ? item.imageUrls.first
            : '';
    final status = item.status ?? "Available";

    return GestureDetector(
      onTap: () => Get.to(() => PropertyDetailsScreen(property: item)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeFile.height10),
          border: Border.all(color: ColorFile.borderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==== Image + Status + Heart ====
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(SizeFile.height10),
                      child: imageUrl.isEmpty
                          ? const Icon(Icons.broken_image)
                          : Image.network(imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image)),
                    ),
                  ),
                  Positioned(
                    left: 6,
                    top: 6,
                    child: _StatusBadge(
                      status: status,
                      color: _statusColor(status),
                    ),
                  ),
                  Positioned(
                    right: 6,
                    bottom: 6,
                    child: Image.asset(AssetImagePaths.heartCircle,
                        height: SizeFile.height20),
                  ),
                ],
              ),
            ),
            // ==== Title + Location ====
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontFamily: satoshiBold,
                          fontSize: SizeFile.height14)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        item.averageRatingModel?.averageRating
                                .toStringAsFixed(1) ??
                            "0.0",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "(${item.averageRatingModel?.totalReviews ?? 0} reviews)",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(AssetImagePaths.southeastLogo,
                          height: SizeFile.height10, width: SizeFile.height10),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(item.region,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: satoshiRegular,
                                fontSize: SizeFile.height12,
                                color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;
  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white, // background stays white
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontFamily: satoshiBold,
        ),
      ),
    );
  }
}

// ===== Horizontal property cards with Status badge =====
class _HorizontalPropertyCards extends StatelessWidget {
  final List<HomePlaceModel> items;
  const _HorizontalPropertyCards({required this.items});

  Color _statusColor(String? status) {
    final s = (status ?? '').toLowerCase();
    if (s.contains('booked') || s.contains('unavailable')) {
      return Colors.redAccent;
    }
    if (s.contains('pending') || s.contains('reserved')) {
      return Colors.orangeAccent;
    }
    return Colors.green;
  }

  String _safeStr(dynamic v, [String fallback = '']) =>
      v == null ? fallback : v.toString();

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox(
        height: SizeFile.height60,
        child: Center(
            child: Text('No properties to show.',
                style: TextStyle(fontFamily: satoshiRegular))),
      );
    }
    return SizedBox(
      height: SizeFile.height172,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final title = _safeStr(item.title);
          final region = _safeStr(item.region, '—');
          final imageUrl =
              (item.imageUrls.isNotEmpty && item.imageUrls.first.isNotEmpty)
                  ? item.imageUrls.first
                  : '';
          final status = _safeStr(item.status, 'Available');

          return GestureDetector(
            onTap: () => Get.to(() => PropertyDetailsScreen(property: item)),
            child: Container(
              width: SizeFile.height148,
              padding: EdgeInsets.all(SizeFile.height8),
              margin: const EdgeInsets.only(right: SizeFile.height18),
              decoration: BoxDecoration(
                color: ColorFile.whiteColor,
                borderRadius: BorderRadius.circular(SizeFile.height10),
                border: Border.all(
                    color: ColorFile.borderColor, width: SizeFile.height1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image + Status
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(SizeFile.height8),
                            child: imageUrl.isEmpty
                                ? const Icon(Icons.broken_image)
                                : Image.network(imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.broken_image)),
                          ),
                        ),
                        Positioned(
                          left: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusColor(status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(status,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: satoshiBold)),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          bottom: 4,
                          child: Image.asset(AssetImagePaths.heartCircle,
                              height: SizeFile.height20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: ColorFile.onBordingColor,
                          fontFamily: satoshiBold,
                          fontSize: SizeFile.height14)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        item.averageRatingModel?.averageRating
                                .toStringAsFixed(1) ??
                            "0.0",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "(${item.averageRatingModel?.totalReviews ?? 0} reviews)",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(AssetImagePaths.southeastLogo,
                          height: SizeFile.height10, width: SizeFile.height10),
                      const SizedBox(width: SizeFile.height5),
                      Expanded(
                        child: Text(region,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: ColorFile.onBordingColor,
                                fontFamily: satoshiRegular,
                                fontSize: SizeFile.height12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
