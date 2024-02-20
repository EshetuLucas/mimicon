import 'package:flutter/material.dart';
import 'package:mimicon/enums/button_size_type.dart';
import 'package:mimicon/ui/common/app_colors.dart';

class AppButton extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Function onTap;
  final bool enabled;
  final Color backgroundColor;
  final Color? textColor;
  final Color? loadingColor;
  final double? height;
  final bool busy;
  final bool isOutlined;
  final bool shadow;
  final TextStyle? enablebuttonTextStyle;
  final TextStyle? disablebuttonTextStyle;
  final bool showButton;
  final Widget? leadingWidget;
  final bool roundOnlyBottom;
  final double borderRadius;
  final double fontSize;
  final ButtonSize buttonSize;

  const AppButton({
    Key? key,
    this.fontSize = 15,
    this.loadingColor,
    this.borderRadius = 32,
    required this.title,
    this.roundOnlyBottom = false,
    this.enabled = true,
    this.busy = false,
    this.isOutlined = false,
    this.backgroundColor = kcPrimaryColor,
    this.textColor,
    this.shadow = false,
    this.height,
    this.enablebuttonTextStyle,
    this.disablebuttonTextStyle,
    required this.onTap,
    this.showButton = true,
    this.subTitle,
    this.buttonSize = ButtonSize.larg,
    this.leadingWidget,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final buttonHight = height ?? buttonSize.size;

    final enableTextStyle = enablebuttonTextStyle ??
        TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: buttonSize.butonTextSize,
            letterSpacing: -0.45,
            color: kcButtonTextColor);
    return GestureDetector(
      onTap: () => enabled && !busy ? onTap() : null,
      child: AnimatedContainer(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        height: buttonHight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isOutlined
              ? Colors.transparent
              : enabled || busy
                  ? backgroundColor
                  : kcLightGrey,
          borderRadius: roundOnlyBottom
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
              : BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: enabled
                        ? backgroundColor.withOpacity(0.3)
                        : Theme.of(context)
                            .colorScheme
                            .tertiaryContainer
                            .withOpacity(0.6),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(
                      0, // This is from X direction
                      3, // This is from Y direction
                    ), // changes position of the shadow to the given direction
                  ),
                ]
              : [],
        ),
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 150),
          crossFadeState:
              busy ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: SizedBox(
              width: buttonHight - 15,
              height: buttonHight - 15,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(
                    color:
                        loadingColor ?? Theme.of(context).colorScheme.tertiary,
                    strokeWidth: 6,
                  ),
                ),
              )),
          secondChild: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FittedBox(
                child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: enabled
                      ? enableTextStyle
                      : enableTextStyle.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.5),
                          fontSize: fontSize,
                        ),
                  textAlign: TextAlign.center,
                ),
                if (subTitle != null)
                  const SizedBox(
                    height: 3,
                  ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:health/ui/shared/app_colors.dart';
// import 'package:health/ui/shared/shared_styles.dart';

// /// The button used throughout the app.
// ///
// /// Can show a busy indicator.
// /// Can be disabled.
// class AppButton extends StatefulWidget {
//   final bool busy;
//   final String title;
//   final Function onPressed;
//   final bool enabled;
//   final Color? color;

//   const AppButton(
//       {Key? key,
//       required this.title,
//       required this.onPressed,
//       this.busy = false,
//       this.enabled = true,
//       this.color});

//   @override
//   _AppButtonState createState() => _AppButtonState();
// }

// class _AppButtonState extends State<AppButton> {
//   @override
//   Widget build(BuildContext context) {
//     // We wrap the container in a Row and a Column to force it to wrap it's inner child
//     // If we don't do this the button takes up the parents infinite dimension which is not what we want.
//     return GestureDetector(
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         alignment: Alignment.center,
//         padding: EdgeInsets.symmetric(
//             horizontal: widget.busy ? 10 : 25, vertical: widget.busy ? 10 : 10),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: Theme.of(context).colorScheme. onPrimaryContainer,
//           ),
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: !widget.busy
//             ? Text(
//                 widget.title,
//                 style: ktsButtonTitleTextStyle,
//               )
//             : CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme. secondaryDark),
//               ),
//       ),
//     );
//   }
// }
