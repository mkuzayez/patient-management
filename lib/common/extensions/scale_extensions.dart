import 'package:flutter/material.dart';

extension ResponsiveSizeExtensions on num {
  /// Scaled height
  double get scaledHeight => ResponsiveScaler.scaleHeight(toDouble());

  /// Scaled width
  double get scaledWidth => ResponsiveScaler.scaleWidth(toDouble());

  /// Scaled font size
  double get scaledFont => ResponsiveScaler.scaleFont(toDouble());
}

class ResponsiveScaler {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _baseWidth;
  static late double _baseHeight;

  /// Initialize with design reference dimensions
  static void init(BuildContext context, {double baseWidth = 360, double baseHeight = 690}) {
    final size = MediaQuery.sizeOf(context);
    _screenWidth = size.width;
    _screenHeight = size.height;
    _baseWidth = baseWidth;
    _baseHeight = baseHeight;
  }

  /// Scale height based on the design reference
  static double scaleHeight(double value) {
    return value * (_screenHeight / _baseHeight);
  }

  /// Scale width based on the design reference
  static double scaleWidth(double value) {
    return value * (_screenWidth / _baseWidth);
  }

  /// Scale font size based on the design reference
  static double scaleFont(double value) {
    return scaleWidth(value); // Font scaling often uses width scaling
  }
}
