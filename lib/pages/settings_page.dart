import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () {
            context.locale == const Locale("tr")
                ? context.setLocale(
                    const Locale("en"),
                  )
                : context.setLocale(
                    const Locale("tr"),
                  );
          },
          child: Text(context.locale.toString()),
        ),
      ),
    );
  }
}
