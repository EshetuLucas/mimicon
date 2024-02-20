import 'package:flutter/material.dart';

class RectangleFillPainter extends CustomPainter {
  bool hasPainted = true;
  final double radius;

  RectangleFillPainter(this.radius);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
        Paint()..color = Colors.grey);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (!hasPainted) {
      hasPainted = true;
      return true;
    }
    return false;
  }
}

const int _transitionDuration = 500;

/// A widget that allows you to provide the expected UI and will render a shimmer over that
/// while loading is true.
class RASkeletonLoader extends StatefulWidget {
  final bool loading;
  final Widget child;
  final Color? startColor;
  final Color? endColor;
  final Duration duration;
  final double radius;
  const RASkeletonLoader({
    Key? key,
    required this.child,
    required this.loading,
    this.duration = const Duration(milliseconds: 900),
    this.startColor,
    this.endColor,
    this.radius = 2,
  }) : super(key: key);

  @override
  _SkeletonLoaderState createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<RASkeletonLoader>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Color?>? animationOne;
  Animation<Color?>? animationTwo;

  Widget? _initialWidget;
  bool _transitionToNewWidget = false;
  bool _dispose = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Store the loading widget we first constructed with
      _initialWidget ??= widget.child;
      if (mounted) {
        _controller = AnimationController(
          duration: widget.duration,
          vsync: this,
        );
      }

      if (_controller != null && mounted) {
        animationOne = ColorTween(
                begin: widget.startColor ??
                    Theme.of(context).colorScheme.inversePrimary,
                end: widget.endColor ?? Theme.of(context).colorScheme.tertiary)
            .animate(_controller!);
        animationTwo = ColorTween(
          begin: widget.endColor ?? Theme.of(context).colorScheme.tertiary,
          end:
              widget.startColor ?? Theme.of(context).colorScheme.inversePrimary,
        ).animate(_controller!);

        _controller!.forward();

        _controller!.addListener(() {
          if (_controller!.status == AnimationStatus.completed) {
            _controller!.reverse();
          } else if (_controller!.status == AnimationStatus.dismissed) {
            _controller!.forward();
          }

          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if it's updated
    if (widget.child != _initialWidget && widget.loading) {
      // Indicate that we want to transition to a new widget

      _transitionToNewWidget = true;
      _initialWidget = widget.child;

      // Since the ShaderMask will still be rendered BUT the size
      // has now updated to match the actual data.
      // We will use a delayed future to only fade out the shader mask
      // a few milliseconds after we have received the actual widget.
      Future.delayed(const Duration(milliseconds: _transitionDuration))
          .then((value) {
        if (!_dispose) {
          setState(() {
            _transitionToNewWidget = false;
          });
        }
      });
    }

    return IgnorePointer(
      ignoring: widget.loading,
      child: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          // We only want to show this if the widget is loading OR if the widget is busy with the transition.
          child: widget.loading || _transitionToNewWidget
              ? AnimatedSize(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeOut,
                  child: ShaderMask(
                    child: CustomPaint(
                      child: widget.child,
                      foregroundPainter: RectangleFillPainter(widget.radius),
                    ),
                    blendMode: BlendMode.srcATop,
                    shaderCallback: (rect) {
                      return LinearGradient(colors: [
                        animationOne?.value ??
                            Theme.of(context).colorScheme.inversePrimary,
                        animationTwo?.value ??
                            Theme.of(context).colorScheme.tertiary,
                      ]).createShader(rect);
                    },
                  ),
                )
              : widget.child),
    );
  }

  @override
  void dispose() {
    _dispose = true;
    _controller?.dispose();
    super.dispose();
  }
}

// class RectangleFillPainter extends CustomPainter {
//   bool hasPainted = true;
//   final Color color;

//   RectangleFillPainter({super.repaint, required this.color});
//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(0, 0, size.width, size.height),
//           const Radius.circular(.0),
//         ),
//         Paint()..color = color);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     if (!hasPainted) {
//       hasPainted = true;
//       return true;
//     }
//     return false;
//   }
// }
