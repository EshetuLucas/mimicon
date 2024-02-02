import 'package:flutter/material.dart';

class ImageBuilder extends StatelessWidget {
  const ImageBuilder(
      {Key? key,
      required this.imagePath,
      this.fit = BoxFit.contain,
      this.height,
      this.width})
      : super(key: key);
  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: fit,
      height: height,
      width: width,
    );
  }
}
