import 'package:flutter/material.dart';
import 'package:mimicon/ui/common/ui_helpers.dart';
import 'package:mimicon/ui/common/widgets/app_button.dart';
import 'package:stacked/stacked.dart';

import 'options_viewmodel.dart';

class OptionsView extends StackedView<OptionsViewModel> {
  const OptionsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    OptionsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Column(
          children: [
            verticalSpaceMassive,
            AppButton(
              height: 45,
              title: 'HLS loading',
              onTap: viewModel.onHLS,
            ),
            verticalSpaceMedium,
            AppButton(
              height: 45,
              title: 'STT/VAD',
              onTap: viewModel.onSTT,
            ),
            verticalSpaceMedium,
            AppButton(
              height: 45,
              title: 'Face Landmarks',
              onTap: viewModel.onFaceDetection,
            ),
            verticalSpaceMedium,
          ],
        ),
      ),
    );
  }

  @override
  OptionsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      OptionsViewModel();
}
