import 'package:flutter/material.dart';
import 'package:mimicon/ui/common/app_colors.dart';
import 'package:mimicon/ui/common/widgets/svg_builder.dart';
import 'package:mimicon/ui/views/home/home_viewmodel.dart';
import 'package:mimicon/utils/asset_helper.dart';
import 'package:stacked/stacked.dart';

class BottomNavBarItems extends ViewModelWidget<HomeViewModel> {
  const BottomNavBarItems({super.key});

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Home icon
          BottomNavigationBarItem(
              icon: homeSvg,
              isSelected: viewModel.currentIndex == 0,
              onTap: () => viewModel.setIndex(0)),
          // Chat icon
          BottomNavigationBarItem(
            icon: roomSvg,
            isSelected: viewModel.currentIndex == 1,
            onTap: () => viewModel.setIndex(1),
          ),

          BottomNavigationBarItem(
            icon: actionSvg,
            bottomPadding: 5,
            isSelected: viewModel.currentIndex == 2,
            onTap: () => viewModel.setIndex(2),
          ),

          BottomNavigationBarItem(
            icon: chatSvg,
            isSelected: viewModel.currentIndex == 3,
            onTap: () => viewModel.setIndex(3),
          ),

          BottomNavigationBarItem(
            icon: moreSvg,
            isSelected: viewModel.currentIndex == 4,
            onTap: () => viewModel.setIndex(4),
          ),
        ],
      ),
    );
  }
}

// Custom bottom navigation bar item
class BottomNavigationBarItem extends StatelessWidget {
  const BottomNavigationBarItem({
    super.key,
    required this.icon,
    required this.isSelected,
    this.onTap,
    this.bottomPadding = 14,
  });

  final String icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgBuilder(
            svg: icon,
            color: isSelected ? kcDark : null,
          ),
          SizedBox(
            height: bottomPadding,
          )
        ],
      ),
    );
  }
}
