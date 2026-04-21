import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AddStoryController extends ChangeNotifier {
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  final Location location = Location();

  File? selectedImage;
  double? selectedLat;
  double? selectedLon;
  String? selectedAddress;
  LocationData? currentLocationData;

  Future<LocationData?> getCurrentLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return null;
      }
    }

    if (permissionStatus != PermissionStatus.granted) {
      return null;
    }

    return await location.getLocation();
  }

  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  void setSelectedLocation(double lat, double lon, String? address) {
    selectedLat = lat;
    selectedLon = lon;
    selectedAddress = address;
    notifyListeners();
  }

  void clearSelectedLocation() {
    selectedLat = null;
    selectedLon = null;
    selectedAddress = null;
    notifyListeners();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
