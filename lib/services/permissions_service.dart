import 'dart:io';
import 'package:mimicon/app/app.dialogs.dart';
import 'package:mimicon/app/app.locator.dart';
import 'package:mimicon/app/app.logger.dart';
import 'package:mimicon/enums/permission_type.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionsService {
  final log = getLogger('PermissionsService');
  final _dialogService = locator<DialogService>();

  bool isIOS = true;

  // Check and request permission based on the given `permissionType`
  Future<bool> checkPermission(PermissionType permissionType) async {
    isIOS = Platform.isIOS;

    log.i('permissionType: $permissionType');

    PermissionStatus permissionStatus =
        await getPermissionStatus(permissionType);

    if (permissionStatus == PermissionStatus.denied) {
      await showPermissionDialog();
      return false;
    } else if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else if (permissionStatus == PermissionStatus.limited) {
      return true;
    } else {
      await showPermissionDialog();
      return false;
    }
  }

  // Check if the app has permission based on the given `permissionType`
  Future<bool> hasPermission(PermissionType permissionType) async {
    isIOS = Platform.isIOS;

    log.i('permissionType: $permissionType');

    switch (permissionType) {
      case PermissionType.contacts:
        final status = await Permission.contacts.status;
        if (status == PermissionStatus.denied) {
          return false;
        }
        break;

      case PermissionType.camera:
        final status = await Permission.camera.status;
        if (status == PermissionStatus.denied) {
          return false;
        }
        break;

      default:
        return true;
    }
    return true;
  }

  // Get the permission status based on the given `permissionType`
  Future<PermissionStatus> getPermissionStatus(
      PermissionType permissionType) async {
    DeviceInfoPlugin? deviceInfo = !isIOS ? DeviceInfoPlugin() : null;
    AndroidDeviceInfo? androidInfo =
        !isIOS ? await deviceInfo?.androidInfo : null;
    log.i('permissionType: $permissionType');
    switch (permissionType) {
      case PermissionType.pushNotification:
        if (isIOS) {
          return await Permission.notification.request();
        } else if (androidInfo!.version.sdkInt >= 33) {
          return await Permission.notification.request();
        } else {
          return PermissionStatus.granted;
        }
      case PermissionType.camera:
        return await Permission.camera.request();
      case PermissionType.contacts:
        return await Permission.contacts.request();
      case PermissionType.media:
        if (isIOS) {
          return await Permission.photos.request();
        } else {
          if (androidInfo!.version.sdkInt >= 33) {
            return await Permission.photos.request();
          } else {
            return await Permission.storage.request();
          }
        }
      default:
        return PermissionStatus.granted;
    }
  }

  /// Displays a custom dialog to guide the user to open app settings for a specific permission.
  Future<void> showPermissionDialog() async {
    // Show a custom dialog prompting the user to open app settings.
    final result = await _dialogService.showCustomDialog(
        variant: DialogType.openSetting,
        mainButtonTitle: 'Open Settings',
        description:
            "To use this feature, please go to your settings for this app and enable this permission.");

    // If the user confirms (presses 'Open Settings'), open app settings.
    if (result?.confirmed ?? false) {
      await openAppSettings();
    } else {
      // If the user cancels, log a message indicating no action is taken.
      log.v('User taps Okay, we do nothing');
    }
  }
}
