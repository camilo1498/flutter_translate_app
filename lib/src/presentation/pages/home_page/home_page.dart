import 'package:flutter/material.dart';
import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/presentation/pages/history_page/history_page.dart';
import 'package:flutter_translator_app/src/presentation/pages/home_page/home_page_controller.dart';
import 'package:flutter_translator_app/src/presentation/providers/home_page_provider.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/panel.dart';
import 'package:flutter_translator_app/src/presentation/widgets/language_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class HomePage extends StatelessWidget {
  /// mediaQuery
  final ScreenUtil screenUtil = ScreenUtil();
  final HomePageController _homePageController = HomePageController();
  HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Consumer<HomePageProvider>(
      builder: (_, homeProvider, __){
        return Scaffold(
          backgroundColor: _homePageController.appColors.backgroundColor,
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size(screenUtil.screenWidth, 170.w),
            child: _appBar(appColors: _homePageController.appColors, homeProvider: homeProvider),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  width: screenUtil.screenWidth,
                  height: screenUtil.screenHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LanguageButton(
                              text: 'Spanish',
                              appColors: _homePageController.appColors,
                              onTap: (){
                                /// select translate "from"
                              }
                          ),
                          AnimatedOnTapButton(
                            onTap: (){
                              /// switch both languages
                            },
                            child: Icon(
                              Icons.compare_arrows,
                              color: _homePageController.appColors.iconColor2,
                              size: 60.w,
                            ),
                          ),
                          LanguageButton(
                              text: 'English',
                              appColors: _homePageController.appColors,
                              onTap: (){
                                /// select translate "to"
                              }
                          ),
                        ],
                      ),
                      80.verticalSpace,
                      _bottomBar(appColors: _homePageController.appColors)
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){},
                  child: StatefulBuilder(
                      builder: (context, setState){
                        return SlidingUpPanel(
                          controller: _homePageController.panelController,
                          color: ColorTween(
                              begin: _homePageController.appColors.containerColor,
                              end: _homePageController.appColors.backgroundColor
                          ).transform(homeProvider.opacity)!,
                          backdropColor: Colors.transparent,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30)
                          ),
                          onPanelSlide: (value){
                            setState(() {
                              homeProvider.opacityHistory = _homePageController.blockedOpacity - value;
                              homeProvider.opacity = value;
                              if(value <= 1.0 && value >= 0.55){
                                homeProvider.isPanelOpen = true;
                              } else{
                                homeProvider.isPanelOpen = false;
                              }
                            });
                          },
                          slideDirection: SlideDirection.DOWN,
                          panelBuilder: (ScrollController listController) {
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: _body(
                                context: context,
                                  appColors: _homePageController.appColors,
                                  homeProvider: homeProvider,
                                  listController: listController
                              ),
                            );

                          },

                          maxHeight: screenUtil.screenHeight - 256.h,
                          minHeight: 0.63.sh,
                          header: Container(
                            width: screenUtil.screenWidth,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 26.h),
                              child: Container(
                                height: 9.h,
                                width: 128.w,
                                decoration: BoxDecoration(
                                  color:  _homePageController.appColors.colorText2.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// appBar
  _appBar({
    required AppColors appColors,
    required HomePageProvider homeProvider,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 10),
      color: ColorTween(
          begin: appColors.containerColor,
          end: appColors.backgroundColor
      ).transform(homeProvider.opacity),
      child: !homeProvider.isPanelOpen ? AnimatedOpacity(
        duration: const Duration(milliseconds: 10),
        opacity: homeProvider.opacityHistory <= 1.0 && homeProvider.opacityHistory >= 0.45
            ? homeProvider.opacityHistory
            : 0,
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: AnimatedOnTapButton(
              onTap: (){
                /// open favourite page

              },
              child: Icon(
                Icons.star,
                color: Colors.white,
                size: 70.w,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 45.w),
              child: AnimatedOnTapButton(
                onTap: (){
                  /// open setting page

                },
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 70.w,
                ),
              ),
            ),
          ],
          title: RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Flutter ',
                    style: TextStyle(
                        color: appColors.colorText1,
                        fontWeight: FontWeight.w600,
                        fontSize: 53.w,
                        letterSpacing: 0.7,
                        fontFamily: GoogleFonts.comicNeue().fontFamily
                    ),
                  ),
                  TextSpan(
                      text: 'Translate',
                      style: TextStyle(
                          color: appColors.colorText2,
                          fontSize: 50.sp
                      )
                  )
                ]
            ),
          ),
        ),
      ) : AnimatedOpacity(
        duration: const Duration(milliseconds: 10),
        opacity: homeProvider.opacity <= 1.0 && homeProvider.opacity >= 0.5
            ? homeProvider.opacity
            : 0,
        child: HistoryPage().historyAppbar(onTap: () => _homePageController.closePanel()),
      ),
    );
  }

  /// Bottom row buttons
  _bottomBar({
    required AppColors appColors,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        _button(
            color: appColors.buttonColor2,
            icon: Icons.history,
            appColors: appColors,
            iconSize: 55.w,
            size: 135.w,
            text: 'History',
            onTap: () async => await _homePageController.openPanel()
        ),
        _button(
            color: appColors.buttonColor1,
            icon: Icons.mic_none_outlined,
            appColors: appColors,
            iconSize: 90.w,
            size: 250.w,
            onTap: (){
              /// translate from speech to text

            }
        ),
        _button(
            color: appColors.buttonColor2,
            icon: Icons.image_outlined,
            appColors: appColors,
            iconSize: 55.w,
            size: 135.w,
            text: 'Gallery',
            onTap: (){
              /// translate from image

            }
        )
      ],
    );
  }

  /// custom circle button
  Widget _button({
    required double size,
    required Color color, String? text,
    required IconData icon,
    required AppColors appColors,
    required double iconSize,
    required Function() onTap
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        children: [
          AnimatedOnTapButton(
            onTap: onTap,
            child: Container(
              height: size,
              width: size,
              padding: const EdgeInsets.all(3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        blurStyle: BlurStyle.inner,
                        offset: const Offset(0, 1.5)
                    )
                  ]
              ),
              child: Icon(
                icon,
                color: appColors.iconColor2,
                size: iconSize,
              ),
            ),
          ),
          20.verticalSpace,
          Text(
            text ?? '',
            style: TextStyle(
                color: appColors.colorText2,
                fontSize: 30.sp
            ),
          )
        ],
      ),
    );
  }





  Widget _body({
    required HomePageProvider homeProvider,
    required AppColors appColors,
    required ScrollController listController,
    required BuildContext context
  }){
    return GestureDetector(
      onTap: () => _homePageController.goToTranslationPage(context: context),
      child: !homeProvider.isPanelOpen ? Container(
        width: screenUtil.screenWidth,
        height: 0.63.sh,
        color: Colors.transparent,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 65.h),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 10),
              opacity: homeProvider.opacityHistory <= 1.0 && homeProvider.opacityHistory >= 0.5
                  ? homeProvider.opacityHistory
                  : 0,
              child: Text(
                'Enter Text',
                style: TextStyle(
                    color: appColors.colorText1.withOpacity(0.7),
                    fontSize: 80.sp
                ),
              ),
            ),
        ),
      ) : AnimatedOpacity(
          duration: const Duration(milliseconds: 10),
          opacity: homeProvider.opacity <= 1.0 && homeProvider.opacity >= 0.5
              ? homeProvider.opacity
              : 0,
          child: HistoryPage(listController: listController).historyBody()
      ),

    );
  }
}