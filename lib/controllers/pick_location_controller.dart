import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class PickLocationController extends ChangeNotifier {
  late GoogleMapController mapController;
  late LatLng selectedLocation;
  late LatLng currentLocation;
  String? selectedAddress;
  bool isLoadingAddress = false;

  void initialize(double? initialLat, double? initialLon) {
    currentLocation = LatLng(initialLat ?? -6.200000, initialLon ?? 106.816666);
    selectedLocation = currentLocation;
  }

  Future<String?> getAddressFromCoordinates(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      }
      return 'Address not found';
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<void> handleMapTap(LatLng tappedLocation) async {
    selectedLocation = tappedLocation;
    isLoadingAddress = true;
    notifyListeners();

    mapController.animateCamera(CameraUpdate.newLatLngZoom(tappedLocation, 18));

    final address = await getAddressFromCoordinates(tappedLocation);
    selectedAddress = address;
    isLoadingAddress = false;
    notifyListeners();
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }
}
