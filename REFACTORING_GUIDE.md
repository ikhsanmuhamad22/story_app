# Refactoring Guide: Memisahkan Kode Besar Menjadi File Kecil

## Masalah

File-file UI seperti `pick_location_page.dart`, `add_story_page.dart`, dan `maps_page.dart` terlalu besar dan sulit di-maintain.

## Solusi: Controller Pattern + Widget Separation

### Struktur Baru

```
lib/
├── controllers/           # Business logic terpisah
│   ├── add_story_controller.dart
│   ├── maps_page_controller.dart
│   └── pick_location_controller.dart
├── widgets/              # UI components reusable
│   ├── address_bottom_sheet.dart
│   ├── image_picker_section.dart
│   ├── location_bottom_sheet.dart
│   ├── location_section.dart
│   └── map_type_selector.dart
└── ui/                   # Main pages (tetap ada)
    ├── add_story_page.dart
    ├── maps_page.dart
    └── pick_location_page.dart
```

### Cara Migrasi (Tanpa Mengubah Kode Yang Sudah Ada)

#### 1. Pick Location Page

**Sebelum:**

```dart
class _PickLocationPageState extends State<PickLocationPage> {
  // Semua logic dan state ada di sini
  late GoogleMapController mapController;
  late LatLng selectedLocation;
  // ... banyak kode
}
```

**Sesudah (Opsional - bisa dilakukan bertahap):**

```dart
class _PickLocationPageState extends State<PickLocationPage> {
  late final PickLocationController controller;

  @override
  void initState() {
    super.initState();
    controller = PickLocationController();
    controller.initialize(widget.initialLat, widget.initialLon);
  }

  // UI tetap sama, tapi logic dipindah ke controller
}
```

#### 2. Add Story Page

**Sebelum:**

```dart
class _AddStoryPageState extends State<AddStoryPage> {
  final _descriptionController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  // ... banyak state dan methods
}
```

**Sesudah (Opsional):**

```dart
class _AddStoryPageState extends State<AddStoryPage> {
  late final AddStoryController controller;

  @override
  void initState() {
    super.initState();
    controller = AddStoryController();
  }

  // Gunakan controller untuk logic
  // UI components bisa diganti dengan widget terpisah
}
```

### Keuntungan

1. **Separation of Concerns**: Logic terpisah dari UI
2. **Reusable Components**: Widget bisa digunakan ulang
3. **Easier Testing**: Logic bisa di-test terpisah
4. **Better Maintainability**: File lebih kecil dan focused
5. **Team Collaboration**: Bisa kerja paralel pada logic dan UI

### Migrasi Bertahap

1. **Langkah 1**: Buat controller classes (sudah dibuat)
2. **Langkah 2**: Buat widget components (sudah dibuat)
3. **Langkah 3**: Ganti bagian demi bagian di page utama
4. **Langkah 4**: Test setiap perubahan

### Contoh Penggunaan Widget Terpisah

```dart
// Sebelum
Container(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      // 50+ lines of image picker code
    ],
  ),
)

// Sesudah
ImagePickerSection(
  selectedImage: controller.selectedImage,
  isLoading: isLoading,
  onPickFromGallery: controller.pickImageFromGallery,
  onPickFromCamera: controller.pickImageFromCamera,
)
```

### Tips

1. **Mulai dari yang kecil**: Ganti satu section dulu
2. **Test setiap perubahan**: Pastikan fungsionalitas tetap sama
3. **Gunakan ChangeNotifier**: Untuk state management antar controller
4. **Buat interface**: Jika perlu komunikasi antar controllers

### File yang Sudah Dibuat

- ✅ `controllers/pick_location_controller.dart`
- ✅ `controllers/add_story_controller.dart`
- ✅ `controllers/maps_page_controller.dart`
- ✅ `widgets/location_bottom_sheet.dart`
- ✅ `widgets/image_picker_section.dart`
- ✅ `widgets/location_section.dart`
- ✅ `widgets/address_bottom_sheet.dart`
- ✅ `widgets/map_type_selector.dart`

### Langkah Selanjutnya

1. Import controller di page yang bersangkutan
2. Ganti state variables dengan controller properties
3. Ganti methods dengan controller methods
4. Ganti UI sections dengan widget components
5. Test dan pastikan semuanya berfungsi

Dengan cara ini, kode Anda tetap berfungsi tapi lebih terorganisir dan maintainable! 🚀
