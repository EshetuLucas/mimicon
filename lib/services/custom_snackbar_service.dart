import 'package:flutter/material.dart';
import 'package:mimicon/ui/common/ui_helpers.dart';
import 'package:mimicon/ui/common/widgets/decorated_container.dart';
import '../app/app.logger.dart';
import 'package:get/get.dart' as getx;
import '../ui/common/app_colors.dart';

class CustomSnackbarService {
  final log = getLogger('CustomSnackbarService');

  Future<void> showError(
    String? message, {
    Duration? duration,
  }) async {
    basicSnackBar(
      messageText: _BasicSanckbarWidget(
        containerColor: kcRed.withOpacity(0.9),
        title: message?.tr ?? 'Something went wrong! Try again',
      ),
    );
  }

  void basicSnackBar({
    String? title,
    required Widget messageText,
  }) {
    getx.Get.snackbar(
      "",
      "",
      barBlur: 0,
      padding: EdgeInsets.zero,
      isDismissible: true,
      snackPosition: getx.SnackPosition.BOTTOM,
      backgroundColor: kcTransparent,
      duration: const Duration(seconds: 3),
      messageText: messageText,
    );
  }

  Future<void> showImageSaved(String title) async {
    basicSnackBar(
      messageText: _BasicSanckbarWidget(
        title: title.tr,
      ),
    );
  }
}

class _BasicSanckbarWidget extends StatelessWidget {
  const _BasicSanckbarWidget({
    required this.title,
    this.containerColor,
  });

  final String title;
  final Color? containerColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DecoratedContainer(
            borderColor: kcTransparent,
            containerColor: containerColor ?? kcDark.withOpacity(0.7),
            shadowColor: kcDark.withOpacity(0.6),
            shadowOpacity: 0.01,
            borderRadius: 4,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  horizontalSpaceSmall,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18, bottom: 3),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: kcWhite,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => getx.Get.closeAllSnackbars(),
                    child: const Icon(
                      Icons.close,
                      color: kcPrimaryColor,
                    ),
                  ),
                  horizontalSpaceTiny,
                ],
              ),
            ),
          ),
        ),
        verticalSpaceMedium,
      ],
    );
  }
}
