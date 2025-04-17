import 'package:flutter/material.dart';


extension ContextExtensions on BuildContext {
  /// Get screen width
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Get screen height
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Get screen padding in the top
  double get screenPaddingTop => MediaQuery.of(this).padding.top;

  /// Get screen padding in the bottom
  double get screenPaddingBottom => MediaQuery.of(this).padding.bottom;
}

extension SizedBoxSpacing on num {
  /// Creates a vertical space of the given height
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  /// Creates a horizontal space of the given width
  SizedBox get horizontalSpace => SizedBox(width: toDouble());
}

extension PaddingExtensions on num {
  /// Add padding to all sides
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());

  /// Add vertical padding (top and bottom)
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: toDouble());

  /// Add horizontal padding (left and right)
  EdgeInsets get paddingHorizontal => EdgeInsets.symmetric(horizontal: toDouble());

  /// Add specific padding for top
  EdgeInsets get paddingTop => EdgeInsets.only(top: toDouble());

  /// Add specific padding for bottom
  EdgeInsets get paddingBottom => EdgeInsets.only(bottom: toDouble());

  /// Add specific padding for left
  EdgeInsets get paddingLeft => EdgeInsets.only(left: toDouble());

  /// Add specific padding for right
  EdgeInsets get paddingRight => EdgeInsets.only(right: toDouble());
}

