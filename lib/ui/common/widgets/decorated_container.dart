import 'package:flutter/material.dart';
import 'package:mimicon/ui/common/app_colors.dart';

class DecoratedContainer extends StatelessWidget {
  const DecoratedContainer({
    super.key,
    required this.child,
    this.shadowColor = kcWhite,
    this.containerColor,
    this.borderColor,
    this.borderRadius = 8,
    this.onTap,
    this.elevation = 0,
    this.hasBorder = true,
    this.shadowOpacity = 0.1,
    this.withCard = true,
  });
  final Widget child;
  final Color shadowColor;
  final Color? containerColor;
  final Color? borderColor;
  final double borderRadius;
  final VoidCallback? onTap;
  final double elevation;
  final bool hasBorder;
  final double shadowOpacity;
  final bool withCard;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: withCard
          ? Card(
              clipBehavior: Clip.antiAlias,
              shadowColor: shadowColor,
              elevation: elevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              margin: EdgeInsets.zero,
              child: _ContainerOnly(
                containerColor: containerColor ?? kcWhite,
                shadowColor: shadowColor,
                shadowOpacity: shadowOpacity,
                borderRadius: borderRadius,
                hasBorder: hasBorder,
                borderColor: borderColor ?? kcWhite,
                child: child,
              ),
            )
          : _ContainerOnly(
              containerColor: containerColor ?? kcWhite,
              shadowColor: shadowColor,
              shadowOpacity: shadowOpacity,
              borderRadius: borderRadius,
              hasBorder: hasBorder,
              borderColor: borderColor ?? kcWhite,
              child: child,
            ),
    );
  }
}

class _ContainerOnly extends StatelessWidget {
  const _ContainerOnly({
    required this.containerColor,
    required this.shadowColor,
    required this.shadowOpacity,
    required this.borderRadius,
    required this.hasBorder,
    required this.borderColor,
    required this.child,
  });

  final Color containerColor;
  final Color shadowColor;
  final double shadowOpacity;
  final double borderRadius;
  final bool hasBorder;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: containerColor,
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(shadowOpacity),
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(
                0, // This is from X direction
                3, // This is from Y direction
              ), // changes position of the shadow to the given direction
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          border: hasBorder ? Border.all(color: borderColor) : null),
      child: child,
    );
  }
}
