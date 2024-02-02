import 'package:mimicon/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OpenSettingDialogModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  void onClosePressed() {
    _navigationService.back();
  }
}
