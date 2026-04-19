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
        child: widget.lan == null || widget.lat == null
            ? const Text('Location data not available')
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.lan ?? 0, widget.lat ?? 0),
                  zoom: 18,
                ),
              ),
      ),
    );
  }
}
