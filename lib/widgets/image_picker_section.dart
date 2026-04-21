// lib/widgets/image_picker_section.dart
import 'dart:io';
import 'package:flutter/material.dart';

class ImagePickerSection extends StatelessWidget {
  final File? selectedImage;
  final bool isLoading;
  final VoidCallback onPickFromGallery;
  final VoidCallback onPickFromCamera;

  const ImagePickerSection({
    super.key,
    this.selectedImage,
    required this.isLoading,
    required this.onPickFromGallery,
    required this.onPickFromCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: selectedImage != null
          ? Column(
              children: [
                Image.file(
                  selectedImage!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: isLoading ? null : onPickFromGallery,
                  icon: const Icon(Icons.image),
                  label: const Text('Change Image'),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.image_not_supported,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text('pick an image'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : onPickFromGallery,
                        icon: const Icon(Icons.image),
                        label: const Text('Gallery'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : onPickFromCamera,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
