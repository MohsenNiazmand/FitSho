import 'package:flutter/material.dart';
import 'package:fitsho/l10n/app_localizations.dart';

extension AppLocalizationHelper on BuildContext {
  AppLocalizations get tr => AppLocalizations.of(this);
}
