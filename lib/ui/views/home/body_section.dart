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
                    // Positioned(
                    //   left: -36,
                    //   top: -100,
                    //   child: CustomPaint(
                    //     painter: FacePainter(viewModel.faces),
                    //   ),
                    // ),
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
          CustomPaint(
            painter: _LandmarkPainter(
              faces: viewModel.faces,
              displayLandmarks: true,
              width: viewModel.controller.value.previewSize!.width,
            ),

            // MyPainter(
            //   viewModel.image!,
            //   screenWidth(context),
            //   screenHeight(context) - 300,
            //   Paint(),
            // ),

            //  ImagePainter(
            //   image: viewModel.image!,
            // ),
            //size: Size(double.infinity, double.infinity),
          ),

        if (viewModel.selectedFile != null)
          CustomPaint(
            painter: FacePainter(viewModel.faces, viewModel.isFromCamera),
            size: Size(
              screenWidth(context),
              screenHeight(context),
            ),
          ),

        // _LandmarkPainter(
        //   faces: viewModel.faces,
        //   displayLandmarks: true,
        //   width: viewModel.controller.value.previewSize!.width,
        // ),

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

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final bool isFromCamera;

  FacePainter(this.faces, this.isFromCamera);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    for (final face in faces) {
      final noseLandmark = face.landmarks[FaceLandmarkType.noseBase];
      final leftEyeLandmark = face.landmarks[FaceLandmarkType.leftEye];
      final rightEyeLandmark = face.landmarks[FaceLandmarkType.rightEye];
      final mouthLandmark = face.landmarks[FaceLandmarkType.bottomMouth];

      _drawCircle(canvas, paint, noseLandmark);
      _drawCircle(canvas, paint, leftEyeLandmark);
      _drawCircle(canvas, paint, rightEyeLandmark);
      _drawCircle(canvas, paint, mouthLandmark);
    }
  }

  void _drawCircle(Canvas canvas, Paint paint, FaceLandmark? landmark) {
    if (landmark != null) {
      canvas.drawCircle(
        Offset(landmark.position.x.toDouble() - (!isFromCamera ? 110 : 0),
            landmark.position.y.toDouble() - (!isFromCamera ? 50 : 0)),
        8.0,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _LandmarkPainter extends CustomPainter {
  final List<Face> faces;
  final bool displayLandmarks;
  final double width;

  const _LandmarkPainter({
    required this.faces,
    required this.displayLandmarks,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!displayLandmarks) return;

    // Calculate canvas scaling factor for efficient drawing
    final scale = size.width / width;

    for (final face in faces) {
      // Access desired landmarks (potentially with type checking)
      final noseLandmark = face.landmarks[FaceLandmarkType.noseBase];
      final leftEyeLandmark = face.landmarks[FaceLandmarkType.leftEye];
      final rightEyeLandmark = face.landmarks[FaceLandmarkType.rightEye];
      final mouthLandmark = face.landmarks[FaceLandmarkType.bottomMouth];

      // Draw circles using efficient calculations and scaling
      if (noseLandmark != null) {
        final center = Offset(
          noseLandmark.position.x * scale,
          noseLandmark.position.y * scale,
        );
        final radius = 10.0 * scale; // Adjust radius as needed
        _drawCircle(canvas, center, radius);
      }
      // Similarly for other landmarks
    }
  }

  void _drawCircle(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0; // Adjust stroke width as needed
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_LandmarkPainter oldDelegate) =>
      oldDelegate.faces != faces;
}

// class FacePainter extends CustomPainter {
//   final List<Face> faces;
//   final bool displayLandmarks;
//   final double width;

//   const FacePainter({
//     required this.faces,
//     required this.displayLandmarks,
//     required this.width,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (!displayLandmarks) return;

//     // Calculate canvas scaling factor for efficient drawing
//     final scale = size.width / width;

//     for (final face in faces) {
//       // Access desired landmarks (potentially with type checking)
//       final noseLandmark = face.landmarks[FaceLandmarkType.noseBase];
//       final leftEyeLandmark = face.landmarks[FaceLandmarkType.leftEye];
//       final rightEyeLandmark = face.landmarks[FaceLandmarkType.rightEye];
//       final mouthLandmark = face.landmarks[FaceLandmarkType.bottomMouth];

//       // Draw circles using efficient calculations and scaling
//       if (noseLandmark != null) {
//         final center = Offset(
//           noseLandmark.position.x * scale,
//           noseLandmark.position.y * scale,
//         );
//         final radius = 10.0 * scale; // Adjust radius as needed
//         _drawCircle(canvas, center, radius);
//       }
//       // Similarly for other landmarks
//     }
//   }

//   void _drawCircle(Canvas canvas, Offset center, double radius) {
//     final paint = Paint()
//       ..color = Colors.red
//       ..strokeWidth = 2.0 * 10; // Adjust stroke width as needed
//     canvas.drawCircle(center, radius, paint);
//   }

//   @override
//   bool shouldRepaint(_LandmarkPainter oldDelegate) =>
//       oldDelegate.faces != faces;
// }

class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class FaceLandmarkPainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;

  FaceLandmarkPainter({required this.image, required this.faces});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final scale = size.width / image.width;

    for (var face in faces) {
      final noseLandmark = face.landmarks[FaceLandmarkType.noseBase];
      final leftEyeLandmark = face.landmarks[FaceLandmarkType.leftEye];
      final rightEyeLandmark = face.landmarks[FaceLandmarkType.rightEye];
      final mouthLandmark = face.landmarks[FaceLandmarkType.bottomMouth];

      _drawCircle(canvas, paint, noseLandmark, scale);
      _drawCircle(canvas, paint, leftEyeLandmark, scale);
      _drawCircle(canvas, paint, rightEyeLandmark, scale);
      _drawCircle(canvas, paint, mouthLandmark, scale);

      // _drawCircle(canvas, landmarks.leftEyePosition, scale, paint, scale);
      // _drawCircle(canvas, landmarks.rightEyePosition, scale, paint);
      // _drawCircle(canvas, landmarks.noseBasePosition, scale, paint);
      // _drawCircle(canvas, landmarks.mouthLeftPosition, scale, paint);
      // _drawCircle(canvas, landmarks.mouthRightPosition, scale, paint);
    }
  }

  void _drawCircle(Canvas canvas, Paint paint, FaceLandmark? landmark, scale) {
    if (landmark != null) {
      final adjustedPosition = Offset(
              landmark.position.x.toDouble(), landmark.position.y.toDouble()) *
          scale;
      canvas.drawCircle(adjustedPosition, 6.0, paint);
      // canvas.drawCircle(
      //   Offset(landmark.position.x.toDouble(), landmark.position.y.toDouble()),
      //   10.0,
      //   paint,
      // );
    }
  }

  // void _drawCircle(Canvas canvas, Offset? position, double scale, Paint paint) {
  //   if (position != null) {
  //     final adjustedPosition = position * scale;
  //     canvas.drawCircle(adjustedPosition, 6.0, paint);
  //   }
  // }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyPainter extends CustomPainter {
  final ui.Image image;
  final double scaledWidth;
  final double scaledHeight;
  final Paint painter;

  MyPainter(this.image, this.scaledWidth, this.scaledHeight, this.painter);

  @override
  void paint(Canvas canvas, Size size) {
    // Paint the image onto the canvas using the provided parameters
    canvas.drawImageRect(
      image,
      Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, scaledWidth, scaledHeight),
      painter,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SpeechSampleApp extends StatefulWidget {
  const SpeechSampleApp({Key? key}) : super(key: key);

  @override
  State<SpeechSampleApp> createState() => _SpeechSampleAppState();
}

/// An example that demonstrates the basic functionality of the
/// SpeechToText plugin for using the speech recognition capability
/// of the underlying platform.
class _SpeechSampleAppState extends State<SpeechSampleApp> {
  bool _hasSpeech = false;
  bool _logEvents = false;
  bool _onDevice = false;
  final TextEditingController _pauseForController =
      TextEditingController(text: '3');
  final TextEditingController _listenForController =
      TextEditingController(text: '30');
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
  }

  /// This initializes SpeechToText. That only has to be done
  /// once per application, though calling it again is harmless
  /// it also does nothing. The UX of the sample app ensures that
  /// it can only be called once.
  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: _logEvents,
      );
      if (hasSpeech) {
        // Get the list of languages installed on the supporting platform so they
        // can be displayed in the UI for selection by the user.
        _localeNames = await speech.locales();

        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        lastError = 'Speech recognition failed: ${e.toString()}';
        _hasSpeech = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Speech to Text Example'),
        ),
        body: Column(children: [
          const HeaderWidget(),
          Column(
            children: <Widget>[
              InitSpeechWidget(_hasSpeech, initSpeechState),
              SpeechControlWidget(_hasSpeech, speech.isListening,
                  startListening, stopListening, cancelListening),
              SessionOptionsWidget(
                _currentLocaleId,
                _switchLang,
                _logEvents,
                _switchLogging,
                _pauseForController,
                _listenForController,
                _onDevice,
                _switchOnDevice,
              ),
            ],
          ),
          Expanded(
            flex: 4,
            child: RecognitionResultsWidget(lastWords: lastWords, level: level),
          ),
          Expanded(
            flex: 1,
            child: ErrorWidget(lastError: lastError),
          ),
          SpeechStatusWidget(speech: speech),
        ]),
      ),
    );
  }

  // This is called each time the users wants to start a new speech
  // recognition session
  void startListening() {
    _logEvent('start listening');
    lastWords = '';
    lastError = '';
    final pauseFor = int.tryParse(_pauseForController.text);
    final listenFor = int.tryParse(_listenForController.text);
    final options = SpeechListenOptions(
        onDevice: _onDevice,
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
        autoPunctuation: true,
        enableHapticFeedback: true);
    // Note that `listenFor` is the maximum, not the minimum, on some
    // systems recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    speech.listen(
      onResult: resultListener,
      listenFor: Duration(seconds: listenFor ?? 30),
      pauseFor: Duration(seconds: pauseFor ?? 3),
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      listenOptions: options,
    );
    setState(() {});
  }

  void stopListening() {
    _logEvent('stop');
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    setState(() {
      lastWords = '${result.recognizedWords} - ${result.finalResult}';
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = status;
    });
  }

  void _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    debugPrint(selectedVal);
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      debugPrint('$eventTime $eventDescription');
    }
  }

  void _switchLogging(bool? val) {
    setState(() {
      _logEvents = val ?? false;
    });
  }

  void _switchOnDevice(bool? val) {
    setState(() {
      _onDevice = val ?? false;
    });
  }
}

/// Displays the most recently recognized words and the sound level.
class RecognitionResultsWidget extends StatelessWidget {
  const RecognitionResultsWidget({
    Key? key,
    required this.lastWords,
    required this.level,
  }) : super(key: key);

  final String lastWords;
  final double level;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Center(
          child: Text(
            'Recognized Words',
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              Container(
                color: Theme.of(context).secondaryHeaderColor,
                child: Center(
                  child: Text(
                    lastWords,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 10,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: .26,
                            spreadRadius: level * 1.5,
                            color: Colors.black.withOpacity(.05))
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Speech recognition available',
        style: TextStyle(fontSize: 22.0),
      ),
    );
  }
}

/// Display the current error status from the speech
/// recognizer
class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    Key? key,
    required this.lastError,
  }) : super(key: key);

  final String lastError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Center(
          child: Text(
            'Error Status',
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Center(
          child: Text(lastError),
        ),
      ],
    );
  }
}

/// Controls to start and stop speech recognition
class SpeechControlWidget extends StatelessWidget {
  const SpeechControlWidget(this.hasSpeech, this.isListening,
      this.startListening, this.stopListening, this.cancelListening,
      {Key? key})
      : super(key: key);

  final bool hasSpeech;
  final bool isListening;
  final void Function() startListening;
  final void Function() stopListening;
  final void Function() cancelListening;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: !hasSpeech || isListening ? null : startListening,
          child: const Text('Start'),
        ),
        TextButton(
          onPressed: isListening ? stopListening : null,
          child: const Text('Stop'),
        ),
        TextButton(
          onPressed: isListening ? cancelListening : null,
          child: const Text('Cancel'),
        )
      ],
    );
  }
}

class SessionOptionsWidget extends StatelessWidget {
  const SessionOptionsWidget(
      this.currentLocaleId,
      this.switchLang,
      this.logEvents,
      this.switchLogging,
      this.pauseForController,
      this.listenForController,
      this.onDevice,
      this.switchOnDevice,
      {Key? key})
      : super(key: key);

  final String currentLocaleId;
  final void Function(String?) switchLang;
  final void Function(bool?) switchLogging;
  final void Function(bool?) switchOnDevice;
  final TextEditingController pauseForController;
  final TextEditingController listenForController;
  final bool logEvents;
  final bool onDevice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              const Text('pauseFor: '),
              Container(
                  padding: const EdgeInsets.only(left: 8),
                  width: 80,
                  child: TextFormField(
                    controller: pauseForController,
                  )),
              Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: const Text('listenFor: ')),
              Container(
                  padding: const EdgeInsets.only(left: 8),
                  width: 80,
                  child: TextFormField(
                    controller: listenForController,
                  )),
            ],
          ),
          Row(
            children: [
              const Text('On device: '),
              Checkbox(
                value: onDevice,
                onChanged: switchOnDevice,
              ),
              const Text('Log events: '),
              Checkbox(
                value: logEvents,
                onChanged: switchLogging,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InitSpeechWidget extends StatelessWidget {
  const InitSpeechWidget(this.hasSpeech, this.initSpeechState, {Key? key})
      : super(key: key);

  final bool hasSpeech;
  final Future<void> Function() initSpeechState;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: hasSpeech ? null : initSpeechState,
          child: const Text('Initialize'),
        ),
      ],
    );
  }
}

/// Display the current status of the listener
class SpeechStatusWidget extends StatelessWidget {
  const SpeechStatusWidget({
    Key? key,
    required this.speech,
  }) : super(key: key);

  final SpeechToText speech;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: speech.isListening
            ? const Text(
                "I'm listening...",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : const Text(
                'Not listening',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
