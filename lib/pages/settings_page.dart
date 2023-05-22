import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/cache/shared_manager.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/locator.dart';
import 'package:movie_app/providers/theme/theme_data_provider.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/switch_for_settings.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late SharedAbstract _sharedAbstract;
  bool _isChange = false;
  bool _isShould = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _sharedAbstract = locator<SharedAbstract>();
    _initShared();
  }

  Future<void> _initShared() async {
    await _sharedAbstract.init();
    _getDefaultShould();
  }

  Future<void> _getDefaultShould() async {
    _onChangedValue(_sharedAbstract.getItem(SharedKeys.shouldWatch) ?? false);
  }

  void _onChangedValue(bool value) {
    setState(() {
      _isShould = value;
    });
    _changeShould(value);
  }

  Future<void> _changeShould(bool value) async {
    await _sharedAbstract.setItem(SharedKeys.shouldWatch, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: Style.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ayarlar',
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Style.defaultPaddingSize, bottom: Style.defaultPaddingSize / 2),
                child: SwitchForSettings(
                  subTitle: LocaleKeys.change_language.tr(),
                  text: context.locale.languageCode == LanguageCodes.tr.name ? 'Türkçe' : 'English',
                  value: context.locale.languageCode == LanguageCodes.tr.name ? true : false,
                  onChanged: (value) {
                    context.locale == const Locale("tr")
                        ? context.setLocale(
                            const Locale("en"),
                          )
                        : context.setLocale(
                            const Locale("tr"),
                          );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (context.read<ThemeDataProvider>().brightness == Brightness.light ||
                            context.read<ThemeDataProvider>().brightness == null)
                        ? LocaleKeys.light_mode.tr()
                        : LocaleKeys.dark_mode.tr(),
                    style: context.textThemeContext().titleMedium,
                  ),
                  InkWell(
                    onTap: () {
                      _onChangeTheme();
                    },
                    child: Lottie.asset(
                      'assets/lottie/theme_change.json',
                      repeat: false,
                      width: 60,
                      reverse: true,
                      controller: _animationController,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Style.defaultPaddingSize / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchForSettings(
                      subTitle: LocaleKeys.should_watch.tr(),
                      text: LocaleKeys.movie_recommendation.tr(),
                      value: _isShould ? true : false,
                      onChanged: (value) {
                        _onChangedValue(value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onChangeTheme() {
    _isChange = !_isChange;
    context.read<ThemeDataProvider>().setThemeData(
          _isChange ? true : false,
        );
    _animationController.animateTo(_isChange ? 0.5 : 0.0);
  }
}
