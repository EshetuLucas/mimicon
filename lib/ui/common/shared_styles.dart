import 'package:flutter/material.dart';
import 'package:mimicon/ui/common/app_colors.dart';

// Box Decorations

BoxDecoration kdbFieldDecortaionLight = BoxDecoration(
    borderRadius: BorderRadius.circular(5), color: Colors.grey[200]);

// Card and Container shape
const RoundedRectangleBorder krrBoxBorderShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
  Radius.circular(8),
));

// All App Text Styles

TextStyle ktsWhite(
        {double fontSize = 14,
        FontWeight fontWeight = FontWeight.w400,
        required BuildContext context}) =>
    TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: Theme.of(context).colorScheme.tertiary,
    );

TextStyle ktsButtonTextTextStyle(BuildContext context) => TextStyle(
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.tertiary,
    fontSize: 16);

TextStyle ktsAppTitleTextStyle(BuildContext context) => TextStyle(
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.tertiary,
    fontSize: 28);

TextStyle ktsMediumDarkTextStyle(BuildContext context) => TextStyle(
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: 16);

TextStyle ktsSmallDarkTextStyle(BuildContext context) => TextStyle(
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: 15);
TextStyle ktsBoldMeidumDarkTextStyle(BuildContext context) => TextStyle(
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: 14);
TextStyle ktsSmallWhiteTextStyle(context) => TextStyle(
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.tertiary,
    fontSize: 14);

TextStyle ktsLightGreyMeidumTextStyle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.tertiaryContainer,
      fontSize: 14,
    );
TextStyle ktsLightGreySmallTextStyle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.tertiaryContainer,
      fontSize: 12,
    );
TextStyle ktsWhiteMediumTextStyle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.tertiary,
      fontSize: 16,
    );
TextStyle ktsWhiteSmallTextStyle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.tertiary,
      fontSize: 14,
    );
TextStyle ktsDarkSmallTextStyle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 15,
    );

TextStyle ktsDarkGreyTextStyle(BuildContext context) =>
    const TextStyle(color: kcDark, fontSize: 18.0);

TextStyle ktsDarkGreyBoldTextStyle(BuildContext context) => TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 26.0,
      fontWeight: FontWeight.w800,
    );

TextStyle ktsVeryLightGreyBodyTextStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.tertiaryContainer, fontSize: 20);

TextStyle ktsHeading900(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 18,
    );

TextStyle ktsHeading800(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 18,
    );

TextStyle ktsRegular(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 16,
    );

TextStyle ktsSemibold(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 16,
    );

TextStyle ktsSemiboldBlack(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 16,
    );

TextStyle ktsSemibold300(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 18,
    );

TextStyle ktsSemiboldWhite300(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.tertiary,
      fontSize: 18,
    );

TextStyle ktsText100(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.tertiaryContainer,
      fontSize: 17,
    );
TextStyle ktsText200(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.tertiaryContainer,
      fontSize: 12,
    );

TextStyle ktsSmall(BuildContext context) => const TextStyle(
      height: 1.5,
      fontWeight: FontWeight.w400,
      color: kcDark,
      fontSize: 13,
    );

TextStyle ktsDarkSmall(BuildContext context) => TextStyle(
      height: 1.5,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 14,
    );

// Field Variables

const double fieldHeight = 55;
const double smallFieldHeight = 40;
const double inputFieldBottomMargin = 30;
const double inputFieldSmallBottomMargin = 0;
const EdgeInsets fieldPadding = EdgeInsets.symmetric(horizontal: 15);
const EdgeInsets largeFieldPadding =
    EdgeInsets.symmetric(horizontal: 15, vertical: 15);
EdgeInsets appSymmetricEdgePadding = const EdgeInsets.symmetric(
  horizontal: 20,
);

/// Padding
const EdgeInsets commonHorizontalPadding10 =
    EdgeInsets.symmetric(horizontal: 20);

EdgeInsets appLeftEdgePadding = const EdgeInsets.only(
  left: 16,
);
