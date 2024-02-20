enum ButtonSize {
  larg,
  medium,
  small,
}

extension ButtonSizeExtension on ButtonSize {
  double get size {
    switch (this) {
      case ButtonSize.larg:
        return 64;
      case ButtonSize.medium:
        return 48;
      default:
        return 40;
    }
  }

  double get butonTextSize {
    switch (this) {
      case ButtonSize.larg:
        return 18;
      case ButtonSize.medium:
        return 16;
      default:
        return 14;
    }
  }
}
