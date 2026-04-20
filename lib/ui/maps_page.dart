import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/routes/route_delegate.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key, this.lan, this.lat, required this.routerDelegate});

  final double? lan;
  final double? lat;
  final MyRouterDelegate routerDelegate;

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final Set<Marker> markers = {};
  late GoogleMapController mapController;
  late LatLng location;

  @override
  void initState() {
    super.initState();
    location = LatLng(widget.lat ?? 0, widget.lan ?? 0);
    print('location $location');
    final marker = Marker(
      markerId: const MarkerId("location_marker"),
      position: location,
      onTap: () {
        mapController.animateCamera(CameraUpdate.newLatLngZoom(location, 18));
      },
    );
    markers.add(marker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => widget.routerDelegate.backFromMaps(),
        ),
      ),
      body: Center(
        child: location.latitude == 0 && location.longitude == 0
            ? const Text('Location data not available')
            : GoogleMap(
                markers: markers,
                initialCameraPosition: CameraPosition(
                  target: location,
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  setState(() {
                    mapController = controller;
                  });
                },
              ),
      ),
    );
  }
}
