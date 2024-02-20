import 'package:flutter/material.dart';
import 'package:mimicon/enums/button_size_type.dart';
import 'package:mimicon/ui/common/ui_helpers.dart';
import 'package:mimicon/ui/common/widgets/app_button.dart';
import 'package:mimicon/ui/common/widgets/input_field.dart';
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
              title: 'Button',
              onTap: viewModel.onHLS,
              buttonSize: ButtonSize.larg,
            ),
            verticalSpaceMedium,
            AppButton(
              title: 'Button',
              onTap: viewModel.onHLS,
              buttonSize: ButtonSize.medium,
            ),
            verticalSpaceMedium,
            AppButton(
              title: 'Button',
              onTap: viewModel.onHLS,
              buttonSize: ButtonSize.small,
            ),

            verticalSpaceMedium,

            InputField(
              placeholder: 'Place holder',
              hasFieldHight: true,
              controller: TextEditingController(),
              hasFocusedBorder: true,
            ),
            // verticalSpaceMedium,
            // AppButton(
            //   title: 'HLS loading',
            //   onTap: viewModel.onSTT,
            // ),
            // verticalSpaceMedium,
            // AppButton(
            //   title: 'STT/VAD',
            //   onTap: viewModel.onSTT,
            // ),
            // verticalSpaceMedium,
            // AppButton(
            //   title: 'Face Landmarks',
            //   onTap: viewModel.onFaceDetection,
            // ),
            // verticalSpaceMedium,
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
