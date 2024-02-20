import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'more_viewmodel.dart';

class MoreView extends StackedView<MoreViewModel> {
  const MoreView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MoreViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      ),
    );
  }

  @override
  MoreViewModel viewModelBuilder(
    BuildContext context,
  ) => MoreViewModel();
}
