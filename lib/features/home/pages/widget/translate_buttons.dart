import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:g_translate_v2/core/configs/app_colors.dart';

enum ButtonOriginalPosition { right, left }

class ItemModel {
  final double value;
  final String language;
  final VoidCallback? onTap;
  final ButtonOriginalPosition position;

  ItemModel({
    this.onTap,
    required this.value,
    required this.position,
    required this.language,
  });
}

class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> with TickerProviderStateMixin {
  late AnimationController _animCtrl;
  late List<ItemModel> _items;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
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
    _animCtrl.dispose();
    super.dispose();
  }

  void _onGestureSlide(double dx, int index) {
    double newValue = _animCtrl.value +
        (index == 0 ? -dx : dx) / (ScreenUtil().screenWidth / 2 - 51).abs();

    if (newValue > -1.0 && newValue < 1.0) {
      _animCtrl.value = newValue;
    }
  }

  void _onGestureEnd(Velocity velocity, {bool isSecond = false}) {
    if (_animCtrl.isAnimating) return;

    double visualVelocity = velocity.pixelsPerSecond.dx /
        (ScreenUtil().screenWidth / 2) *
        (isSecond ? 1 : -1);
    double maxD = _animCtrl.value + 1;
    double minD = 1 - _animCtrl.value;
    double minDistance = min(maxD, minD);

    if (velocity.pixelsPerSecond.dx.abs() >= ScreenUtil().screenWidth / 2) {
      _animCtrl.fling(velocity: visualVelocity);
    } else {
      _flingPanelToPosition(minDistance == maxD ? -1.0 : 1.0, visualVelocity);
    }
  }

  void _flingPanelToPosition(double targetPos, double velocity) {
    _animCtrl.animateWith(SpringSimulation(
      SpringDescription.withDampingRatio(
        mass: 1.0,
        stiffness: 100.0,
        ratio: 1.5,
      ),
      _animCtrl.value,
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

    return Column(
      children: [
        SizedBox(
          height: 80,
          width: screenWidth,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _animCtrl.isCompleted
                      ? _animCtrl.reverse()
                      : _animCtrl.forward();
                  setState(() {});
                },
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  color: Colors.white,
                ),
              ),
              AnimatedBuilder(
                animation: _animCtrl,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: List.generate(_items.length, (index) {
                      /// gey item index
                      final item = _items[index];

                      /// get position
                      double left = (screenWidth / 2 * _animCtrl.value +
                              screenWidth / 2) /
                          1.945;

                      /// widget
                      return Positioned(
                        left: item.position == ButtonOriginalPosition.left
                            ? left
                            : screenWidth / 1.945 - left,
                        child: Transform.scale(
                          scale: index == 1
                              ? 1
                              : 1 - 0.4 * (1 - _animCtrl.value.abs()),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              _onDragStart(index);
                            },
                            onLongPress: () {
                              print('object');
                            },
                            onHorizontalDragStart: (_) => _onDragStart(index),
                            onHorizontalDragUpdate: (details) =>
                                _onGestureSlide(
                                    item.position == ButtonOriginalPosition.left
                                        ? details.delta.dx
                                        : -details.delta.dx,
                                    index),
                            onHorizontalDragEnd: (details) => _onGestureEnd(
                                details.velocity,
                                isSecond: item.position ==
                                    ButtonOriginalPosition.left),
                            child: Container(
                              height: 55,
                              alignment: Alignment.center,
                              width: screenWidth / 2 - 50,
                              decoration: BoxDecoration(
                                color: AppColors.btnBlack,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                item.language,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
