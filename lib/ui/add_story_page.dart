import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/story_provider.dart';

class AddStoryPage extends StatefulWidget {
  final VoidCallback onBack;

  const AddStoryPage({super.key, required this.onBack});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final _descriptionController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final Location _location = Location();
  File? _selectedImage;

  Future<LocationData?> _getCurrentLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    var permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return null;
      }
    }

    if (permissionStatus != PermissionStatus.granted) {
      return null;
    }

    return await _location.getLocation();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showSnackbar('failed to pick image');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showSnackbar('failed to take photo');
    }
  }

  Future<void> _uploadStory() async {
    final description = _descriptionController.text.trim();

    if (description.isEmpty) {
      _showSnackbar('description cannot be empty');
      return;
    }

    if (_selectedImage == null) {
      _showSnackbar('choice image first');
      return;
    }

    try {
      final locationData = await _getCurrentLocation();
      if (locationData == null ||
          locationData.latitude == null ||
          locationData.longitude == null) {
        _showSnackbar(
          'Gagal mengambil lokasi perangkat. Pastikan izin lokasi diberikan.',
        );
        return;
      }

      // ignore: use_build_context_synchronously
      final storyProvider = context.read<StoryProvider>();
      await storyProvider.uploadStory(
        description,
        _selectedImage!,
        locationData.latitude!,
        locationData.longitude!,
      );

      _showSnackbar('Story uploaded successfully');
      if (mounted) {
        widget.onBack();
      }
    } catch (e) {
      _showSnackbar('Error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, storyProvider, _) {
        final isLoading = storyProvider.isLoadingUpload;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Story'),
            leading: isLoading
                ? null
                : IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: widget.onBack,
                  ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _selectedImage != null
                      ? Column(
                          children: [
                            Image.file(
                              _selectedImage!,
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : _pickImageFromGallery,
                              icon: const Icon(Icons.image),
                              label: const Text('Ganti Gambar'),
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
                            const Text('Pilih Gambar'),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: isLoading
                                        ? null
                                        : _pickImageFromGallery,
                                    icon: const Icon(Icons.image),
                                    label: const Text('Gallery'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: isLoading
                                        ? null
                                        : _pickImageFromCamera,
                                    icon: const Icon(Icons.camera_alt),
                                    label: const Text('Camera'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 24),
                // Description Section
                const Text(
                  'Deskripsi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  enabled: !isLoading,
                  minLines: 5,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Tulis deskripsi story Anda...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Upload Button
                ElevatedButton(
                  onPressed: isLoading ? null : _uploadStory,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text('Upload Story'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
