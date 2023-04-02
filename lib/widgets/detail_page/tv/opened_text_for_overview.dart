import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/translations/locale_keys.g.dart';

// ignore: must_be_immutable
class OpenedTextForOverview extends StatefulWidget {
  OpenedTextForOverview({
    super.key,
    required this.isOpenedText,
    required this.data,
  });
  bool isOpenedText;
  final String? data;

  @override
  State<OpenedTextForOverview> createState() => _OpenedTextForOverviewState();
}

class _OpenedTextForOverviewState extends State<OpenedTextForOverview> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Style.defaultPaddingSizeVertical / 2,
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Style.blackColor),
          children: [
            TextSpan(
              text: (widget.isOpenedText == true)
                  ? widget.data
                  : ((widget.data?.length ?? 0) > 210)
                      ? "${widget.data?.substring(0, 210)}..."
                      : ((widget.data?.isEmpty ?? false)
                          ? LocaleKeys
                              .no_description_text_entered_with_the_serie
                              .tr()
                          : widget.data),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    widget.isOpenedText = !widget.isOpenedText;
                  });
                },
              text: (widget.isOpenedText == false &&
                      (widget.data?.length ?? 0) > 210)
                  ? LocaleKeys.read.tr()
                  : "",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
