import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:g_translate_v2/features/home/logic/translate_button_controller_state.dart';
import 'package:g_translate_v2/features/home/models/translate_button_model.dart';
import 'package:g_translate_v2/features/home/pages/widget/translate_button_widget.dart';

class SelectLanguageSection extends ConsumerStatefulWidget {
  const SelectLanguageSection({super.key});

  @override
  ConsumerState<SelectLanguageSection> createState() =>
      _SelectLanguageSectionState();
}

class _SelectLanguageSectionState extends ConsumerState<SelectLanguageSection>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = ref.read(translateButtonsController.notifier);
      ctrl.updateInitValues(vsync: this, callback: () => setState(() {}));
    });
  }

  @override
  void dispose() {
    if (!mounted) return;
    final ctrl = ref.read(translateButtonsController.notifier);
    ctrl.animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = ScreenUtil().screenWidth;
    final ctrl = ref.read(translateButtonsController.notifier);
    final items = ref.watch(
      translateButtonsController.select((state) => state.items),
    );

    /// Widget
    return SizedBox(
      height: 80,
      width: screenWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              ctrl.animCtrl.isCompleted
                  ? ctrl.animCtrl.reverse()
                  : ctrl.animCtrl.fling();
            },
            child: Container(
              width: 60.w,
              height: 60.w,
              color: Colors.white,
            ),
          ),
          ...items.map((item) {
            final index = items.indexOf(item);

            double left =
                (screenWidth / 2 * ctrl.animCtrl.value + screenWidth / 2) /
                    1.945;

            return Positioned(
              left: item.originalPosition == ButtonOriginalPosition.left
                  ? left
                  : screenWidth / 1.945 - left,
              child: GestureDetector(
                onTap: () {
                  print(item.toMap());
                },
                onHorizontalDragStart: (_) => ctrl.onDragStart(index),
                onHorizontalDragUpdate: (details) => ctrl.onGestureSlide(
                  item.originalPosition == ButtonOriginalPosition.left
                      ? details.delta.dx
                      : -details.delta.dx,
                  index,
                ),
                onHorizontalDragEnd: (details) => ctrl.onGestureEnd(
                  details.velocity,
                  item,
                ),
                child: TranslateButtonWidget(
                  index: index,
                  item: item,
                  transitionValue: ctrl.animCtrl.value,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
