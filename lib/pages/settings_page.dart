import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/style.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                  fontSize: 40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SwitchFowSettings(),
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
  SwitchFowSettings({super.key});

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
          context.locale.languageCode == LanguageCodes.tr.name ? 'Türkçe' : 'English',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Switch.adaptive(
          activeColor: Colors.red,
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
      ],
    );
  }
}
