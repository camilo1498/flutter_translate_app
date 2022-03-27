import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AxisPageTransition extends PageRouteBuilder {
  final Widget child;
  AxisDirection direction;
  AxisPageTransition(
      {required this.child, this.direction = AxisDirection.right})
      : super(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(begin: _getDirection(), end: Offset.zero)
            .animate(animation),
        child: child,
      );

  Offset _getDirection() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.right:
        return const Offset(0, -1);
      case AxisDirection.down:
        return const Offset(-1, 0);
      case AxisDirection.left:
        return const Offset(1, 0);
    }
  }
}