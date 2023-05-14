import 'package:flutter/material.dart';
import 'package:movie_app/constants/util.dart';

abstract class CustomException implements Exception {
  abstract String title;
  abstract String subTitle;
  abstract void Function(BuildContext) onDialogDismiss;
  abstract StackTrace? trace;

  CustomException();

  factory CustomException.fromApiMessage(String apiMessage, {String? title, StackTrace? stackTrace}) {
    switch (apiMessage) {
      case "Failed host lookup: 'api.themoviedb.org'":
        return ApiException(
          title: 'E-Posta veya Şifre hatalı!',
          subTitle: 'Lütfen bilgilerinizi kontrol edip tekrar deneyin.',
          trace: stackTrace,
        );
    }
    return ApiException(
      title: title ?? 'Hata!',
      subTitle: apiMessage,
      trace: stackTrace,
    );
  }
  @override
  String toString() {
    return 'CustomException{title: $title, subTitle: $subTitle, onDialogDismiss: $onDialogDismiss}';
  }
}

class ApiException extends CustomException {
  ApiException({
    this.title = 'Sunucuyle iletişimde bir hata oluştu.',
    this.subTitle =
        'Sunucu ile iletişimde bir hata meydana geldi. İşlemi tekrar deneyiniz, çözüm bulamazsanız lütfen destek ekibimiz ile iletişime geçerek veya geribildirimde bulunarak hatayı bildiriniz.',
    onDialogDismiss,
    this.trace,
  }) {
    this.onDialogDismiss = onDialogDismiss ??
        (context) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Util.exitApp();
          }
        };
  }

  factory ApiException.fromMessage({
    required String title,
    required String message,
    onDialogDismiss,
    StackTrace? stackTrace,
  }) {
    return ApiException(
      title: title,
      subTitle: message,
      trace: stackTrace,
      onDialogDismiss: onDialogDismiss,
    );
  }

  @override
  late void Function(BuildContext p1) onDialogDismiss;

  @override
  String subTitle;

  @override
  String title;

  @override
  StackTrace? trace;
}
