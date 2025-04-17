import 'dart:developer';

import 'package:flutter/material.dart';

extension NavigationExtensions on BuildContext {
  /// Push a new route onto the stack
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
  }

  /// Push a new route and replace the current one
  Future<T?> pushReplacement<T, TO>(Widget page) {
    return Navigator.of(this).pushReplacement(MaterialPageRoute(builder: (_) => page));
  }

  /// Push a new route and clear the entire stack
  Future<T?> pushAndRemoveUntil<T>(Widget page, {bool Function(Route<dynamic>)? predicate}) {
    return Navigator.of(this).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => page), predicate ?? (_) => false);
  }

  /// Pop the current route
  void pop<T extends Object?>([T? result]) {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop();
    } else {
      log("Failed to pop a route");
    }
  }

  /// check if the route can be popped
  bool canPop<T extends Object?>([T? result]) {
    if (Navigator.of(this).canPop()) {
      return true;
    } else {
      return false;
    }
  }

  /// Pop until a specific route
  void popUntil(bool Function(Route<dynamic>) predicate) {
    Navigator.of(this).popUntil(predicate);
  }

  /// Push a new route with a fade transition and remove until a specific condition
  Future<T?> pushAndRemoveUntilWithFade<T>(Widget page, {bool Function(Route<dynamic>)? predicate}) {
    return Navigator.of(this).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      predicate ?? (_) => false,
    );
  }
}
