part of 'home_view.dart';

class HeaderSection extends ViewModelWidget<HomeViewModel> {
  const HeaderSection({super.key});
  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Column(
      children: [
        verticalSpaceSmall,
        Padding(
          padding: appSymmetricEdgePadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (viewModel.hasSelectedFile)
                const Icon(
                  Icons.close,
                  color: kcWhite,
                ),
              horizontalSpaceSmall,
              const Icon(
                Icons.more_vert_outlined,
                color: kcWhite,
              ),
            ],
          ),
        ),
        verticalSpaceSmall,
      ],
    );
  }
}
