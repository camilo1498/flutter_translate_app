import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:g_translate_v2/features/home/logic/translate_button_controller_state.dart';
import 'package:g_translate_v2/features/home/models/translate_button_model.dart';

///
class TranslateButtonController extends StateNotifier<TranslateButtonState> {
  ///
  TranslateButtonController() : super(TranslateButtonState.init());

  late AnimationController animCtrl;

  ///
  void updateInitValues({
    required TickerProvider vsync,
    required VoidCallback callback,
  }) {
    animCtrl = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
      value: -1.0,
      upperBound: 1.0,
      lowerBound: -1.0,
    )..addListener(callback);
    double left = ScreenUtil().screenWidth / 1.945;
    state = state.copyWith(
      items: [
        TranslateButtonModel(
          value: -1,
          originalPosition: ButtonOriginalPosition.left,
          translationPosition: ButtonOriginalPosition.left,
          language: 'Inglés',
        ),
        TranslateButtonModel(
          value: left,
          originalPosition: ButtonOriginalPosition.right,
          translationPosition: ButtonOriginalPosition.right,
          language: 'Español',
        ),
      ],
    );
  }

  ///
  void onGestureSlide(
    double dx,
    int index,
  ) {
    double newValue = animCtrl.value +
        (index == 0 ? -dx : dx) / ((ScreenUtil().screenWidth / 2) - 80).abs();

    if (newValue > -1.0 && newValue < 1.0 && animCtrl.value != newValue) {
      animCtrl.value = newValue;
    }
  }

  ///
  void onGestureEnd(Velocity velocity, ButtonOriginalPosition position) {
    /// TODO: fix de position => Left (+velocity) Right (-velocity)
    double visualVelocity =
        -velocity.pixelsPerSecond.dx / ((ScreenUtil().screenWidth / 2));
    double maxD = animCtrl.value + 1;
    double minD = 1 - animCtrl.value;
    double minDistance = min(maxD, minD);

    if (velocity.pixelsPerSecond.dx.abs() >= ((ScreenUtil().screenWidth / 2))) {
      animCtrl.fling(
        velocity: -visualVelocity,
      );
    } else {
      _flingButtonToPosition(
        minDistance == maxD ? -1.0 : 1.0,
        visualVelocity,
      );
    }
  }

  ///
  void _flingButtonToPosition(
    double targetPos,
    double velocity,
  ) {
    animCtrl.animateWith(
      SpringSimulation(
        SpringDescription.withDampingRatio(
          mass: 1.0,
          ratio: 1.5,
          stiffness: 100.0,
        ),
        animCtrl.value,
        targetPos,
        velocity * 0.1,
      ),
    );
  }

  ///
  void onDragStart(int index) {
    final items = state.items;
    final item = items.removeAt(index);
    items.insert(1, item);
  }
}
