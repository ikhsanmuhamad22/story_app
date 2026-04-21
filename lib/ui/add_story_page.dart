import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/controllers/add_story_controller.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/ui/pick_location_page.dart';
import 'package:story_app/widgets/image_picker_section.dart';
import 'package:story_app/widgets/location_section.dart';

class AddStoryPage extends StatefulWidget {
  final VoidCallback onBack;

  const AddStoryPage({super.key, required this.onBack});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  late final AddStoryController controller;

  @override
  void initState() {
    super.initState();
    controller = AddStoryController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _openLocationPicker() async {
    final currentLoc = await controller.getCurrentLocation();
    if (currentLoc != null && mounted) {
      // Navigate to pick location page
      final result = await Navigator.of(context).push<Map<String, dynamic>>(
        MaterialPageRoute(
          builder: (context) => PickLocationPage(
            initialLat: currentLoc.latitude,
            initialLon: currentLoc.longitude,
          ),
        ),
      );

      if (result != null && mounted) {
        controller.setSelectedLocation(
          result['latitude'] as double,
          result['longitude'] as double,
          result['address'] as String?,
        );
      }
    } else {
      if (mounted) {
        _showSnackbar(
          'Failed to get current location. Please select location manually.',
        );
      }
    }
  }

  Future<void> _uploadStory() async {
    final description = controller.descriptionController.text.trim();

    if (description.isEmpty) {
      _showSnackbar('description cannot be empty');
      return;
    }

    if (controller.selectedImage == null) {
      _showSnackbar('choice image first');
      return;
    }

    try {
      double latitude;
      double longitude;

      if (controller.selectedLat != null && controller.selectedLon != null) {
        latitude = controller.selectedLat!;
        longitude = controller.selectedLon!;
      } else {
        final locationData = await controller.getCurrentLocation();
        if (locationData == null ||
            locationData.latitude == null ||
            locationData.longitude == null) {
          _showSnackbar('Failed to get current location.');
          return;
        }
        latitude = locationData.latitude!;
        longitude = locationData.longitude!;
      }

      // ignore: use_build_context_synchronously
      final storyProvider = context.read<StoryProvider>();
      await storyProvider.uploadStory(
        description,
        controller.selectedImage!,
        latitude,
        longitude,
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
                ImagePickerSection(
                  selectedImage: controller.selectedImage,
                  isLoading: isLoading,
                  onPickFromGallery: controller.pickImageFromGallery,
                  onPickFromCamera: controller.pickImageFromCamera,
                ),
                const SizedBox(height: 24),
                // Description Section
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.descriptionController,
                  enabled: !isLoading,
                  minLines: 5,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'write your story here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) => LocationSection(
                    selectedAddress: controller.selectedAddress,
                    selectedLat: controller.selectedLat,
                    selectedLon: controller.selectedLon,
                    isLoading: isLoading,
                    onPickLocation: _openLocationPicker,
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
