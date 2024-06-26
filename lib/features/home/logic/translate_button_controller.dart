import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:g_translate_v2/core/constants/languages.dart';
import 'package:g_translate_v2/core/models/language_model.dart';
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
    state = state.copyWith(
      items: [
        TranslateButtonModel(
          value: -1,
          originalPosition: ButtonOriginalPosition.left,
          source: ButtonTranslationSr.sl,
          language: LanguagesList.languageList.firstWhere(
            (item) => item.code == 'en',
          ),
        ),
        TranslateButtonModel(
          value: 1.0,
          originalPosition: ButtonOriginalPosition.right,
          source: ButtonTranslationSr.tl,
          language: LanguagesList.languageList.firstWhere(
            (item) => item.code == 'es',
          ),
        ),
      ],
    );
  }

  void onGestureSlide(
    double dx,
    int index,
  ) {
    final itemValue = state.items[index].value;

    double newValue = animCtrl.value +
        (index == 0 ? -dx : dx) / ((ScreenUtil().screenWidth / 2) - 80).abs();

    if (itemValue != newValue) {
      animCtrl.value = newValue;

      // Actualizar los valores de los ítems
      state = state.copyWith(
        items: state.items.map((item) {
          if (item.originalPosition == ButtonOriginalPosition.left) {
            return item.copyWith(value: newValue);
          } else {
            return item.copyWith(value: -newValue);
          }
        }).toList(),
      );
    }
  }

  ///
  void onGestureEnd(Velocity velocity, TranslateButtonModel item) {
    final screenWidth = (ScreenUtil().screenWidth / 2) - 80;
    final double visualVelocity = (item.value > 0
            ? velocity.pixelsPerSecond.dx
            : -velocity.pixelsPerSecond.dx) /
        screenWidth;
    final double maxD = 1 + item.value;
    final double minD = 1 - item.value;
    final double minDistance = min(maxD, minD);

    if (item.value >= -1.0 && item.value <= 1.0) {
      if (velocity.pixelsPerSecond.dx.abs() >= screenWidth) {
        animCtrl.fling(velocity: visualVelocity);

        final double newValue = animCtrl.value +
            (item.value > 0
                    ? velocity.pixelsPerSecond.dx
                    : -velocity.pixelsPerSecond.dx) /
                (screenWidth - 80).abs();
        state = state.copyWith(
          items: state.items.map((i) {
            final value = i.originalPosition == ButtonOriginalPosition.left
                ? newValue
                : -newValue;
            return i.copyWith(value: value);
          }).toList(),
        );
      } else {
        _flingButtonToPosition(
            minDistance == maxD ? -1.0 : 1.0, -visualVelocity);
      }
    }

    state = state.copyWith(
      items: state.items.map((i) {
        final newValue = i.value > 0 ? 1.0 : -1.0;
        final source =
            i.value < 0 ? ButtonTranslationSr.sl : ButtonTranslationSr.tl;
        return i.copyWith(value: newValue, source: source);
      }).toList(),
    );
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

  void updateLanguage(
      TranslateButtonModel selectedItem, LanguageModel newLanguage) {
    final oldLanguage = selectedItem.language;

    state = state.copyWith(
      items: state.items.map((item) {
        if (item == selectedItem) {
          return item.copyWith(language: newLanguage);
        } else if (item.language == newLanguage) {
          return item.copyWith(language: oldLanguage);
        }
        return item;
      }).toList(),
    );
  }
}
