import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapsPageController extends ChangeNotifier {
  final Set<Marker> markers = {};
  late GoogleMapController mapController;
  late LatLng location;
  MapType selectedMapType = MapType.normal;
  String? selectedAddress;
  VoidCallback? onShowAddressBottomSheet;

  void initialize(double? lat, double? lon) {
    location = LatLng(lat ?? 0, lon ?? 0);
    final marker = Marker(
      markerId: const MarkerId("location_marker"),
      position: location,
      onTap: () => handleMarkerTap(),
    );
    markers.add(marker);
  }

  Future<void> handleMarkerTap() async {
    mapController.animateCamera(CameraUpdate.newLatLngZoom(location, 18));
    onShowAddressBottomSheet?.call();
  }

  Future<String?> getAddressFromCoordinates() async {
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

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  void changeMapType(MapType mapType) {
    selectedMapType = mapType;
    notifyListeners();
  }
}
