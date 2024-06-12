import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:g_translate_v2/core/configs/app_colors.dart';
import 'package:g_translate_v2/features/home/pages/widget/translate_buttons.dart';

class ButtonsT extends StatefulWidget {
  const ButtonsT({
    super.key,
    required this.index,
    required this.item,
    required this.transitionValue,
    required this.onDragStart,
    required this.onHorizontalDragEnd,
    required this.onHorizontalDragUpdate,
    required this.onHorizontalDragStart,
  });

  final int index;
  final ItemModel item;
  final double transitionValue;

  final VoidCallback onDragStart;
  final void Function(DragEndDetails)? onHorizontalDragEnd;
  final void Function(DragUpdateDetails)? onHorizontalDragUpdate;
  final void Function(DragStartDetails)? onHorizontalDragStart;

  @override
  State<ButtonsT> createState() => _ButtonsTState();
}

const itemHeight = 55.0;
const menuItemsMaxScale = 1;
const indicatorHeight = itemHeight * menuItemsMaxScale;
const maxDistance = itemHeight / 2 + indicatorHeight / 2;
const indicatorVPadding = -((itemHeight * menuItemsMaxScale - itemHeight) / 2);
const maxStretchDistance = 200;
const names = [
  'Inglés',
  'Español',
  'Portugués',
  'Francés',
  'Japonés',
  'Alemán',
  'Ruso',
  'Chino',
  'Más idiomas',
];

class _ButtonsTState extends State<ButtonsT>
    with SingleTickerProviderStateMixin {
  ///||-- Variables --||///
  bool isButtonTap = false;
  bool showIndicator = true;
  double indicatorOffset = 55;

  late final Animation<double> _overlayFadeAnimation;

  ///||-- --||///
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
                      ActionMenuIndicator(
                        width: size?.width,
                        offset: indicatorOffset,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            names.length,
                            (index) => ActionMenuListItem(
                              label: names[index],
                              index: index,
                              scale: 1.0,
                            ),
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

  RenderBox? _getMenuRenderBox() {
    return overlayKey.currentContext?.findRenderObject() as RenderBox?;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    RenderBox? box = _getMenuRenderBox();
    final localPosition = event.localPosition;
    if (box != null) {
      final compositedPosition =
          localPosition + Offset(0, box.size.height - 110);
      final isInsideHeight = compositedPosition.dy >= 0.0 &&
          compositedPosition.dy < box.size.height;

      /// Handle indicator movement
      if (isInsideHeight) {
        if (!showIndicator) setState(() => showIndicator = true);
        final realtimeIndicatorOffset =
            (compositedPosition.dy - (itemHeight * menuItemsMaxScale / 2))
                .clamp(indicatorVPadding,
                    (itemHeight * (names.length - 1)) + indicatorVPadding);
        final activeIndex = (realtimeIndicatorOffset / itemHeight).round();
        setState(() {
          indicatorOffset = (itemHeight * activeIndex) - -indicatorVPadding;
        });
      }
    }
  }

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
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerMove: _handlePointerMove,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onDragStart,

            ///
            onLongPressStart: (details) => _handleLongPressStart(details),
            onLongPressEnd: (details) => _handleLongPressEndOrCancel(),
            onLongPressCancel: _handleLongPressEndOrCancel,
            onLongPressDown: _handleLongPressDown,

            ///
            onHorizontalDragEnd: widget.onHorizontalDragEnd,
            onHorizontalDragStart: widget.onHorizontalDragStart,
            onHorizontalDragUpdate: widget.onHorizontalDragUpdate,
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
                widget.item.language,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ActionMenuButton extends StatelessWidget {
  const ActionMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      height: 60,
      width: 60,
      child: Icon(
        CupertinoIcons.share_solid,
        color: Colors.black.withOpacity(0.5),
        size: 30,
      ),
    );
  }
}

class ActionMenuListItem extends StatelessWidget {
  const ActionMenuListItem({
    super.key,
    this.index = 0,
    required this.label,
    this.scale = 1.0,
  });

  final int index;
  final String label;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: itemHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        // color: Colors.blue,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}

class ActionMenuIndicator extends StatelessWidget {
  const ActionMenuIndicator({
    super.key,
    this.offset = 0,
    required this.width,
  });

  final double offset;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linearToEaseOut,
      top: offset + 4,
      left: 4,
      height: itemHeight,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.btnBlue,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
