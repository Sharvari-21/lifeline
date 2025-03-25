import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';

class NearbyHospitalsScreen extends StatefulWidget {
  @override
  _NearbyHospitalsScreenState createState() => _NearbyHospitalsScreenState();
}

class _NearbyHospitalsScreenState extends State<NearbyHospitalsScreen> {
  MapController _mapController = MapController();
  LatLng? currentLocation;
  List<dynamic> hospitals = [];
  double zoomLevel = 14.0;

  @override
  void initState() {
    super.initState();
    _getLocation(); // ✅ Fetch user's location
  }

  /// ✅ Get User's Location with Fallback
  Future<void> _getLocation() async {
    print("🔄 Setting default location to Mumbai...");

    setState(() {
      currentLocation = LatLng(19.0760, 72.8777); // Mumbai
      _mapController.move(currentLocation!, zoomLevel);
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("❌ Location services are disabled.");
        _fetchHospitals(19.0760, 72.8777);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("❌ Location permission denied.");
          _fetchHospitals(19.0760, 72.8777);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("❌ Location permission permanently denied.");
        _fetchHospitals(19.0760, 72.8777);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(currentLocation!, zoomLevel);
      });

      print("✅ GPS Location: ${position.latitude}, ${position.longitude}");
      _fetchHospitals(position.latitude, position.longitude);
    } catch (e) {
      print("⚠️ GPS failed, using Mumbai.");
      _fetchHospitals(19.0760, 72.8777);
    }
  }

  /// ✅ Fetch hospitals from OpenStreetMap (Nominatim)
  Future<void> _fetchHospitals(double lat, double lng) async {
    final String url =
        "https://nominatim.openstreetmap.org/search?format=json&q=hospital&limit=10&bounded=1&viewbox=${lng - 0.1},${lat - 0.1},${lng + 0.1},${lat + 0.1}";

    try {
      final response =
      await http.get(Uri.parse(url), headers: {"User-Agent": "FlutterApp"});
      if (response.statusCode == 200) {
        setState(() {
          hospitals = json.decode(response.body);
        });
      }
    } catch (e) {
      print("❌ Error fetching hospitals: $e");
    }
  }

  /// ✅ Go to current location
  void _goToCurrentLocation() {
    if (currentLocation != null) {
      _mapController.move(currentLocation!, zoomLevel);
    }
  }

  /// ✅ Zoom controls
  void _zoomIn() => setState(() => _mapController.move(currentLocation!, ++zoomLevel));
  void _zoomOut() => setState(() => _mapController.move(currentLocation!, --zoomLevel));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nearby Hospitals")),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator()) // ✅ Show loading indicator
          : Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: currentLocation!,
              initialZoom: zoomLevel,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app', // ✅ Fix for OpenStreetMap blocking
              ),
              MarkerLayer(
                markers: [
                  // ✅ Current location marker
                  Marker(
                    point: currentLocation!,
                    width: 50,
                    height: 50,
                    child: Icon(Icons.location_pin, color: Colors.blue, size: 40),
                  ),
                  // ✅ Hospital markers
                  ...hospitals.map((hospital) {
                    return Marker(
                      point: LatLng(double.parse(hospital["lat"]), double.parse(hospital["lon"])),
                      width: 80.0,
                      height: 80.0,
                      child: Icon(Icons.local_hospital, color: Colors.red, size: 30),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),

          // ✅ Floating buttons
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(heroTag: "zoom_in", onPressed: _zoomIn, child: Icon(Icons.zoom_in)),
                SizedBox(height: 10),
                FloatingActionButton(heroTag: "zoom_out", onPressed: _zoomOut, child: Icon(Icons.zoom_out)),
                SizedBox(height: 10),
                FloatingActionButton(heroTag: "current_location", onPressed: _goToCurrentLocation, child: Icon(Icons.my_location)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
