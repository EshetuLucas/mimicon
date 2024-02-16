// import 'package:flutter/material.dart';
// import 'package:stacked/stacked.dart';

// import 'play_video_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:mimicon/ui/views/play_video/play_video_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:fijkplayer/fijkplayer.dart';

class PlayVideoView extends StackedView<PlayVideoViewModel> {
  const PlayVideoView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(PlayVideoViewModel viewModel) {
    // viewModel.getThumbinail();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    PlayVideoViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Scaffold(
        body: Center(
            child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          transitionBuilder: (child, animation) {
            return SizeTransition(sizeFactor: animation, child: child);
          },
          child: viewModel.showPlayButton
              ? Image.asset('assets/svgs/flutter.jpg')
              : FijkView(
                  color: Colors.black,
                  fs: false,
                  cover: const AssetImage(
                    'assets/svgs/flutter.jpg',
                  ),
                  player: viewModel.player,
                ),
        )

            // FutureBuilder(
            //     future: viewModel.initializeVideoPlayerFuture,
            //     builder: (context, snapshot) {
            //       if (snapshot.hasError) {
            //         return Text(snapshot.error.toString());
            //       }
            //       if (snapshot.connectionState == ConnectionState.done) {
            //         // Once the video has been initialized, display the video player
            //         return AspectRatio(
            //           aspectRatio: viewModel.controller.value.aspectRatio,
            //           child: VideoPlayer(viewModel.controller),
            //         );
            //       } else {
            //         // If the video is still initializing, display a loading spinner
            //         return Center(
            //             child: Image.asset('assets/svgs/flutter.jpg')
            //             //CircularProgressIndicator(),
            //             );
            //       }
            //     },
            //   ),
            // viewModel.isInitialized
            //     ? AspectRatio(
            //         aspectRatio: viewModel.controller.value.aspectRatio,
            //         child: viewModel.controller.value.isBuffering
            //             ? const Text('Loading..')
            //             : VideoPlayer(
            //                 viewModel.controller,
            //               ),
            //       )
            //     : Container(),
            ),
        floatingActionButton: !viewModel.isPlayingTheVideo
            ? FloatingActionButton(
                onPressed: viewModel.onPress,
                child: viewModel.isInitialized
                    ? Icon(
                        viewModel.player.value.videoRenderStart
                            ? Icons.pause
                            : viewModel.player.value.completed
                                ? Icons.play_arrow
                                : Icons.play_arrow,
                      )
                    : const Icon(
                        Icons.play_arrow,
                      ))
            : const SizedBox.shrink(),
      ),
    );
  }

  @override
  PlayVideoViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PlayVideoViewModel();
}

// class VideoPlayerScreen extends StatefulWidget {
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late IjkMediaController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = IjkMediaController();
//     controller.setNetworkDataSource(
//       'YOUR_HLS_VIDEO_URL',
//       autoPlay: true,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         height: 300,
//         child: IjkPlayer(
//           mediaController: controller,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }
// }

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final FijkPlayer player = FijkPlayer();

  _VideoScreenState();

  @override
  void initState() {
    super.initState();
    player.setDataSource(
        'https://cdn-api.lucasai.io/mimecon/user.room.GOP100/mimecon.m3u8',
        autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Fijkplayer Example")),
        body: Container(
          alignment: Alignment.center,
          child: FijkView(
            player: player,
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}
