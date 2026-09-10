import 'package:fitsho/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension AppLocalizationHelper on BuildContext {
  AppLocalizations get tr => AppLocalizations.of(this);
}

AppLocalizations currentAppLocalizations([Locale? locale]) {
  try {
    final target = locale ?? const Locale('fa', 'IR');
    return lookupAppLocalizations(target);
  } on Object {
    return lookupAppLocalizations(const Locale('fa'));
  }
}
