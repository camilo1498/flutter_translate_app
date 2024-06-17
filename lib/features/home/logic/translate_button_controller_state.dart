import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:g_translate_v2/features/home/logic/translate_button_controller.dart';
import 'package:g_translate_v2/features/home/models/translate_button_model.dart';

final translateButtonsController = StateNotifierProvider.autoDispose<
    TranslateButtonController, TranslateButtonState>((ref) {
  return TranslateButtonController();
});

///
@immutable
class TranslateButtonState {
  ///
  const TranslateButtonState({
    required this.items,
  });

  ///
  final List<TranslateButtonModel> items;

  static TranslateButtonState init() => const TranslateButtonState(
        items: [],
      );

  ///
  TranslateButtonState copyWith({
    List<TranslateButtonModel>? items,
  }) =>
      TranslateButtonState(
        items: items ?? this.items,
      );

  ///
  factory TranslateButtonState.fromJson(Map<String, dynamic> json) =>
      TranslateButtonState(
        items: json["items"],
      );

  ///
  Map<String, dynamic> toJson() => {
        "items": items,
      };
}
