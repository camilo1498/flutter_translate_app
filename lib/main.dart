import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:g_translate_v2/core/routing/app_routes.dart';
import 'package:g_translate_v2/features/home/pages/home_page.dart';
import 'package:hive_local_storage/hive_local_storage.dart';

void main() async {
  /// return an instance of the binding that implements widgetsBinding
  WidgetsFlutterBinding.ensureInitialized();

  /// block system UI device orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// set system IU appbar color
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  /// hive instances
  /// TODO box service initialization
  /// final initializeBoxService = BoxServiceImp();
  /// hive initialization
  await Hive.initFlutter();

  /// todo initialize box service
  /// initializeBoxService.init();
  ///  override river pod containers
  final boxContainerProvider = ProviderContainer(
    overrides: [
      /// BoxServiceProvider.overrideValue(boxContainerProvider),
    ],
  );

  /// initialize screenUtil
  await ScreenUtil.ensureScreenSize();

  /// run app
  runApp(UncontrolledProviderScope(
    container: boxContainerProvider,
    child: const FlutterTranslateApp(),
  ));
}

class FlutterTranslateApp extends StatelessWidget {
  const FlutterTranslateApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        ensureScreenSize: true,
        useInheritedMediaQuery: true,
        designSize: const Size(1080, 1920),
        builder: (_, __) => MaterialApp(
          routes: AppRoutes.routes,
          title: 'Flutter translator',
          //TODO initialRoute: , => create splash screen

          initialRoute: HomePage.path,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),

          /// TODO onUnknownRoute (404) => create page
        ),
      ),
    );
  }
}
