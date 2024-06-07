import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:g_translate_v2/core/configs/app_colors.dart';
import 'package:g_translate_v2/core/routing/app_navigator.dart';
import 'package:g_translate_v2/core/widgets/draggable_panel.dart';
import 'package:g_translate_v2/features/home/pages/widget/translate_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  /// route path
  static const String path = '/home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final size = ScreenUtil();
  final panelCtrl = PanelController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (panelCtrl.isPanelOpen) {
          await panelCtrl.close();
          return;
        }
        appNavigator.back();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundGray,
        body: SizedBox(
          width: size.screenWidth,
          height: size.screenHeight,
          child: Stack(
            children: [
              /// bottom
              Positioned(
                bottom: 0,
                child: SizedBox(
                  height: 480.h,
                  width: size.screenWidth,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: [
                        Buttons(),
                      ],
                    ),
                  ),
                ),
              ),

              /// panel
              DraggablePanel(
                controller: panelCtrl,
                color: AppColors.backgroundBlack,
                slideDirection: SlideDirection.down,
                maxHeight: size.screenHeight - 50.h,
                minHeight: size.screenHeight - 480.h,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(28),
                  bottomLeft: Radius.circular(28),
                ),

                /// list of the history translations
                collapsed: SizedBox(
                  width: size.screenWidth,
                  height: 400,
                ),

                /// enter text label
                panel: Container(),
                panelBuilder: (sc) => Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
