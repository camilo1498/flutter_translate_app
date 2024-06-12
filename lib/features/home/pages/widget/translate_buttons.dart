import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:g_translate_v2/features/home/pages/widget/buttons_t.dart';

enum ButtonOriginalPosition { right, left }

class ItemModel {
  final double value;
  final String language;
  final VoidCallback? onTap;
  final ButtonOriginalPosition position;
  OverlayEntry? overlayEntry;

  ItemModel({
    this.onTap,
    required this.value,
    required this.position,
    required this.language,
  });
}

class Buttons extends StatefulWidget {
  const Buttons({Key? key}) : super(key: key);

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> with TickerProviderStateMixin {
  late AnimationController btnTransitionAnimCtrl;
  late List<ItemModel> _items;

  @override
  void initState() {
    super.initState();
    btnTransitionAnimCtrl = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: -1.0,
      upperBound: 1.0,
      lowerBound: -1.0,
    )..addListener(() {
        setState(() {});
      });

    final double left = ScreenUtil().screenWidth / 1.945;

    _items = [
      ItemModel(
        value: 0,
        position: ButtonOriginalPosition.left,
        language: 'Inglés',
      ),
      ItemModel(
        value: left,
        position: ButtonOriginalPosition.right,
        language: 'Español',
      ),
    ];
  }

  @override
  void dispose() {
    btnTransitionAnimCtrl.dispose();
    super.dispose();
  }

  void _onGestureSlide(double dx, int index) {
    double newValue = btnTransitionAnimCtrl.value +
        (index == 0 ? -dx : dx) / (ScreenUtil().screenWidth / 2 - 51).abs();

    if (newValue > -1.0 && newValue < 1.0) {
      btnTransitionAnimCtrl.value = newValue;
    }
  }

  void _onGestureEnd(Velocity velocity, {bool isSecond = false}) {
    if (btnTransitionAnimCtrl.isAnimating) return;

    double visualVelocity = velocity.pixelsPerSecond.dx /
        (ScreenUtil().screenWidth / 2) *
        (isSecond ? 1 : -1);
    double maxD = btnTransitionAnimCtrl.value + 1;
    double minD = 1 - btnTransitionAnimCtrl.value;
    double minDistance = min(maxD, minD);

    if (velocity.pixelsPerSecond.dx.abs() >= ScreenUtil().screenWidth / 2) {
      btnTransitionAnimCtrl.fling(velocity: visualVelocity);
    } else {
      _flingPanelToPosition(minDistance == maxD ? -1.0 : 1.0, visualVelocity);
    }
  }

  void _flingPanelToPosition(double targetPos, double velocity) {
    btnTransitionAnimCtrl.animateWith(SpringSimulation(
      SpringDescription.withDampingRatio(
        mass: 1.0,
        stiffness: 100.0,
        ratio: 1.5,
      ),
      btnTransitionAnimCtrl.value,
      targetPos,
      velocity * 0.1,
    ));
  }

  void _onDragStart(int index) {
    final item = _items.removeAt(index);
    _items.insert(1, item);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = ScreenUtil().screenWidth;

    return SizedBox(
      height: 80,
      width: screenWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              btnTransitionAnimCtrl.isCompleted
                  ? btnTransitionAnimCtrl.reverse()
                  : btnTransitionAnimCtrl.forward();
              setState(() {});
            },
            child: Container(
              width: 60.w,
              height: 60.w,
              color: Colors.white,
            ),
          ),
          ...List.generate(_items.length, (index) {
            final item = _items[index];

            double left = (screenWidth / 2 * btnTransitionAnimCtrl.value +
                    screenWidth / 2) /
                1.945;

            return Builder(
              builder: (BuildContext context) {
                return Positioned(
                  left: item.position == ButtonOriginalPosition.left
                      ? left
                      : screenWidth / 1.945 - left,
                  child: ButtonsT(
                    index: index,
                    item: item,
                    transitionValue: btnTransitionAnimCtrl.value,
                    onDragStart: () => _onDragStart(index),
                    onHorizontalDragStart: (_) => _onDragStart(index),
                    onHorizontalDragUpdate: (details) => _onGestureSlide(
                        item.position == ButtonOriginalPosition.left
                            ? details.delta.dx
                            : -details.delta.dx,
                        index),
                    onHorizontalDragEnd: (details) => _onGestureEnd(
                        details.velocity,
                        isSecond: item.position == ButtonOriginalPosition.left),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
