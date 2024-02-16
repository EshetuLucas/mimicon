import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mimicon/app/app.locator.dart';
import 'package:mimicon/app/app.logger.dart';
import 'package:mimicon/enums/image_source_type.dart';
import 'package:mimicon/enums/permission_type.dart';
import 'package:mimicon/services/permissions_service.dart';

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class MediaService {
  final log = getLogger('MediaService');
  final _permissionService = locator<PermissionsService>();

  /// Picks media (image) based on the specified [imageSourceType].
  /// Returns a [File] representing the selected media file.
  Future<File?> pickMedia({
    required ImageSourceType imageSourceType,
  }) async {
    File? pickedFile;

    // Switch based on the image source type.
    switch (imageSourceType) {
      case ImageSourceType.file:
        // Check and request media permission for file picking.
        if (await _permissionService.checkPermission(PermissionType.media)) {
          // Use FilePicker to pick an image file.
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.image,
            allowCompression: true,
          );

          // Extract the picked file from the result.
          pickedFile = result != null
              ? File(result.files.single.path!)
              : throw Exception(
                  'We could not pick the selected file. Try again!');
        }
        break;
      case ImageSourceType.camera:
        // Check and request camera permission for capturing images.
        if (await _permissionService.checkPermission(PermissionType.camera)) {
          // Use ImagePicker to pick an image from the camera.
          final result =
              await ImagePicker().pickImage(source: ImageSource.camera);
          // Get the selected file from the result.
          pickedFile = await getSelectedFile(result);
        }
        break;
      default:
        pickedFile = File('');
    }

    if (pickedFile != null) {
      final uint8List =
          await compressImage(absolutePath: pickedFile.absolute.path);

      // Write the Uint8List to the file
      await pickedFile.writeAsBytes(uint8List!);
    }
    return pickedFile;
  }

  /// Extracts a [File] from the given [result], which is obtained after picking an image.
  Future<File> getSelectedFile(var result) async {
    return result != null
        ? File(result.path)
        : throw Exception('Something went wrong');
  }

  /// Compresses a given image by 50%
  Future<Uint8List?> compressImage({required String absolutePath}) async {
    Uint8List? compressedImage;
    log.i(absolutePath);
    try {
      compressedImage = await FlutterImageCompress.compressWithFile(
        absolutePath,
        minWidth: 1000,
        minHeight: 1000,
        quality: 30,
      );
    } catch (e) {
      log.e(e);
      return null;
    }
    return compressedImage;
  }
}
