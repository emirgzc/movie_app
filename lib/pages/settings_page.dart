import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/theme/theme_data_provider.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  bool _isChange = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    ThemeDataProvider _themeProvider = Provider.of<ThemeDataProvider>(context);

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
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: SwitchFowSettings(
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
                    _themeProvider.brightness != Brightness.light ? LocaleKeys.dark_mode.tr() : LocaleKeys.light_mode.tr(),
                    style: context.textThemeContext().titleMedium,
                  ),
                  InkWell(
                    onTap: () {
                      _isChange = !_isChange;
                      _themeProvider.setThemeData(
                        _isChange ? true : false,
                      );
                      _animationController.animateTo(_isChange ? 0.5 : 0.0);
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
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SwitchFowSettings extends StatefulWidget {
  SwitchFowSettings({super.key, required this.value, required this.onChanged, required this.text});
  final bool value;
  final void Function(bool)? onChanged;
  final String text;

  @override
  State<SwitchFowSettings> createState() => _SwitchFowSettingsState();
}

class _SwitchFowSettingsState extends State<SwitchFowSettings> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.text,
          style: context.textThemeContext().titleMedium,
        ),
        Switch.adaptive(
          activeColor: Style.primaryColor,
          value: widget.value,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
