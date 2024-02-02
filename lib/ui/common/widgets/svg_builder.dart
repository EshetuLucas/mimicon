import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgBuilder extends StatelessWidget {
  final String svg;
  final Color? color;
  final BoxFit fit;
  final double? height;
  final double? width;
  const SvgBuilder({
    Key? key,
    required this.svg,
    this.color,
    this.fit = BoxFit.contain,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svg,
      fit: fit,
      height: height,
      width: width,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
