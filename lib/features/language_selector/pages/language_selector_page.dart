import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:g_translate_v2/core/configs/app_colors.dart';
import 'package:g_translate_v2/core/constants/languages.dart';
import 'package:g_translate_v2/core/models/language_model.dart';
import 'package:g_translate_v2/core/routing/app_navigator.dart';
import 'package:g_translate_v2/features/home/logic/translate_button_controller_state.dart';
import 'package:g_translate_v2/features/home/models/translate_button_model.dart';

class LanguageSelectorPage extends ConsumerStatefulWidget {
  const LanguageSelectorPage({super.key});

  /// route path
  static const String path = '/language-selector-page';

  @override
  ConsumerState<LanguageSelectorPage> createState() =>
      _LanguageSelectorPageState();
}

class _LanguageSelectorPageState extends ConsumerState<LanguageSelectorPage> {
  List<LanguageModel> languages = [];
  late TranslateButtonModel selectedItem;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      languages = LanguagesList.languageList;

      setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    selectedItem =
        ModalRoute.of(context)?.settings.arguments as TranslateButtonModel;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              /// language
              Text(selectedItem.toMap().toString()),
              10.verticalSpace,

              /// lang list
              ...languages.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      final ctrl =
                          ref.read(translateButtonsController.notifier);
                      ctrl.updateLanguage(selectedItem, item);

                      appNavigator.back(context: context);
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.btnBlue),
                      child: Text(
                        item.name,
                        style: TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
