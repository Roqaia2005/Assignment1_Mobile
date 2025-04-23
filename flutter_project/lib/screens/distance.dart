import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:student_registeration/models/store.dart';
import 'package:student_registeration/provider/fav_provider.dart';
import 'package:hive/hive.dart';

class DistanceScreen extends StatefulWidget {
  const DistanceScreen({super.key});

  @override
  State<DistanceScreen> createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  Position? _currentPosition;
  Store? _selectedStore;
  double? _distanceInMeters;

  final Color primaryColor = const Color.fromARGB(255, 255, 123, 167);

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  void _calculateDistance() {
    if (_currentPosition != null && _selectedStore != null) {
      final distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _selectedStore!.latitude,
        _selectedStore!.longitude,
      );
      setState(() {
        _distanceInMeters = distance;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavProvider>(context);
    final storeBox = Hive.box<Store>('stores');
    final favStores = storeBox.values
        .where((store) => favProvider.favIds.contains(store.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Distance to Favorite Store"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 182, 193), // soft pink
              Color.fromARGB(255, 255, 123, 167), // main color
              Color.fromARGB(255, 255, 210, 220), // light pink
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _currentPosition == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Select a favorite store:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<Store>(
                                hint: const Text("Choose store"),
                                value: _selectedStore,
                                isExpanded: true,
                                items: favStores.map((store) {
                                  return DropdownMenuItem<Store>(
                                    value: store,
                                    child: Text(store.name),
                                  );
                                }).toList(),
                                onChanged: (store) {
                                  setState(() {
                                    _selectedStore = store;
                                    _distanceInMeters = null;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: _selectedStore == null
                                ? null
                                : _calculateDistance,
                            icon: const Icon(Icons.location_on,
                                color: Colors.white),
                            label: const Text("Calculate Distance"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(fontSize: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          if (_distanceInMeters != null)
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: primaryColor.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.directions_walk,
                                        size: 30, color: primaryColor),
                                    const SizedBox(width: 16),
                                    Text(
                                      "Distance: ${(_distanceInMeters! / 1000).toStringAsFixed(2)} km",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
