import 'package:flutter/material.dart';

import 'package:mimicon/ui/common/ui_helpers.dart';
import 'package:mimicon/ui/common/widgets/app_button.dart';
import 'package:mimicon/ui/dialogs/basic_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:get/get.dart';
import 'open_setting_dialog_model.dart';

const double _graphicSize = 60;

class OpenSettingDialog extends StackedView<OpenSettingDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const OpenSettingDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    OpenSettingDialogModel viewModel,
    Widget? child,
  ) {
    return BasicDialog(
      onCloseTap: viewModel.onClosePressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.title ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (request.description != null) ...[
                        verticalSpaceSmall,
                        Text(
                          request.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          maxLines: 3,
                          softWrap: true,
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  width: _graphicSize,
                  height: _graphicSize,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6E7B0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(_graphicSize / 2),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🔒', style: TextStyle(fontSize: 30)),
                )
              ],
            ),
            verticalSpaceMedium,
            AppButton(
              title: 'Open Settings'.tr,
              onTap: () => completer(DialogResponse(confirmed: true)),
            )
          ],
        ),
      ),
    );
  }

  @override
  OpenSettingDialogModel viewModelBuilder(BuildContext context) =>
      OpenSettingDialogModel();
}
