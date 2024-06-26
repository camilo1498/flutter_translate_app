import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:g_translate_v2/core/configs/app_colors.dart';
import 'package:g_translate_v2/core/constants/languages.dart';
import 'package:g_translate_v2/core/routing/app_navigator.dart';
import 'package:g_translate_v2/features/home/logic/translate_button_controller_state.dart';
import 'package:g_translate_v2/features/home/models/translate_button_model.dart';
import 'package:g_translate_v2/features/language_selector/pages/language_selector_page.dart';

class TranslateButtonWidget extends ConsumerStatefulWidget {
  const TranslateButtonWidget({
    super.key,
    required this.index,
    required this.item,
    required this.transitionValue,
  });

  final int index;
  final TranslateButtonModel item;
  final double transitionValue;

  @override
  ConsumerState<TranslateButtonWidget> createState() =>
      _TranslateButtonWidgetState();
}

const itemHeight = 55.0;
const indicatorVPadding = -((itemHeight - itemHeight) / 2);

final names = LanguagesList.languageList
    .where(
      (item) => ['es', 'en', 'more-lang'].contains(item.code),
    )
    .toList();

class _TranslateButtonWidgetState extends ConsumerState<TranslateButtonWidget>
    with SingleTickerProviderStateMixin {
  ///||-- Variables --||///
  bool isButtonTap = false;
  bool showIndicator = true;
  double indicatorOffset = 55;

  late final Animation<double> _overlayFadeAnimation;

  ///||-- Keys --||///
  final GlobalKey widgetKey = GlobalKey();
  final GlobalKey overlayKey = GlobalKey();
  final LayerLink _layerLinks = LayerLink();

  ///||-- Controllers --||///
  /// overlay ctrl
  final OverlayPortalController _overlayController = OverlayPortalController();
  late final AnimationController _overlayAnimationController;

  @override
  void initState() {
    // Initialize overlay animation classes
    _overlayAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _overlayFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _overlayAnimationController, curve: Curves.easeOut),
    );
    super.initState();
  }

  ///||-- Overlay methods --||///
  Widget _buildOverlayMenu() {
    RenderBox? renderBox =
        widgetKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    final offset = renderBox?.localToGlobal(Offset.zero);

    return Stack(
      children: [
        Positioned(
          left: (offset?.dx ?? 0) - 4,
          top: (offset?.dy ?? 0) -
              (itemHeight * (names.length <= 3 ? 1 : (names.length - 2))) -
              4,
          child: FadeTransition(
            opacity: _overlayFadeAnimation,
            child: TweenAnimationBuilder(
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 200),
              tween: Tween<Alignment>(
                begin: Alignment.center,
                end: const Alignment(0.0, -4),
              ),
              builder: (context, value, child) => TweenAnimationBuilder(
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 200),
                tween: Tween<double>(begin: 1.0, end: 1.0),
                builder: (context, value, child) => Container(
                  alignment: Alignment.center,
                  key: overlayKey,
                  width: (size?.width ?? 0) + 8,
                  height: (((size?.height ?? 0) * names.length) + 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: AppColors.overlayBackgroundGray,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linearToEaseOut,
                        top: indicatorOffset + 4,
                        left: 4,
                        height: itemHeight,
                        child: Container(
                          width: size?.width,
                          decoration: BoxDecoration(
                            color: AppColors.btnBlue,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            names.length,
                            (index) => Container(
                                height: itemHeight,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                // color: Colors.blue,
                                child: Text(
                                  names[index].name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    isButtonTap = true;
    if (!_overlayController.isShowing) {
      _overlayController.show();
      HapticFeedback.mediumImpact();
      _overlayAnimationController.forward();
      indicatorOffset =
          names.length <= 3 ? 55 : indicatorOffset * (names.length - 2);
      setState(() {});
    }
  }

  void _handleLongPressEndOrCancel() {
    isButtonTap = false;
    _overlayAnimationController.reverse().then(
      (value) {
        final index = (indicatorOffset / itemHeight).toInt();
        if (index == names.length - 1) {
          appNavigator.pushNamed(
            context: context,
            arguments: widget.item,
            page: LanguageSelectorPage.path,
          );
        } else {
          final ctrl = ref.read(translateButtonsController.notifier);
          ctrl.updateLanguage(widget.item, names[index]);
        }

        _overlayController.hide();
        indicatorOffset = 55;
        setState(() {});
      },
    );
  }

  void _handleLongPressDown(LongPressDownDetails details) {
    HapticFeedback.lightImpact();
    _overlayAnimationController.reverse().then((value) {
      _overlayController.hide();
      indicatorOffset = 55;
    });
  }

  double previousIndicatorOffset = -1.0;
  void _handlePointerMove(LongPressMoveUpdateDetails event) {
    final box = overlayKey.currentContext?.findRenderObject() as RenderBox?;
    final localPosition = event.localPosition;
    if (box != null) {
      final compositedPosition =
          localPosition + Offset(0, box.size.height - 110);
      final isInsideHeight = compositedPosition.dy >= 0.0 &&
          compositedPosition.dy < box.size.height;

      /// Handle indicator movement
      if (isInsideHeight) {
        final realtimeIndicatorOffset =
            (compositedPosition.dy - (itemHeight / 2)).clamp(
          indicatorVPadding,
          (itemHeight * (names.length - 1)) + indicatorVPadding,
        );
        final activeIndex = (realtimeIndicatorOffset / itemHeight).round();
        final newIndicatorOffset =
            (itemHeight * activeIndex) - indicatorVPadding;

        setState(() {
          indicatorOffset = newIndicatorOffset;
        });

        if (newIndicatorOffset % 55 == 0 &&
            newIndicatorOffset != previousIndicatorOffset) {
          HapticFeedback.mediumImpact();
          previousIndicatorOffset = newIndicatorOffset;
        } else if (newIndicatorOffset % 55 != 0) {
          previousIndicatorOffset = -1.0;
        }
      }
    }
  }

  /// widget
  @override
  Widget build(BuildContext context) {
    final double screenWidth = ScreenUtil().screenWidth;
    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (context) => CompositedTransformFollower(
        link: _layerLinks,
        child: _buildOverlayMenu(),
      ),
      child: Transform.scale(
        scale: widget.index == 1
            ? 1
            : 1 - 0.35 * (1 - widget.transitionValue.abs()),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPressDown: _handleLongPressDown,
          onLongPressMoveUpdate: _handlePointerMove,
          onLongPressEnd: (details) => _handleLongPressEndOrCancel(),
          onLongPressStart: (details) => _handleLongPressStart(details),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            key: widgetKey,
            height: 55,
            alignment: Alignment.center,
            width: screenWidth / 2 - 50,
            decoration: BoxDecoration(
              color: isButtonTap ? AppColors.btnBlue : AppColors.btnBlack,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '${widget.item.value}\n${widget.item.language.name}',
              textAlign: TextAlign.center,
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
  }
}
