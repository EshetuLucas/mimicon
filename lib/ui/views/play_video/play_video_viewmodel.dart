import 'dart:io';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:mimicon/app/app.logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

class PlayVideoViewModel extends BaseViewModel {
  final log = getLogger('PlayVideoViewModel');
  // VideoPlayerController? _controller;
  // VideoPlayerController get controller => _controller!;
  bool get isInitialized => false;

  bool _isPlayingVideo = false;
  bool get isPlayingTheVideo => _isPlayingVideo;

  bool get showPlayButton =>
      !_isPlayingVideo ||
      !player.value.videoRenderStart && !player.value.audioRenderStart;

  late Future<void> initializeVideoPlayerFuture;

  // void initState() {
  //   // Create an instance of the VideoPlayerController and pass the URI
  //   _controller = VideoPlayerController.networkUrl(
  //     Uri.parse("https://www.dropbox.com/s/swjjl14kcamsodn/Sample_640x360.mp4"
  //         //'https://cdn-api.lucasai.io/mimecon/user.room.GOP100/mimecon.m3u8',
  //         ),
  //   );

  //   // Initialize the controller and load the video
  //   initializeVideoPlayerFuture = controller.initialize();

  //   // Play the video once it's initialized
  //   controller.play();
  //   _controller!.addListener(() {
  //     if (controller.value.isPlaying) {
  //       _isPlayingVideo = true;
  //       notifyListeners();
  //     }
  //     if (_controller!.value.duration == _controller!.value.position) {
  //       _isPlayingVideo = false;
  //       notifyListeners();
  //     }
  //   });
  // }

  // void onInit() {
  //   _controller = VideoPlayerController.networkUrl(Uri.parse(
  //       'https://cdn-api.lucasai.io/mimecon/user.room.GOP100/mimecon.m3u8'))
  //     ..initialize().then((onValue) {
  //       if (_controller!.value.duration == _controller!.value.position) {
  //         notifyListeners();
  //       }
  //       // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //       notifyListeners();
  //     });
  //   notifyListeners();

  //   _controller!.addListener(() {
  //     if (controller.value.isPlaying) {
  //       _isPlayingVideo = true;
  //       notifyListeners();
  //     }
  //     if (_controller!.value.duration == _controller!.value.position) {
  //       _isPlayingVideo = false;
  //       notifyListeners();
  //     }
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    // _controller?.dispose();
  }

  File? thumbnailFile;

  // Future<void> getThumbinail() async {
  //   final uint8list = await VideoThumbnail.thumbnailFile(
  //     video: 'https://cdn-api.lucasai.io/mimecon/user.room.GOP100/mimecon.m3u8',
  //     thumbnailPath: (await getTemporaryDirectory()).path,
  //     imageFormat: ImageFormat.WEBP,
  //     // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
  //     quality: 40,
  //   );

  //   if (uint8list != null) {
  //     thumbnailFile = File(uint8list);
  //   }
  // }

  void onPress() {
    _isPlayingVideo = true;
    notifyListeners();
    //  if (!isInitialized)

    {
      // initState();
      initVideo();
    }
    if (player.value.completed) {
      //initState();
      initVideo();

      // initializeVideoPlayerFuture
    }

    // controller.value.isPlaying ? controller.pause() : controller.play();

    notifyListeners();
  }

  FijkPlayer player = FijkPlayer();

  void initVideo() async {
    _isPlayingVideo = true;
    notifyListeners();
    player = FijkPlayer();
    player.setDataSource(
        'https://cdn-api.lucasai.io/mimecon/user.room.GOP100/mimecon.m3u8',
        autoPlay: true,
        showCover: true);
    notifyListeners();

    player.addListener(() {
      if (player.state == FijkState.completed ||
          player.state == FijkState.end) {
        _isPlayingVideo = false;
        notifyListeners();
        player.reset();
        player.release();
        notifyListeners();
      } else if (player.value.videoRenderStart &&
          player.value.audioRenderStart) {
        _isPlayingVideo = true;
        notifyListeners();
      }
    });
  }
}
