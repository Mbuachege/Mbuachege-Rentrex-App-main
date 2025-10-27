import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/view/login_screem/login_screen.dart';
import 'package:prime_travel_flutter_ui_kit/view/my_booking_screen/complete_booking_screen.dart';
import '../../model/home_place_model.dart';

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
  double? _distanceInKm;

  Set<Polyline> _polylines = {};
  static const platform = MethodChannel('igloo_plugin_channel');

  Future<String> _getApiKey() async {
    final key = await platform.invokeMethod<String>('getApiKey');
    return key ?? '';
  }

  // Track selected image for gallery
  int _selectedImageIndex = 0;

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

  /// Initialize location tracking
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
      setState(() {
        _currentLocation = pos;
        if (widget.property.hasCoordinates) {
          _calculateDistance(pos);
          _createPolylineRoute(pos);
        }
      });

      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLng(pos));
      }
    });
  }

  /// Calculate distance
  void _calculateDistance(LatLng currentLocation) {
    final propertyLocation = LatLng(
      widget.property.latitude!,
      widget.property.longitude!,
    );

    _distanceInKm = Geolocator.distanceBetween(
          currentLocation.latitude,
          currentLocation.longitude,
          propertyLocation.latitude,
          propertyLocation.longitude,
        ) /
        1000;
  }

  /// Create polyline route
  Future<void> _createPolylineRoute(LatLng currentLocation) async {
    if (!widget.property.hasCoordinates) return;

    final propertyLocation = LatLng(
      widget.property.latitude!,
      widget.property.longitude!,
    );

    final apiKey = await _getApiKey();

    if (apiKey.isEmpty) {
      debugPrint('❌ API key not found in manifest.');
      return;
    }

    try {
      final url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${currentLocation.latitude},${currentLocation.longitude}&destination=${propertyLocation.latitude},${propertyLocation.longitude}&mode=driving&key=$apiKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if ((data['routes'] as List).isNotEmpty) {
          final route = data['routes'][0];
          final overviewPolyline = route['overview_polyline']['points'];

          // ✅ Create PolylinePoints with apiKey (new version requirement)
          // ignore: unused_local_variable
          final polylinePoints = PolylinePoints(apiKey: apiKey);

          final points = PolylinePoints.decodePolyline(overviewPolyline);

          final polylineCoordinates =
              points.map((p) => LatLng(p.latitude, p.longitude)).toList();

          setState(() {
            _polylines = {
              Polyline(
                polylineId: const PolylineId("route"),
                color: ColorFile.onBordingColor,
                width: 5,
                points: polylineCoordinates,
              ),
            };
          });

          // ✅ Optional: Auto fit camera to show full route
          _fitMapToPolyline(polylineCoordinates);
        } else {
          debugPrint("No routes found in Directions API response.");
        }
      } else {
        debugPrint("Directions API error: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetching route: $e");
    }
  }

  void _fitMapToPolyline(List<LatLng> points) {
    if (_mapController == null || points.isEmpty) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b),
        points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b),
      ),
      northeast: LatLng(
        points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b),
        points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b),
      ),
    );

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  /// Travel Info Section
  Widget _travelInfoSection() {
    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day, 23, 59, 59);
    Duration remaining = midnight.difference(now);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: ColorFile.onBordingColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "${now.day}-${now.month}-${now.year}  ${now.hour}:${now.minute.toString().padLeft(2, '0')}\n"
                "Time until midnight: ${remaining.inHours} hrs ${remaining.inMinutes % 60} mins",
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Amenities Section
  Widget _amenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Amenities:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 4.0,
          mainAxisSpacing: 8, // Slightly bigger for better spacing with borders
          crossAxisSpacing: 8,
          children: [
            _buildAmenity(Icons.bed, "Twin sharing rooms"),
            _buildAmenity(Icons.directions_car, "Private cab with driver"),
            _buildAmenity(Icons.tour, "Sightseeing cab"),
            _buildAmenity(Icons.restaurant, "Breakfast, Dinner"),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAmenity(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1), // border
        borderRadius: BorderRadius.circular(8), // rounded corners
        color: Colors.white, // background color (keeps it clean)
      ),
      child: Row(
        children: [
          Icon(icon, color: ColorFile.onBordingColor, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Map Section
  Widget _styledMapSection() {
    final target = widget.property.hasCoordinates
        ? LatLng(widget.property.latitude!, widget.property.longitude!)
        : (_currentLocation ?? const LatLng(0, 0));

    final markers = <Marker>{};
    if (widget.property.hasCoordinates) {
      markers.add(
        Marker(
          markerId: MarkerId(widget.property.propertyId.toString()),
          position:
              LatLng(widget.property.latitude!, widget.property.longitude!),
          infoWindow: InfoWindow(title: widget.property.title),
        ),
      );
    }
    if (_currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("current_location"),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: "You are here"),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 260,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: target, zoom: 14),
          markers: markers,
          polylines: _polylines,
          onMapCreated: (controller) => _mapController = controller,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
    );
  }

  /// Login check
  bool checkUserLoginStatus() {
    final box = GetStorage();
    return box.read('isLoggedIn') ?? false;
  }

  /// Login dialog
  void showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 5,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.account_circle_outlined,
                      color: Colors.blueAccent, size: 40),
                  SizedBox(width: 8),
                  Text("Login Required",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent)),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Please log in to proceed with the booking.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(
                            popOnSuccess: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text("Login",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel",
                        style:
                            TextStyle(fontSize: 16, color: Colors.blueAccent)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;

    return Scaffold(
      appBar: AppBar(
        title: Text(property.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main image + gallery
            if (property.imageUrls.isNotEmpty) ...[
              // Main image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  property.imageUrls[_selectedImageIndex],
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Thumbnails (only if more than 1 image)
              if (property.imageUrls.length > 1) ...[
                const SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: property.imageUrls.length - 1,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      // Build list without selected image
                      final thumbnails = List<String>.from(property.imageUrls)
                        ..removeAt(_selectedImageIndex);

                      final imageUrl = thumbnails[index];

                      return GestureDetector(
                        onTap: () {
                          final newIndex = property.imageUrls.indexOf(imageUrl);
                          setState(() {
                            _selectedImageIndex = newIndex;
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 100,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],

            // Title + Region
            Text(property.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(property.region,
                style: const TextStyle(color: ColorFile.onBordingColor)),
            const SizedBox(height: 8),

            // Price (moved here)
            Text(
              "From \$${property.priceFrom?.toStringAsFixed(2) ?? '0.00'} / night",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 20),

            // Description
            if (property.description != null &&
                property.description!.isNotEmpty)
              Text(property.description!, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 20),

            // Travel Info
            _travelInfoSection(),
            const SizedBox(height: 20),

            // Amenities
            _amenitiesSection(),

            // Map
            _styledMapSection(),
            const SizedBox(height: 12),

            // Distance Info
            if (_distanceInKm != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    const Icon(Icons.map, size: 18, color: Colors.blueAccent),
                    const SizedBox(width: 6),
                    Text(
                      "${_distanceInKm!.toStringAsFixed(2)} km",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ]),
                  Row(children: [
                    const Icon(Icons.directions_walk,
                        size: 18, color: Colors.green),
                    const SizedBox(width: 6),
                    Text(
                      // Walking time = distance / 5 km/h * 60
                      "${(_distanceInKm! / 5 * 60).round()} min walk",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ]),
                  Row(children: [
                    const Icon(Icons.directions_car,
                        size: 18, color: Colors.orange),
                    const SizedBox(width: 6),
                    Text(
                      // Driving time = distance / 50 km/h * 60
                      "${(_distanceInKm! / 50 * 60).round()} min drive",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ]),
                ],
              ),
            const SizedBox(height: 20),

            // Book button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: ColorFile.onBordingColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final status = property.status?.toLowerCase() ?? '';

                  if (status.contains('pending') || status.contains('booked')) {
                    // ❌ Notify user that booking is not allowed
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'This house cannot be booked. Only available houses can be booked.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return; // Stop here
                  }

                  if (checkUserLoginStatus()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(
                          unitId: property.unitId.toString(),
                          unitName: property.title,
                          location: property.region,
                          basePrice: property.priceFrom ?? 0.0,
                          guests: 1,
                        ),
                      ),
                    );
                  } else {
                    showLoginDialog();
                  }
                },
                child: const Text("Book Now",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
