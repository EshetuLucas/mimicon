part of 'home_view.dart';

class BottomSection extends ViewModelWidget<CameraViewModel> {
  const BottomSection({
    super.key,
    required this.imageKey,
  });

  final GlobalKey imageKey;

  @override
  Widget build(BuildContext context, CameraViewModel viewModel) {
    return SafeArea(
      child: SizedBox(
        height: 205,
        child: viewModel.selectedFile == null
            ? const _SelectImageWidget()
            : _EditingWidget(
                imageKey: imageKey,
              ),
      ),
    );
  }
}

class _EditingWidget extends ViewModelWidget<CameraViewModel> {
  const _EditingWidget({
    required this.imageKey,
  });

  final GlobalKey imageKey;

  @override
  Widget build(BuildContext context, CameraViewModel viewModel) {
    return Padding(
      padding: appSymmetricEdgePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          verticalSpaceTiny,
          InkWell(
            onTap: viewModel.onBack,
            child: const Row(
              children: [
                InkWell(
                  child: SvgBuilder(
                    svg: backSvg,
                    color: kcWhite,
                    width: 24,
                    height: 24,
                  ),
                ),
                horizontalSpaceSmall,
                Text(
                  '다시찍기',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: -1),
                ),
              ],
            ),
          ),
          verticalSpaceSmall,
          verticalSpaceSmall,
          if (!viewModel.isDetectingFace && !viewModel.hasMultiFace) ...[
            Row(
              children: [
                _EditiOption(
                  title: '눈',
                  ontap: () =>
                      viewModel.onAddOvalContainer(ContainerShapeType.small),
                ),
                horizontalSpaceSmall,
                _EditiOption(
                  title: '입',
                  ontap: () =>
                      viewModel.onAddOvalContainer(ContainerShapeType.large),
                ),
              ],
            ),
            verticalSpaceLarge,
            AppButton(
              title: '저장하기',
              onTap: () => viewModel.onSave(imageKey),
              enabled: viewModel.canSaveAnImage,
              busy: viewModel.isBusy,
            ),
            verticalSpaceTiny,
          ]
        ],
      ),
    );
  }
}

class _SelectImageWidget extends ViewModelWidget<CameraViewModel> {
  const _SelectImageWidget();

  @override
  Widget build(BuildContext context, CameraViewModel viewModel) {
    return Padding(
      padding: appSymmetricEdgePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          verticalSpaceMedium,
          GestureDetector(
            onTap: () => viewModel.pickImage(ImageSourceType.camera),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: kcWhite,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  height: 58,
                  width: 58,
                  decoration: BoxDecoration(
                    border: Border.all(color: kcDark),
                    shape: BoxShape.circle,
                    color: kcWhite,
                  ),
                ),
              ),
            ),
          ),
          verticalSpaceSmall,
          verticalSpaceLarge,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => viewModel.pickImage(ImageSourceType.file),
                child: const SvgBuilder(svg: gallerySvg),
              ),
              ChangeCamera(
                onTap: viewModel.onChangeCamera,
                quarterTurns: viewModel.cameraChangeIconTurns,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _EditiOption extends StatelessWidget {
  const _EditiOption({required this.title, this.ontap});
  final String title;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 60,
        width: 60,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: kcWhite,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Text(
          title,
          style: const TextStyle(
              color: kcDark,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              letterSpacing: -1),
        ),
      ),
    );
  }
}

class ChangeCamera extends StatelessWidget {
  const ChangeCamera({
    Key? key,
    this.onTap,
    this.quarterTurns = 0,
  }) : super(key: key);
  final VoidCallback? onTap;

  final double quarterTurns;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedRotation(
        turns: quarterTurns,
        duration: const Duration(milliseconds: 500),
        child: const SvgBuilder(
          svg: changeSvg,
        ),
      ),
    );
  }
}
