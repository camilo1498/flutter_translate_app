import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TargetEnum { red, green, none }

class ItemModel {
  double value;
  Color color;
  TargetEnum target;

  ItemModel({
    required this.value,
    required this.color,
    required this.target,
  });
}

class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> with TickerProviderStateMixin {
  late AnimationController animCtrl;
  final size = ScreenUtil();
  TargetEnum target = TargetEnum.none;
  List<ItemModel> items = [];

  @override
  void initState() {
    super.initState();
    animCtrl = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
      value: -1.0,
      upperBound: 1.0,
      lowerBound: -1.0,
    )..addListener(() => setState(() {}));

    double left =
        (((size.screenWidth / 2) * 1) + ((size.screenWidth / 2))) / 1.945;

    items = [
      ItemModel(
        value: 0,
        color: Colors.red,
        target: TargetEnum.red,
      ),
      ItemModel(
        value: left,
        color: Colors.green,
        target: TargetEnum.green,
      ),
    ];
  }

  @override
  void dispose() {
    animCtrl.dispose();
    super.dispose();
  }

  void _onGestureSlide(double dx) {
    double newValue = animCtrl.value;

    newValue += dx / ((size.screenWidth / 2) - 50 - 1.0).abs();

    if ((animCtrl.value != newValue) && (newValue > -1.0 && newValue < 1.0)) {
      animCtrl.value = newValue;
    }
  }

  void _onGestureEnd(Velocity v, {bool isSecond = false}) {
    double minFlingVelocity = (size.screenWidth / 2);
    if (animCtrl.isAnimating) return;
    double visualVelocity = isSecond
        ? v.pixelsPerSecond.dx / ((size.screenWidth / 2))
        : -v.pixelsPerSecond.dx / ((size.screenWidth / 2));
    double d2Close = animCtrl.value + 1;
    double d2Open = 1 - animCtrl.value;
    double minDistance = min(d2Close, d2Open);
    if (v.pixelsPerSecond.dx.abs() >= minFlingVelocity) {
      animCtrl.fling(velocity: visualVelocity);
      return;
    }
    if (minDistance == d2Close) {
      _flingPanelToPosition(-1.0, visualVelocity);
    } else {
      _flingPanelToPosition(1.0, visualVelocity);
    }
  }

  void _flingPanelToPosition(double targetPos, double velocity) {
    double adjustedVelocity = velocity * 0.1;
    final Simulation simulation = SpringSimulation(
      SpringDescription.withDampingRatio(
        mass: 1.0,
        stiffness: 100.0,
        ratio: 1.5,
      ),
      animCtrl.value,
      targetPos,
      adjustedVelocity,
    );
    animCtrl.animateWith(simulation);
  }

  void _onDragStart(int index) {
    setState(() {
      final item = items.removeAt(index);
      items.insert(1, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = ScreenUtil();
    double left =
        (((size.screenWidth / 2) * animCtrl.value) + ((size.screenWidth / 2))) /
            1.945;

    return Column(
      children: [
        Container(
          height: 200.h,
          width: size.screenWidth,
          color: Colors.black,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (animCtrl.isCompleted) {
                      animCtrl.reverse();
                    } else {
                      animCtrl.forward();
                    }
                    setState(() {});
                  },
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    color: Colors.white,
                  ),
                ),
              ),
              /*   AnimatedBuilder(
                animation: animCtrl,
                builder: (context, child) => Stack(
                  children: [
                    _ItemButton(
                      start: (details) => updateTarget(TargetEnum.red),
                      update: (details) => _onGestureSlide(details.delta.dx),
                      end: (details) {
                        _onGestureEnd(details.velocity, isSecond: true);
                      },
                      color: Colors.red,
                      value: animCtrl.value,
                    ),
                    _ItemButton(
                      start: (details) => updateTarget(TargetEnum.green),
                      update: (details) => _onGestureSlide(
                        -details.delta.dx,
                      ),
                      end: (details) {
                        _onGestureEnd(details.velocity, isSecond: false);
                      },
                      color: Colors.green,
                      value: -animCtrl.value,
                    ),
                  ]..sort((a, b) {
                      print(target == TargetEnum.red);
                      if (target == TargetEnum.red) {
                        return 1;
                      } else {
                        return -1;
                      }
                    }),
                ),
              ),*/
              AnimatedBuilder(
                animation: animCtrl,
                builder: (context, child) => Stack(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    return Positioned(
                      left: item.target == TargetEnum.red
                          ? left
                          : (size.screenWidth / 1.945) - left,
                      child: GestureDetector(
                        onTap: () => _onDragStart(index),
                        onHorizontalDragStart: (details) => _onDragStart(index),
                        onHorizontalDragUpdate: (details) => _onGestureSlide(
                          item.target == TargetEnum.red
                              ? details.delta.dx
                              : -details.delta.dx,
                        ),
                        onHorizontalDragEnd: (details) => _onGestureEnd(
                            details.velocity,
                            isSecond: item.target == TargetEnum.red),
                        child: Container(
                          width: (size.screenWidth / 2) - 50,
                          height: 50,
                          color: item.color,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ItemButton extends StatelessWidget {
  const _ItemButton({
    super.key,
    this.end,
    this.start,
    this.update,
    required this.value,
    required this.color,
  });

  final double value;
  final Function(DragEndDetails)? end;
  final Function(DragStartDetails)? start;
  final Function(DragUpdateDetails)? update;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final size = ScreenUtil();
    double left = ((size.screenWidth / 2) * value) + ((size.screenWidth / 2));
    double screenWidthFraction = left / 1.94;
    screenWidthFraction = screenWidthFraction.clamp(0.0, 240);
    print(screenWidthFraction);
    return Positioned(
      left: screenWidthFraction,
      child: GestureDetector(
        onHorizontalDragStart: start,
        onHorizontalDragUpdate: update,
        onHorizontalDragEnd: end,
        child: Container(
          width: (size.screenWidth / 2) - 50,
          height: 50,
          color: color,
        ),
      ),
    );
  }
}
