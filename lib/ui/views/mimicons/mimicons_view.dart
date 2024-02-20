import 'package:flutter/material.dart';
import 'package:mimicon/ui/common/app_colors.dart';
import 'package:mimicon/ui/common/shared_styles.dart';
import 'package:mimicon/ui/common/ui_helpers.dart';
import 'package:mimicon/ui/common/widgets/placeholder_image.dart';
import 'package:mimicon/ui/common/widgets/profile_pic_builder.dart';
import 'package:mimicon/ui/common/widgets/svg_builder.dart';
import 'package:mimicon/utils/asset_helper.dart';
import 'package:stacked/stacked.dart';

import 'mimicons_viewmodel.dart';

class MimiconsView extends StackedView<MimiconsViewModel> {
  const MimiconsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MimiconsViewModel viewModel,
    Widget? child,
  ) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        extendBody: true,
        body: Padding(
          padding: appSymmetricEdgePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgBuilder(svg: logoSvg),
                  SvgBuilder(svg: notificationSvg)
                ],
              ),
              verticalSpace(7),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: const [
                    _MimiconWidget(),
                    verticalSpaceMedium,
                    _MimiconWidget(),
                    verticalSpaceMedium,
                    _MimiconWidget(),
                    verticalSpaceMedium,
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  MimiconsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MimiconsViewModel();
}

class _MimiconWidget extends StatelessWidget {
  const _MimiconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Stack(
              children: [
                Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: ProfilePicBuilder(
                        size: 34,
                        fit: BoxFit.cover,
                        url: sampleTed1,
                      ),
                    ),
                    Container(
                      height: 34,
                      width: 34,
                      margin: const EdgeInsets.only(left: 4),
                      decoration: const BoxDecoration(
                          color: kcWhite, shape: BoxShape.circle),
                    ),
                    const ProfilePicBuilder(
                      size: 34,
                      fit: BoxFit.cover,
                      url: sampleTed,
                    ),
                  ],
                ),
              ],
            ),
            horizontalSpaceSmall,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '졸린쿠키님과',
                  style: ktsSemibold(context)
                      .copyWith(fontSize: 12, color: kcDark),
                ),
                Text(
                  '느긋한초코칩님의 대화',
                  style: ktsSemibold(context)
                      .copyWith(fontSize: 12, color: kcDark),
                ),
              ],
            ),
            const Spacer(),
            const SvgBuilder(svg: moreHorizontalSvg)
          ],
        ),
        verticalSpace(18),
        Container(
          clipBehavior: Clip.antiAlias,
          height: screenHeight(context) / 1.85,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24))),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight(context) / 1.85,
                child: Stack(
                  children: [
                    const PlaceholderImage(
                        fit: BoxFit.cover,
                        cornerRadius: 24,
                        imageUrl: sampleTed2,
                        errorImageUrl: ''),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: kcDark.withOpacity(0.8),
                          spreadRadius: 4,
                          blurRadius: 40,
                          offset: const Offset(
                            0, // This is from X direction
                            -10, // This is from Y direction
                          ), // changes position of the shadow to the given direction
                        )
                      ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Text(
                              '느긋한초코칩님의 대화',
                              style: ktsSmall(context)
                                  .copyWith(fontSize: 14, color: kcWhite),
                            ),
                            const Spacer(),
                            const SvgBuilder(svg: muteSvg),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
