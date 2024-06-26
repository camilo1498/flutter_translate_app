import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// get navigation
AppNavigator get appNavigator => AppNavigator._instance;

///
class AppNavigator {
  ///
  factory AppNavigator() => _instance;

  ///
  AppNavigator._internal();

  /// class instance
  static final AppNavigator _instance = AppNavigator._internal();

  /// app main key
  GlobalKey<NavigatorState> globalNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'navigator key');

  ///
  Future<T?> pushNamed<T extends Object?>({
    dynamic arguments,
    required String page,
    required BuildContext context,
  }) async =>
      Navigator.of(context).pushNamed(
        page,
        arguments: arguments,
      );

  ///
  void back<T extends Object?>({
    T? result,
    required BuildContext context,
  }) =>
      Navigator.of(context).pop();
}
