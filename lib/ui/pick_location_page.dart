import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/controllers/pick_location_controller.dart';
import 'package:story_app/widgets/location_bottom_sheet.dart';

class PickLocationPage extends StatefulWidget {
  final double? initialLat;
  final double? initialLon;

  const PickLocationPage({super.key, this.initialLat, this.initialLon});

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  late final PickLocationController controller;

  @override
  void initState() {
    super.initState();
    controller = PickLocationController();
    controller.initialize(widget.initialLat, widget.initialLon);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _handleMapTap(LatLng tappedLocation) async {
    await controller.handleMapTap(tappedLocation);
  }

  void _selectLocation() {
    Navigator.of(context).pop({
      'latitude': controller.selectedLocation.latitude,
      'longitude': controller.selectedLocation.longitude,
      'address': controller.selectedAddress,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Pick Location'), elevation: 0),
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: controller.currentLocation,
                  zoom: 15,
                ),
                onMapCreated: controller.setMapController,
                onTap: _handleMapTap,
                markers: {
                  Marker(
                    markerId: const MarkerId("selected_location"),
                    position: controller.selectedLocation,
                    infoWindow: InfoWindow(
                      title: 'Lokasi Terpilih',
                      snippet:
                          'Lat: ${controller.selectedLocation.latitude.toStringAsFixed(6)}, Lon: ${controller.selectedLocation.longitude.toStringAsFixed(6)}',
                    ),
                  ),
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LocationBottomSheet(
                  selectedLocation: controller.selectedLocation,
                  selectedAddress: controller.selectedAddress,
                  isLoadingAddress: controller.isLoadingAddress,
                  onSelectLocation: _selectLocation,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
