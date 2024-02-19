import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui_1;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:mimicon/app/app.locator.dart';
import 'package:mimicon/enums/container_shape_type.dart';
import 'package:mimicon/enums/image_source_type.dart';
import 'package:mimicon/mixins/media_mixin.dart';
import 'package:mimicon/services/custom_snackbar_service.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/services.dart' show ByteData, rootBundle;

class HomeViewModel extends BaseViewModel with MediaMixin {
  final GlobalKey imageKey;
  HomeViewModel(this.imageKey);
  // Service for displaying snackbars
  final _snackBarService = locator<CustomSnackbarService>();

  // Check if there is at least one green oval container to save
  bool get canSaveAnImage => ovalGreenContainers.isNotEmpty;

  // Map to store green oval containers with their unique keys
  Map<String, ContainerValue> ovalGreenContainers = {};

  // Angle for camera change icon
  double _cameraChangeIconTurns = 0;
  double get cameraChangeIconTurns => _cameraChangeIconTurns;

  // Number of faces detected
  int _numberOfFaces = 0;
  bool get hasMultiFace => _numberOfFaces > 1;

// Check if there is any selected file
  bool get hasSelectedFile => selectedFile != null;

  // Flag to track if face detection is in progress
  bool _isDetectingFace = false;
  bool get isDetectingFace => _isDetectingFace;

  List<Face> faces = [];
  bool get drawCircle => faces.isNotEmpty;

  bool hasImage = false;
  void setHasimage(bool value) async {
    hasImage = value;
    if (hasImage) {
      hasImage = false;
      await detectFaces();
    }
  }

  Size? imageSize;

  /// Detect faces in the selected image and store the number of detected faces
  /// in [_numberOfFaces] value;
  Future<void> detectFaces() async {
    // _isDetectingFace = true; // Set face detection flag to true
    // notifyListeners(); // Notify listeners to update UI
    if (hasSelectedFile) {
      try {
        faces.clear();
        //  notifyListeners();
        // Configure options for face detection
        final options = FaceDetectorOptions(
            enableLandmarks: true, enableContours: true, enableTracking: true);
        final faceDetector = FaceDetector(options: options);
        // image = (await fileToImage(selectedFile!));
        // Load the selected image for processing
        await Future.delayed(const Duration(seconds: 1));
        final file = await capturePng(
            fileName: 'mimicon' + DateTime.now().toString(), qrKey: imageKey);
        final inputImage = InputImage.fromFilePath(file.path);

        imageSize = await getImageSize(file.path);
        log.e(imageSize);

        // Process the image and get the list of detected faces
        faces = await faceDetector.processImage(inputImage);
        log.e('faces.first.landmarks');
        log.e(faces.first.landmarks.entries.first.toString());

        // Update the number of detected faces
        _numberOfFaces = faces.length;
        notifyListeners();
      } catch (e) {
        // Log an error message if face detection fails
        log.e('Unable to detect faces');
      } finally {
        _isDetectingFace = false; // Set face detection flag to false
        notifyListeners();
      }
    }
  }

  /// Remove the green oval container when the user double taps the green oval container
  void onDoubleTapGreenArea(String key) {
    ovalGreenContainers.remove(key);
    notifyListeners();
  }

  /// Pick an image based on the given image source and perform face detection
  Future<void> pickImage(ImageSourceType imageSource) async {
    if (imageSource == ImageSourceType.camera) {
      await fromCamera();
    } else {
      await fromFile();
    }
    // Perform face detection on the selected image
    //await detectFaces();
  }

  /// Toggle the camera when the user changes the image to the front or back
  void onChangeCamera() {
    // Toggle the camera change icon
    _cameraChangeIconTurns = _cameraChangeIconTurns == 0 ? 0.5 : 0;
    notifyListeners();
    toggleCamera();
  }

  /// Reset all values to default when the user taps on the go back button
  void onBack() {
    _numberOfFaces = 0;
    _isDetectingFace = false;
    ovalGreenContainers.clear();
    notifyListeners();
    // Reset the camera to its default state
    resetCamera();
  }

  /// Handle the tap event on the Android device's back button
  /// If a media file is selected, go back to the default state by calling onBack()
  /// Otherwise, move the application task to the background using MoveToBackground.moveTaskToBack()
  void onAndroidBackButtonTap() {
    if (hasSelectedFile) {
      onBack();
      return;
    }
    MoveToBackground.moveTaskToBack();
  }

  /// Add an oval green container based on the given container type
  void onAddOvalContainer(ContainerShapeType containerType) {
    String key = DateTime.now().toString();
    // Create and add a new green oval container to the map
    ovalGreenContainers[key] = containerType == ContainerShapeType.small
        ? ContainerValue()
        : ContainerValue(
            height: 30,
            width: 60,
            containerLeft: 50,
            containerTop: 50,
          );
    notifyListeners();
  }

  /// Update the position of the green oval container when the user moves it
  void updateContainer(
      {required DragUpdateDetails details, required String containerKey}) {
    ContainerValue containerValue = ovalGreenContainers[containerKey]!;

    double containerLeft = containerValue.containerLeft;
    double containerTop = containerValue.containerTop;
    containerLeft += details.delta.dx;
    containerTop += details.delta.dy;

    // Update the position of the green oval container in the map
    ovalGreenContainers[containerKey] = ContainerValue(
      containerLeft: containerLeft,
      containerTop: containerTop,
      height: containerValue.height,
      width: containerValue.width,
    );
    notifyListeners();
  }

  // Capture PNG from the Canvas and change it into a file, then return the file

  Future<File> capturePng({
    required String fileName,
    required GlobalKey qrKey,
  }) async {
    try {
      // Find the RenderRepaintBoundary in the current context
      RenderRepaintBoundary? boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;

      // Capture the image from the boundary with a specified pixel ratio
      final image = await boundary!.toImage(pixelRatio: 1);

      // Convert the captured image to ByteData in PNG format
      ByteData? byteData =
          await image.toByteData(format: ui_1.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Get the application documents directory
      Directory directory = await getApplicationDocumentsDirectory();

      // Create a new directory for storing PNG images if it doesn't exist
      Directory newDirectory = Directory('${directory.path}/BnBit');
      if (!newDirectory.existsSync()) newDirectory.createSync();

      // Create a new file with a unique filename in the directory
      File file = await File('${newDirectory.path}/$fileName.png').create();

      // Write the PNG bytes to the file
      return await file.writeAsBytes(pngBytes);
    } catch (e) {
      // Log an error and rethrow the exception if an error occurs
      log.e('Unable to capture image: $e');
      rethrow;
    }
  }

  /// Save the edited image to the gallery
  void onSave(GlobalKey imageKey) async {
    setBusy(true); // Set the ViewModel to a busy state
    final file = await capturePng(
        fileName: 'mimicon' + DateTime.now().toString(), qrKey: imageKey);
    try {
      // Save the image to the gallery
      await GallerySaver.saveImage(file.path);
      // Show a success message
      _snackBarService.showImageSaved('Image saved to gallery');
    } catch (e) {
      // Log an error message
      log.e('Unable to download image $e');
      // Show an error message
      _snackBarService.showError('try_again');
    } finally {
      // Set the ViewModel back to a non-busy state
      setBusy(false);
    }
  }

  ui_1.Image? image;

  Future<ui_1.Image> fileToImage(File file) async {
    try {
      var bytes = await file.readAsBytes();
      image = await decodeImageFromList(bytes.buffer.asUint8List());
    } catch (e) {
      log.e(e.toString());
    }

    return image!;
    // final bytes = await file.readAsBytes();
    // return imageFromBytes(bytes);
  }

  static Future<ui_1.Image> assetToImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    return imageFromBytes(bytes);
  }

  static Future<ui_1.Image> imageFromBytes(Uint8List bytes) async {
    final Completer<ui_1.Image> completer = Completer();
    ui_1.decodeImageFromList(bytes, (ui_1.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<Size> getImageSize(String imagePath) async {
    final File imageFile = File(imagePath);
    final Uint8List imageData = await imageFile.readAsBytes();
    final ui_1.Codec codec = await ui_1.instantiateImageCodec(imageData);
    final ui_1.FrameInfo frameInfo = await codec.getNextFrame();
    return Size(
        frameInfo.image.width.toDouble(), frameInfo.image.height.toDouble());
  }
}

// Class representing the values of a green oval container
class ContainerValue {
  final double containerLeft;
  final double containerTop;
  final double height;
  final double width;
  ContainerValue({
    this.containerLeft = 50,
    this.containerTop = 50,
    this.height = 20,
    this.width = 40,
  });
}
