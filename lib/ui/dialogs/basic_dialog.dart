import 'package:flutter/material.dart';

class BasicDialog extends StatelessWidget {
  const BasicDialog({
    Key? key,
    required this.child,
    this.onCloseTap,
    this.dialogInsetPadding,
    this.padding,
    this.image,
    this.blur = 10,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onCloseTap;
  final EdgeInsets? dialogInsetPadding;
  final EdgeInsets? padding;
  final DecorationImage? image;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: dialogInsetPadding ??
          const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      clipBehavior: Clip.none,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: FrostedDialog(
                child: child,
                blurValue: blur,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FrostedDialog extends StatelessWidget {
  final Widget? child;
  final double blurValue;
  final bool hasDraggableIndicator;

  const FrostedDialog({
    Key? key,
    this.child,
    this.hasDraggableIndicator = false,
    this.blurValue = 0,
  }) : super(key: key);

  final _sheetBorderRadius = const BorderRadius.all(
    Radius.circular(8.0),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: _sheetBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasDraggableIndicator)
              const Center(
                child: _DraggableBottomSheetIndicator(),
              ),
            if (child != null) Flexible(child: child!),
          ],
        ),
      ),
    );
  }
}

class _DraggableBottomSheetIndicator extends StatelessWidget {
  const _DraggableBottomSheetIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 4,
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: Colors.black12,
          width: 0.5,
        ),
      ),
    );
  }
}
