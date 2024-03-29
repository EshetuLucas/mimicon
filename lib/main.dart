import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimicon/app/app.dialogs.dart';
import 'package:mimicon/app/app.locator.dart';
import 'package:mimicon/app/app.router.dart';
import 'package:mimicon/ui/common/app_colors.dart';
import 'package:mimicon/ui/views/home/home_view.dart';
import 'package:mimicon/ui/views/play_video/play_video_view.dart';
import 'package:mimicon/ui/views/speech_to_text/speech_to_text_view.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:io';

import 'package:video_player/video_player.dart';

void main() {
  setupLocator();
  setupDialogUi();
  runApp(const MyApp());
}

class MyApp extends StackedView<MainViewModel> {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MainViewModel viewModel,
    Widget? child,
  ) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
        splashColor: kcTransparent,
        highlightColor: kcTransparent,
        hoverColor: kcTransparent,
        scaffoldBackgroundColor: kcDark,
        primaryColor: kcDark,
        focusColor: kcPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kcWhite),
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: viewModel.systemUiOverlayStyle,
          child:
              //MyHomePage()
              const PlayVideoView()
          //HomeView(),
          ),
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [
        StackedService.routeObserver,
      ],
    );
  }

  @override
  MainViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainViewModel();
}

class MainViewModel extends BaseViewModel {
  SystemUiOverlayStyle get systemUiOverlayStyle =>
      Platform.isAndroid ? androidOverlayStyle : iosOverlayStyle;

  static const iosOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: kcDark,
    systemNavigationBarColor: kcDark,
    systemNavigationBarDividerColor: kcDark,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemStatusBarContrastEnforced: true,
    statusBarIconBrightness: Brightness.dark,
  );

  static const androidOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: kcDark,
    systemNavigationBarColor: kcDark,
    systemNavigationBarDividerColor: kcDark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
    systemStatusBarContrastEnforced: true,
    statusBarIconBrightness: Brightness.light,
  );
}
