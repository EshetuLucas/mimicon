// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/open_setting/open_setting_dialog.dart';

enum DialogType {
  openSetting,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.openSetting: (context, request, completer) =>
        OpenSettingDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
