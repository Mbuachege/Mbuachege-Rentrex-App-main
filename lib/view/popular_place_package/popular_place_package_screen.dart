import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prime_travel_flutter_ui_kit/view/my_booking_screen/complete_booking_screen.dart';
import '../../model/home_place_model.dart';
import '../../util/asset_image_paths.dart';
import '../../util/colors.dart';
import '../../util/size_config.dart';
import '../../util/font_family.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final HomePlaceModel property;

  const PropertyDetailsScreen({Key? key, required this.property})
      : super(key: key);

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionStream;
  LatLng? _currentLocation;
  int placeImageIndex = 0;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final bool _myLocationEnabled = false;

  late final LatLng _propertyLatLng = LatLng(
    widget.property.latitude ?? 37.4220041,
    widget.property.longitude ?? -122.0862462,
  );

  String? _distanceTextKm;
  String? _etaWalk;
  String? _etaDrive;

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _initLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }
    }

    _positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      final pos = LatLng(position.latitude, position.longitude);
      setState(() => _currentLocation = pos);

      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLng(pos));
      }
    });
  }

  Widget _chip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeFile.height8, vertical: SizeFile.height4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: ColorFile.borderColor),
        borderRadius: BorderRadius.circular(SizeFile.height20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: SizeFile.height12,
          fontFamily: satoshiMedium,
          color: ColorFile.onBordingColor,
        ),
      ),
    );
  }

  Widget _circleBtn(
      {required IconData icon, required VoidCallback onTap, String? tooltip}) {
    final child = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
        ),
        child: Icon(icon, color: ColorFile.onBordingColor),
      ),
    );
    return tooltip == null ? child : Tooltip(message: tooltip, child: child);
  }

  void _addOrReplaceMarker({
    required String id,
    required LatLng position,
    required String title,
    required double hue,
  }) {
    _markers.removeWhere((m) => m.markerId.value == id);
    _markers.add(
      Marker(
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(title: title),
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      ),
    );
  }

  Future<void> _drawRouteAndStats() async {
    if (_currentLocation == null || _mapController == null) return;

    final route = Polyline(
      polylineId: const PolylineId('route'),
      points: [_currentLocation!, _propertyLatLng],
      width: 5,
      color: Colors.blue,
      geodesic: true,
    );

    _polylines
      ..removeWhere((p) => p.polylineId.value == 'route')
      ..add(route);

    final meters = Geolocator.distanceBetween(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      _propertyLatLng.latitude,
      _propertyLatLng.longitude,
    );
    final km = meters / 1000.0;

    _distanceTextKm = '${km.toStringAsFixed(km < 10 ? 2 : 1)} km';
    _etaDrive = _fmtEta(_etaFromDistance(km, 40));
    _etaWalk = _fmtEta(_etaFromDistance(km, 5));

    setState(() {});
  }

  Future<void> _fitRouteBounds() async {
    if (_mapController == null) return;

    final points = <LatLng>[_propertyLatLng];
    if (_currentLocation != null) points.add(_currentLocation!);

    final lats = points.map((e) => e.latitude).toList();
    final lngs = points.map((e) => e.longitude).toList();

    final south = lats.reduce((a, b) => a < b ? a : b);
    final north = lats.reduce((a, b) => a > b ? a : b);
    final west = lngs.reduce((a, b) => a < b ? a : b);
    final east = lngs.reduce((a, b) => a > b ? a : b);

    final bounds = LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );

    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 48),
      );
    } catch (_) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: points.first, zoom: 14),
        ),
      );
    }
  }

  Duration _etaFromDistance(double km, double speedKmh) {
    if (speedKmh <= 0) return const Duration();
    final hours = km / speedKmh;
    return Duration(minutes: (hours * 60).round());
  }

  String _fmtEta(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h <= 0) return '$m min';
    return '$h h $m min';
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;

    return Scaffold(
      appBar: AppBar(
        title: Text(property.title),
        backgroundColor: ColorFile.whiteColor,
        foregroundColor: ColorFile.onBordingColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeFile.height20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Main Image + Gallery =====
            if (property.imageUrls.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(SizeFile.height12),
                child: Image.network(
                  property.imageUrls[placeImageIndex],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: SizeFile.height200,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            SizedBox(height: SizeFile.height16),

            // ===== Title and Region =====
            Text(
              property.title,
              style: const TextStyle(
                  fontSize: SizeFile.height22, fontWeight: FontWeight.bold),
            ),
            Text(
              property.region,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // ===== Description =====
            if (property.description != null &&
                property.description!.isNotEmpty)
              Text(property.description!),
            const SizedBox(height: SizeFile.height20),

            // ===== Map Section =====
            _mapSection(),
            const SizedBox(height: SizeFile.height20),

            // ===== Price and Address =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.priceFrom != null
                          ? '\$${property.priceFrom!.toStringAsFixed(2)}'
                          : '\$88.12',
                      style: const TextStyle(
                        fontFamily: satoshiBold,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeFile.height24,
                        color: ColorFile.onBordingColor,
                      ),
                    ),
                    const SizedBox(height: SizeFile.height8),
                    Text(
                      property.address.isNotEmpty
                          ? property.address
                          : 'Address not available',
                      style: TextStyle(fontFamily: satoshiRegular),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: SizeFile.height20),

            // ===== Book Now Button =====
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       //context,
            //       //MaterialPageRoute(
            //         // builder: (context) => BookingPage(
            //         //   unitName: property.title,
            //         //   guests: 1,
            //         //   checkIn: DateTime.now(),
            //         //   checkOut: DateTime.now().add(const Duration(days: 1)),
            //         // ),
            //       //),
            //     );
            //   },
            //   child: const Text("Book Now"),
            // ),
            const SizedBox(height: SizeFile.height20),

            // ===== Amenities Card =====
            _amenitiesCard(),
            const SizedBox(height: SizeFile.height20),
          ],
        ),
      ),
    );
  }

  // Map Section Widget
  Widget _mapSection() {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeFile.height12),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _propertyLatLng,
            zoom: 14,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('property'),
              position: _propertyLatLng,
              infoWindow: InfoWindow(title: widget.property.title),
            ),
            if (_currentLocation != null)
              Marker(
                markerId: const MarkerId('you'),
                position: _currentLocation!,
                infoWindow: const InfoWindow(title: 'You'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure),
              ),
          },
          polylines: _polylines,
          myLocationEnabled: _myLocationEnabled,
          onMapCreated: (controller) {
            _mapController = controller;
            _drawRouteAndStats();
            _fitRouteBounds();
          },
        ),
      ),
    );
  }

  // Amenities Card Widget
  Widget _amenitiesCard() {
    return Card(
      elevation: 0,
      color: ColorFile.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeFile.height12),
        side: BorderSide(color: ColorFile.borderColor, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeFile.height12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Amenities',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: SizeFile.height12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _amenityIcon(AssetImagePaths.wifiImage, 'WiFi'),
                _amenityIcon(AssetImagePaths.barImage, 'Bar'),
                _amenityIcon(AssetImagePaths.breakfastImage, 'Breakfast'),
                _amenityIcon(AssetImagePaths.poolImage, 'Pool'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Amenity Icon widget
  static Widget _amenityIcon(String asset, String label) {
    return Column(
      children: [
        Image.asset(asset, height: SizeFile.height36, width: SizeFile.height40),
        Text(
          label,
          style: TextStyle(
            color: ColorFile.onBordingColor,
            fontFamily: satoshiMedium,
            fontWeight: FontWeight.w500,
            fontSize: SizeFile.height12,
          ),
        ),
      ],
    );
  }
}
