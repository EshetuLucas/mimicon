import 'package:mimicon/services/custom_snackbar_service.dart';
import 'package:mimicon/services/media_service.dart';
import 'package:mimicon/services/permissions_service.dart';
import 'package:mimicon/ui/views/home/home_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mimicon/ui/dialogs/open_setting/open_setting_dialog.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: PermissionsService),
    LazySingleton(classType: MediaService),
    LazySingleton(classType: CustomSnackbarService),

    // @stacked-service
  ],
  dialogs: [
    StackedDialog(classType: OpenSettingDialog),
// @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
