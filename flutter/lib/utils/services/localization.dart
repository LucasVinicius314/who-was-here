import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class Localization {
  static AppLocalizations string(BuildContext context) =>
      AppLocalizations.of(context)!;

  static DateFormat dateFormat(BuildContext context, [String? format]) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return DateFormat(format, languageCode);
  }

  static String formatDateDateShortMonth(
    BuildContext context,
    DateTime dateTime,
  ) =>
      dateFormat(context, 'yMMMd').format(dateTime);
}
