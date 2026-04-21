import 'package:flutter/material.dart';

class LocationSection extends StatelessWidget {
  final String? selectedAddress;
  final double? selectedLat;
  final double? selectedLon;
  final bool isLoading;
  final VoidCallback onPickLocation;

  const LocationSection({
    super.key,
    this.selectedAddress,
    this.selectedLat,
    this.selectedLon,
    required this.isLoading,
    required this.onPickLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedAddress != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedAddress!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Lat: ${selectedLat?.toStringAsFixed(6)}, Lon: ${selectedLon?.toStringAsFixed(6)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            )
          else
            const Row(
              children: [
                Icon(Icons.location_off, color: Colors.grey, size: 20),
                SizedBox(width: 8),
                Text(
                  'Pick your location',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onPickLocation,
              icon: const Icon(Icons.map),
              label: const Text('Pilih Lokasi'),
            ),
          ),
        ],
      ),
    );
  }
}
