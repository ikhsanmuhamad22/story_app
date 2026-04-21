import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTypeSelector extends StatelessWidget {
  final MapType selectedMapType;
  final ValueChanged<MapType> onMapTypeChanged;

  const MapTypeSelector({
    super.key,
    required this.selectedMapType,
    required this.onMapTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: FloatingActionButton.small(
        onPressed: null,
        child: PopupMenuButton<MapType>(
          onSelected: onMapTypeChanged,
          offset: const Offset(0, 54),
          icon: const Icon(Icons.layers_outlined),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<MapType>>[
            const PopupMenuItem<MapType>(
              value: MapType.normal,
              child: Text('Normal'),
            ),
            const PopupMenuItem<MapType>(
              value: MapType.satellite,
              child: Text('Satellite'),
            ),
            const PopupMenuItem<MapType>(
              value: MapType.terrain,
              child: Text('Terrain'),
            ),
            const PopupMenuItem<MapType>(
              value: MapType.hybrid,
              child: Text('Hybrid'),
            ),
          ],
        ),
      ),
    );
  }
}
