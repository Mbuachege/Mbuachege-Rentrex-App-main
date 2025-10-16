import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:prime_travel_flutter_ui_kit/model/booking_model.dart';
import 'package:prime_travel_flutter_ui_kit/services/booking_unlock.dart';
import 'package:prime_travel_flutter_ui_kit/services/unlockService.dart';

class UnlockAccessScreen extends StatefulWidget {
  const UnlockAccessScreen({super.key});

  @override
  State<UnlockAccessScreen> createState() => _UnlockAccessScreenState();
}

class _UnlockAccessScreenState extends State<UnlockAccessScreen> {
  Booking? booking;

  // Google Maps
  GoogleMapController? _map;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _myLocationEnabled = false;
  LatLng? _me;
  LatLng? _prop;

  // Unlock via Code
  bool _showCodeCard = false;
  String? _unlockCode;
  DateTime? _startDate;
  DateTime? _endDate;

  // Distance/ETA
  String? _distanceKm;
  String? _etaDrive;
  String? _etaWalk;
  double? _distanceMeters;
  bool _isNear = false;
  static const double _unlockRadiusMeters = 5000.0; // 20 km

  static const platform = MethodChannel('igloo_plugin_channel');

  Future<String> _getApiKey() async {
    final key = await platform.invokeMethod<String>('getApiKey');
    return key ?? '';
  }

  // Live location
  StreamSubscription<Position>? _posSub;

  // ===== Bluetooth (Native bridge) =====
  static const MethodChannel _bleChannel = MethodChannel('igloo_ble');

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  Future<void> _loadBooking() async {
    try {
      final bookings = await BookingUnlockApi().getBookingsByGuest();
      if (bookings.isNotEmpty) {
        setState(() {
          booking = bookings.first;
          _prop = LatLng(booking!.latitude, booking!.longitude);
        });
        _initLocationAndRoute();
      }
    } catch (e) {
      debugPrint("Error fetching booking: $e");
    }
  }

  @override
  void dispose() {
    _posSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Back',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: booking == null
          ? const Center(child: CircularProgressIndicator())
          : (booking!.id == 0)
              ? const Center(child: Text('No active booking found.'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildBookingInfoCard(),
                    const SizedBox(height: 12),
                    _buildUnlockOptions(theme),
                    if (_showCodeCard && _unlockCode != null) ...[
                      const SizedBox(height: 12),
                      _buildCodeCard(theme),
                    ],
                    const SizedBox(height: 12),
                    if (!_isNear) _buildProximityWarning(),
                    const SizedBox(height: 12),
                    if (_distanceKm != null) _buildDistanceChips(),
                    const SizedBox(height: 12),
                    _buildMap(),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Booking #${booking!.id}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
    );
  }

  // ==================== UI SECTIONS ====================

  Widget _buildBookingInfoCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking!.propertyName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Unit: ${booking!.unitName}"),
            Text("Price: \$${booking!.totalPrice}"),
            Text("Address: ${booking!.address}"),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockOptions(ThemeData theme) {
    final canUnlock =
        _distanceMeters != null && _isNear; // enable only when in radius

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unlock Options',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          // Unlock via Code
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.vpn_key),
              label: const Text('Unlock via Code'),
              onPressed: canUnlock ? _handleUnlockViaCode : null,
            ),
          ),

          const SizedBox(height: 8),

          // Unlock via Bluetooth
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.bluetooth),
              label: const Text('Unlock via Bluetooth'),
              onPressed: canUnlock ? _handleBluetoothUnlock : null,
            ),
          ),

          if (!canUnlock) ...[
            const SizedBox(height: 8),
            Text(
              _distanceMeters == null
                  ? 'Getting your location…'
                  : 'Move within ${_unlockRadiusMeters.toStringAsFixed(0)} m to enable unlock.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCodeCard(ThemeData theme) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unlock by Code',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              _unlockCode ?? '',
              textAlign: TextAlign.center,
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              (_startDate != null && _endDate != null)
                  ? 'Code valid between\n${_fmtDate(_startDate!)} and ${_fmtDate(_endDate!)}'
                  : 'Validity not available',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProximityWarning() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.deepOrange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _distanceMeters == null
                  ? 'Waiting for your location… move closer to the property to reveal the code.'
                  : 'You are ${(_distanceMeters! / 1000).toStringAsFixed(2)} km away. '
                      'Move within ${_unlockRadiusMeters.toStringAsFixed(0)} m to reveal the code.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _chip('Distance: $_distanceKm'),
        if (_etaDrive != null) _chip('Drive: $_etaDrive'),
        if (_etaWalk != null) _chip('Walk: $_etaWalk'),
      ],
    );
  }

  Widget _buildMap() {
    return SizedBox(
      height: 260,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GoogleMap(
          onMapCreated: (c) async {
            _map = c;
            _addPropertyMarkerOnly();
            if (_me != null) {
              await _fitRoute();
            } else {
              await _map?.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: _prop ?? const LatLng(0, 0), zoom: 14),
                ),
              );
            }
          },
          initialCameraPosition: CameraPosition(
            target: _prop ?? const LatLng(0, 0),
            zoom: 12,
          ),
          markers: _markers,
          polylines: _polylines,
          myLocationEnabled: _myLocationEnabled,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          compassEnabled: true,
        ),
      ),
    );
  }

  // ==================== Unlock Logic ====================

  void _handleUnlockViaCode() {
    if (booking == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return FutureBuilder<String>(
          future: UnlockService().unlockWithCode(
            lockId: booking!.lockId,
            bookingId: booking!.id,
            variance: 1,
            startDate: booking!.checkIn,
            endDate: booking!.checkOut,
            propertyName: booking!.propertyName,
            unitName: booking!.unitName,
            guestName: booking!.guestName,
            address: booking!.address,
            guestEmail: booking!.guestEmail,
          ),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const AlertDialog(
                title: Text('Unlocking...'),
                content: SizedBox(
                  height: 50,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            } else if (snap.hasError) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('${snap.error}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Close'),
                  ),
                ],
              );
            } else {
              _unlockCode = snap.data;
              _startDate = booking!.checkIn;
              _endDate = booking!.checkOut;

              Future.microtask(() {
                Navigator.of(ctx).pop();
                setState(() {
                  _showCodeCard = true;
                });
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Code $_unlockCode sent to ${booking!.guestEmail}",
                    ),
                  ),
                );
              });

              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  // ===== Bluetooth helpers =====
  Future<void> _handleBluetoothUnlock() async {
    final updates = StreamController<String>();
    StreamSubscription? subscription;
    bool cancelled = false;

    try {
      // Show cancellable progress dialog
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: const Text('Unlocking Lock'),
              content: SizedBox(
                width: double.maxFinite,
                child: StreamBuilder<String>(
                  stream: updates.stream,
                  initialData: 'Starting...',
                  builder: (ctx, snap) => Text(snap.data ?? ''),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    cancelled = true;
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          );
        },
      );

      if (cancelled) {
        updates.add('Cancelled by user');
        await FlutterBluePlus.stopScan();
        await subscription?.cancel();
        return;
      }

      // ===== Request permissions =====
      updates.add('Checking permissions...');
      final permissions = [
        Permission.location,
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ];
      final status = await permissions.request();
      final denied = status.entries.where(
        (e) => e.value != PermissionStatus.granted,
      );
      if (denied.isNotEmpty) {
        updates.add('Required permissions denied');
        return;
      }
      updates.add('Permissions granted');

      // ===== Start scanning =====
      updates.add('Scanning for nearby devices...');
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

      subscription = FlutterBluePlus.scanResults.listen((results) async {
        if (cancelled) return;

        for (final r in results) {
          updates.add('Found device: ${r.device.platformName}');
          if (r.device.platformName == "MySmartLock") {
            updates.add('Lock found! Connecting...');
            await FlutterBluePlus.stopScan();

            // Simulate unlock
            await Future.delayed(const Duration(seconds: 1));
            updates.add('Unlock command sent');
            await r.device.disconnect();
            updates.add('Lock unlocked!');
            break;
          }
        }
      });

      await Future.delayed(const Duration(seconds: 5));
      await FlutterBluePlus.stopScan();
      await subscription.cancel();
    } catch (e) {
      debugPrint('Bluetooth unlock error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Bluetooth unlock failed: $e')));
      }
    } finally {
      updates.close();
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Ensure dialog closes
      }
    }
  }

  Future<void> _ensureBluetoothPermissions() async {
    // Location needed for BLE scan on many Android versions
    final loc = await Permission.location.request();
    if (!loc.isGranted) throw Exception('Location permission is required');

    // Android 12+ specific permissions
    final scan = await Permission.bluetoothScan.request();
    final conn = await Permission.bluetoothConnect.request();
    if (!scan.isGranted || !conn.isGranted) {
      throw Exception('Bluetooth permissions are required');
    }
  }

  Future<void> _showBleProgressDialog({
    required String title,
    required String message,
    bool dismissible = false,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (_) => PopScope(
        canPop: dismissible,
        onPopInvoked: (didPop) {
          // You can run cleanup logic here if needed
        },
        child: AlertDialog(
          title: Text(title),
          content: Row(
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          actions: [
            if (dismissible)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
          ],
        ),
      ),
    );
  }

  // ==================== Helpers ====================

  void _addPropertyMarkerOnly() {
    if (_prop == null) return;
    _markers
      ..removeWhere((m) => m.markerId.value == 'property')
      ..add(
        Marker(
          markerId: const MarkerId('property'),
          position: _prop!,
          infoWindow: const InfoWindow(title: 'Property'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
  }

  Future<void> _initLocationAndRoute() async {
    final status = await Permission.location.request();
    if (!status.isGranted) return;
    if (!await Geolocator.isLocationServiceEnabled()) return;

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _me = LatLng(pos.latitude, pos.longitude);
      _myLocationEnabled = true;

      _markers
        ..removeWhere((m) => m.markerId.value == 'me')
        ..add(
          Marker(
            markerId: const MarkerId('me'),
            position: _me!,
            infoWindow: const InfoWindow(title: 'You'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        );

      _addPropertyMarkerOnly();
      _drawPolyline();
      _computeDistanceAndEta();
      setState(() {});
      await _fitRoute();

      _posSub?.cancel();
      _posSub = Geolocator.getPositionStream().listen((pos) {
        _me = LatLng(pos.latitude, pos.longitude);
        _drawPolyline();
        _computeDistanceAndEta();
        setState(() {});
      });
    } catch (e) {
      debugPrint('getCurrentPosition error: $e');
      _addPropertyMarkerOnly();
    }
  }

  Future<void> _drawPolyline() async {
    if (_me == null || _prop == null) return;

    try {
      // 🔹 Fetch API key from AndroidManifest.xml
      final apiKey = await _getApiKey();

      if (apiKey.isEmpty) {
        debugPrint('❌ API key not found in manifest.');
        return;
      }

      final url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${_me!.latitude},${_me!.longitude}&destination=${_prop!.latitude},${_prop!.longitude}&mode=driving&key=$apiKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if ((data['routes'] as List).isNotEmpty) {
          final overviewPolyline =
              data['routes'][0]['overview_polyline']['points'];

          final polylinePoints = PolylinePoints(apiKey: apiKey);
          final decodedPoints = PolylinePoints.decodePolyline(overviewPolyline);

          final polylineCoordinates = decodedPoints
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          setState(() {
            _polylines
              ..removeWhere((p) => p.polylineId.value == 'route')
              ..add(
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: polylineCoordinates,
                  color: Colors.blue,
                  width: 5,
                ),
              );
          });

          _fitMapToPolyline(polylineCoordinates);
        } else {
          debugPrint('No route found from Directions API.');
        }
      } else {
        debugPrint('Directions API error: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching route: $e');
    }
  }

  void _fitMapToPolyline(List<LatLng> points) {
    if (_map == null || points.isEmpty) return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b),
        points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b),
      ),
      northeast: LatLng(
        points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b),
        points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b),
      ),
    );

    _map!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  void _computeDistanceAndEta() {
    if (_me == null || _prop == null) return;

    final meters = Geolocator.distanceBetween(
      _me!.latitude,
      _me!.longitude,
      _prop!.latitude,
      _prop!.longitude,
    );
    _distanceMeters = meters;
    _isNear = meters <= _unlockRadiusMeters;

    final km = meters / 1000.0;
    _distanceKm = '${km.toStringAsFixed(km < 10 ? 2 : 1)} km';
    _etaDrive = _fmtEta(_etaFrom(km, 40));
    _etaWalk = _fmtEta(_etaFrom(km, 5));
  }

  Future<void> _fitRoute() async {
    if (_map == null || _prop == null) return;
    final pts = <LatLng>[_prop!, if (_me != null) _me!];

    final lats = pts.map((e) => e.latitude).toList();
    final lngs = pts.map((e) => e.longitude).toList();
    final south = lats.reduce(min);
    final north = lats.reduce(max);
    final west = lngs.reduce(min);
    final east = lngs.reduce(max);

    final bounds = LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );

    try {
      await _map!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 48));
    } catch (_) {
      await _map!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _prop!, zoom: 14),
        ),
      );
    }
  }

  Duration _etaFrom(double km, double speedKmh) {
    if (speedKmh <= 0) return Duration.zero;
    final hours = km / speedKmh;
    return Duration(minutes: (hours * 60).round());
  }

  String _fmtEta(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h <= 0) return '$m min';
    return '$h h $m min';
  }

  String _fmtDate(DateTime d) {
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} "
        "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x11000000),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
