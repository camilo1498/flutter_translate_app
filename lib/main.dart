import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translator_app/src/presentation/pages/home_page/home_page.dart';
import 'package:flutter_translator_app/src/presentation/providers/home_page_provider.dart';
import 'package:flutter_translator_app/src/presentation/providers/translate_page_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true;
  /// force portrait mode
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  /// hide bottom navigation bar in android
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //     overlays: [SystemUiOverlay.top]);

  /// force transparent top bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomePageProvider()),
        ChangeNotifierProvider(create: (_) => TranslatePageProvider())
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () => MaterialApp(
          title: 'Flutter translate app',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.red,
              fontFamily: GoogleFonts.notoSans().fontFamily
          ),
          home: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll){
              overscroll.disallowIndicator();
              return false;
            },
            child: HomePage(),
          )
      ),
    );
  }
}
/*  final translator = GoogleTranslator();
  final LanguagesList _languagesList = LanguagesList();
  List<LanguageCode> _languages = [];
  String from = '';
  String to = '';
  String translated = '';
  String text = 'this is an text example';

  Future<List<LanguageCode>> getLanguages() async{
    for(var lang in _languagesList.languageList){
      _languages.add(LanguageCode.fromJson(lang));
    }
    return _languages;
  }

  setLanguage({required String code}) async{
     translator.translate(text, from: 'en', to: code).then((value) {
       setState(() {
         translated = value.text;
       });
     }).onError((error, stackTrace) {
       setState(() {
         translated = 'Language not supported';
       });
     });
  }
*/
/*Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Text => $text'
                      ),
                      Text(
                          'Translated => ${translated.toString()}'
                      ),
                    ],
                  )
                ),
              ),
              FutureBuilder<List<LanguageCode>>(
                future: getLanguages(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index){
                          return GestureDetector(
                            onTap: () async => setLanguage(code: snapshot.data![index].code.toString()),
                            child: ListTile(
                              title: Text(
                                  snapshot.data![index].language.toString()
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else{
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      )*/
