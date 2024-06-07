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
        backgroundColor: AppColors.black,
        body: SizedBox(
          width: size.screenWidth,
          height: size.screenHeight,
          child: Stack(
            children: [
              /// bottom
              Positioned(
                bottom: 0,
                child: Container(
                  height: 500.h,
                  width: size.screenWidth,
                  color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    child: Buttons(),
                  ),
                ),
              ),

              /// panel
              DraggablePanel(
                color: Colors.blue,
                controller: panelCtrl,
                slideDirection: SlideDirection.down,
                maxHeight: size.screenHeight - 480.h,
                minHeight: size.screenHeight * 0.6.h,

                /// list of the history translations
                collapsed: Container(
                  width: size.screenWidth,
                  height: size.statusBarHeight,
                  color: Colors.yellow,
                  child: Text(
                    'collapsable',
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ),

                onPanelOpened: () {
                  print(panelCtrl.isPanelOpen);
                },

                /// enter text label
                panel: Container(
                  color: Colors.red,
                ),
                panelBuilder: (sc) => Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
