// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';

class SwitchForSettings extends StatefulWidget {
  SwitchForSettings({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
    required this.subTitle,
  });
  final bool value;
  final void Function(bool)? onChanged;
  final String text;
  final String subTitle;

  @override
  State<SwitchForSettings> createState() => _SwitchForSettingsState();
}

class _SwitchForSettingsState extends State<SwitchForSettings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        ),
        Text(
          widget.subTitle,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
