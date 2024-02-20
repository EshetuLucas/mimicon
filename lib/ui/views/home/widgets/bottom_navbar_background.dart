import 'package:flutter/material.dart';
import 'package:mimicon/ui/common/app_colors.dart';

class BottomNavBarBackgroundWidget extends StatelessWidget {
  const BottomNavBarBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: kcWhite,
            width: 1.8,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
      ),
    );
  }
}
