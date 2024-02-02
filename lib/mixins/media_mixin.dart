import 'dart:io';

import 'package:camera/camera.dart';
import 'package:mimicon/app/app.locator.dart';
import 'package:mimicon/app/app.logger.dart';
import 'package:mimicon/enums/image_source_type.dart';
import 'package:mimicon/enums/permission_type.dart';
import 'package:mimicon/services/media_service.dart';
import 'package:mimicon/services/permissions_service.dart';
import 'package:stacked/stacked.dart';

mixin MediaMixin on BaseViewModel {
  final log = getLogger('MediaMixin');
  // MediaService for handling media operations
  final _mediaService = locator<MediaService>();
  final _permissionService = locator<PermissionsService>();

// Flag to track whether the back camera is currently selected
  bool _isBackCamera = true;
  bool get isBackCamera => _isBackCamera;

  // Camera descriptions for the back and front cameras
  CameraDescription backCamera = const CameraDescription(
      name: '0',
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 90);
  CameraDescription frontCamera = const CameraDescription(
      name: '1',
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 270);
// Currently selected media file
  File? _selectedFile;
  File? get selectedFile => _selectedFile;

  late CameraController controller;
  late Future<void> initializeControllerFuture;
  // List of available camera descriptions

  List<CameraDescription> cameras = [];

  // Initialize the camera controller and set the default camera to the back camera
  void onInit() {
    initializeCameraController(backCamera);
    notifyListeners(); // Notify listeners to update UI
  }

  // Toggle between the back and front cameras
  void toggleCamera() async {
    _isBackCamera = !_isBackCamera;
    notifyListeners();

    await onNewCameraSelected(_isBackCamera ? backCamera : frontCamera);
  }

  // Initialize the camera controller with the specified camera description
  void initializeCameraController(CameraDescription cameraDescription) {
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    initializeControllerFuture = controller.initialize();
    notifyListeners();
  }

  // Switch to a new camera based on the provided camera description
  Future<void> onNewCameraSelected(
    CameraDescription cameraDescription,
  ) async {
    log.e(cameraDescription); // Log the selected camera description
    return controller.setDescription(cameraDescription);
  }

  // Reset the camera to its default state and clear the selected media file
  void resetCamera() {
    clearSelectedFile();
    onInit();
  }

  void disposeCameraController() {
    controller.dispose();
  }

  // Clear the selected media file
  void clearSelectedFile() {
    _selectedFile = null;
    notifyListeners();
  }

  // Capture a photo using the camera
  Future<void> fromCamera() async {
    try {
      if (await _permissionService.checkPermission(PermissionType.camera)) {
        await initializeControllerFuture;
        final file = await controller.takePicture();
        _selectedFile = File(file.path);
        notifyListeners();
        disposeCameraController();
      }
    } catch (e) {
      log.e('Unable to take a picture');
      rethrow;
    }
  }

  // Pick a photo from the device's gallery
  Future<void> fromFile() async {
    try {
      final tempFile = await _mediaService.pickMedia(
        imageSourceType: ImageSourceType.file,
      );

      if (tempFile != null) {
        _selectedFile = tempFile;
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
