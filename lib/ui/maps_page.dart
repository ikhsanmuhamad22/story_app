import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/controllers/maps_page_controller.dart';
import 'package:story_app/routes/route_delegate.dart';
import 'package:story_app/widgets/address_bottom_sheet.dart';
import 'package:story_app/widgets/map_type_selector.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key, this.lan, this.lat, required this.routerDelegate});

  final double? lan;
  final double? lat;
  final MyRouterDelegate routerDelegate;

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late final MapsPageController controller;

  @override
  void initState() {
    super.initState();
    controller = MapsPageController();
    controller.initialize(widget.lat, widget.lan);
    controller.onShowAddressBottomSheet = _showAddressBottomSheet;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showAddressBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddressBottomSheet(
          location: controller.location,
          addressFuture: controller.getAddressFromCoordinates(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Location'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => widget.routerDelegate.backFromMaps(),
            ),
          ),
          body: Stack(
            children: [
              controller.location.latitude == 0 &&
                      controller.location.longitude == 0
                  ? const Text('Location data not available')
                  : GoogleMap(
                      mapType: controller.selectedMapType,
                      markers: controller.markers,
                      initialCameraPosition: CameraPosition(
                        target: controller.location,
                        zoom: 15,
                      ),
                      onMapCreated: controller.setMapController,
                    ),
              MapTypeSelector(
                selectedMapType: controller.selectedMapType,
                onMapTypeChanged: controller.changeMapType,
              ),
            ],
          ),
        );
      },
    );
  }
}
