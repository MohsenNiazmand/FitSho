import 'package:flutter/material.dart';

import 'package:fitsho/l10n/app_localizations.dart';

extension AppLocalizationHelper on BuildContext {
  AppLocalizations get tr => AppLocalizations.of(this);
}

AppLocalizations currentAppLocalizations([Locale? locale]) {
  try {
    final target = locale ?? WidgetsBinding.instance.platformDispatcher.locale;
    return lookupAppLocalizations(target);
  } on Object {
    return lookupAppLocalizations(const Locale('fa'));
  }
}
