import 'package:mimicon/app/app.locator.dart';
import 'package:mimicon/ui/views/camera/home_view.dart';
import 'package:mimicon/ui/views/play_video/play_video_view.dart';
import 'package:mimicon/ui/views/speech_to_text/speech_to_text_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OptionsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void onHLS() {
    _navigationService.navigateToView(const PlayVideoView());
  }

  void onSTT() {
    _navigationService.navigateToView(const SpeechToTextView());
  }

  void onFaceDetection() {
    _navigationService.navigateToView(CameraView());
  }
}
