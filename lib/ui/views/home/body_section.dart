part of 'home_view.dart';

class BodySection extends ViewModelWidget<HomeViewModel> {
  const BodySection({
    super.key,
    required this.imageKey,
  });

  final GlobalKey<State<StatefulWidget>> imageKey;

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Expanded(
        child: viewModel.hasSelectedFile
            ? RepaintBoundary(
                key: imageKey,
                child: Stack(
                  children: [
                    const ImageWidget(),
                    if (viewModel.drawCircle)
                      for (String key
                          in viewModel.ovalGreenContainers.keys.toList())
                        Positioned(
                          left:
                              viewModel.ovalGreenContainers[key]!.containerLeft,
                          top: viewModel.ovalGreenContainers[key]!.containerTop,
                          child: GestureDetector(
                            onDoubleTap: () =>
                                viewModel.onDoubleTapGreenArea(key),
                            onPanUpdate: (details) {
                              viewModel.updateContainer(
                                  details: details, containerKey: key);
                            },
                            child: GreenOvalContainer(
                              key: Key(key),
                              height:
                                  viewModel.ovalGreenContainers[key]!.height,
                              width: viewModel.ovalGreenContainers[key]!.width,
                            ),
                          ),
                        )
                  ],
                ),
              )
            : CameraWidget(
                viewModel: viewModel,
              ));
  }
}

class GreenOvalContainer extends StatelessWidget {
  const GreenOvalContainer({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      height: height,
      width: width,
      margin: const EdgeInsets.only(top: 40, left: 40, right: 40),
      decoration: BoxDecoration(
        color: kcGreen.withOpacity(0.7),
        borderRadius: const BorderRadius.all(Radius.elliptical(100, 50)),
      ),
    );
  }
}

class CameraWidget extends StatefulWidget {
  const CameraWidget({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = widget.viewModel.controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      widget.viewModel.disposeCameraController();
    } else if (state == AppLifecycleState.resumed) {
      widget.viewModel
          .initializeCameraController(widget.viewModel.controller.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: widget.viewModel.initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview
          return CameraPreview(widget.viewModel.controller);
        } else {
          // Otherwise, display a loading indicator
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ImageWidget extends ViewModelWidget<HomeViewModel> {
  const ImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Stack(
      children: [
        if (viewModel.selectedFile != null)
          Image.file(File(viewModel.selectedFile!.path),
              fit: BoxFit.contain,
              height: screenHeight(context) - 300,
              width: screenWidth(context),
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (frame == null) {
              viewModel.setHasimage(true);

              return Container(
                alignment: Alignment.center,
                child: Shimmer.fromColors(
                  baseColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.99),
                  highlightColor: Theme.of(context).colorScheme.tertiary,
                  child: const SvgBuilder(
                    svg: gallerySvg,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  enabled: true,
                ),
              );
            } else {
              return child;
            }
          }),
        if (viewModel.selectedFile != null)
          CustomPaint(
            painter: FacePainterFirebase(viewModel.faces),
          ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return SizeTransition(sizeFactor: animation, child: child);
          },
          child: viewModel.hasMultiFace
              ? Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 69,
                    width: 240,
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kcDark.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: const Text('2개 이상의 얼굴이 감지되었어요!'),
                  ),
                )
              : null,
        )
      ],
    );
  }
}

class FacePainterFirebase extends CustomPainter {
  final List<Face> faces;

  FacePainterFirebase(this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.blue;

    final Face face = faces[0];

    canvas.drawCircle(
      Offset(face.landmarks[FaceLandmarkType.rightEye]!.position.x.toDouble(),
          face.landmarks[FaceLandmarkType.rightEye]!.position.y.toDouble()),
      5.0,
      paint,
    );

    canvas.drawCircle(
      Offset(
        face.landmarks[FaceLandmarkType.leftEye]!.position.x.toDouble(),
        face.landmarks[FaceLandmarkType.leftEye]!.position.y.toDouble(),
      ),
      5.0,
      paint,
    );
    canvas.drawCircle(
      Offset(
        face.landmarks[FaceLandmarkType.noseBase]!.position.x.toDouble(),
        face.landmarks[FaceLandmarkType.noseBase]!.position.y.toDouble(),
      ),
      5.0,
      paint,
    );
    canvas.drawCircle(
      Offset(
        face.landmarks[FaceLandmarkType.bottomMouth]!.position.x.toDouble(),
        face.landmarks[FaceLandmarkType.bottomMouth]!.position.y.toDouble(),
      ),
      5.0,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
