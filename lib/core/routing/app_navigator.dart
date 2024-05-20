import 'package:flutter/cupertino.dart';

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
    required String page,
    dynamic arguments,
  }) async =>
      Navigator.of(globalNavigatorKey.currentContext!).pushNamed(
        page,
        arguments: arguments,
      );

  ///
  void back<T extends Object?>({
    T? result,
  }) =>
      Navigator.of(globalNavigatorKey.currentContext!).canPop();
}
