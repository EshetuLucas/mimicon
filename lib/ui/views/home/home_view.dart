import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:mimicon/enums/container_shape_type.dart';
import 'package:mimicon/enums/image_source_type.dart';
import 'package:mimicon/ui/common/widgets/app_button.dart';
import 'package:mimicon/ui/common/widgets/svg_builder.dart';
import 'package:mimicon/utils/asset_helper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:mimicon/ui/common/app_colors.dart';
import 'package:mimicon/ui/common/ui_helpers.dart';
import 'package:camera/camera.dart';
import 'home_viewmodel.dart';
part 'header_section.dart';
part 'body_section.dart';
part 'bottom_section.dart';

class HomeView extends StackedView<HomeViewModel> {
  HomeView({Key? key}) : super(key: key);
  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.onInit();
    super.onViewModelReady(viewModel);
  }

  final GlobalKey imageKey = GlobalKey();

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return AbsorbPointer(
      absorbing: viewModel.isBusy,
      child: PopScope(
        canPop: !viewModel.hasSelectedFile,
        onPopInvoked: (didPop) {
          viewModel.onAndroidBackButtonTap();
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const HeaderSection(),
                BodySection(imageKey: imageKey),
                BottomSection(imageKey: imageKey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel(imageKey);
}
