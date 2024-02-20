import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mimicon/ui/common/app_colors.dart';
import 'package:mimicon/ui/views/home/widgets/bottom_navbar_items.dart';
import 'package:mimicon/ui/views/mimicons/mimicons_view.dart';
import 'package:mimicon/ui/views/more/more_view.dart';
import 'package:stacked/stacked.dart';
import 'home_viewmodel.dart';

// Widget representing the home screen view
class HomeView extends StatelessWidget {
  const HomeView({super.key, this.businessId});

  final String? businessId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        // Body containing the main content
        body: GetViewForIndex(index: viewModel.currentIndex),
        bottomNavigationBar: const _BottomNavBar(),
        extendBody: true,
      ),
    );
  }
}

// Widget representing the bottom navigation bar
class _BottomNavBar extends ViewModelWidget<HomeViewModel> {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return ClipRRect(
      child: BottomAppBar(
        height: 60,
        color: kcTransparent,
        elevation: 1,
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 40,
            sigmaY: 40,
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: BottomNavBarItems(),
          ),
        ),
      ),
    );
  }
}

// Widget for displaying the view based on index
class GetViewForIndex extends ViewModelWidget<HomeViewModel> {
  const GetViewForIndex({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    switch (index) {
      case 0:
        return const MimiconsView();
      case 1:
        return const MoreView();
      case 2:
        return const MoreView();
      default:
        return const MoreView();
    }
  }
}
