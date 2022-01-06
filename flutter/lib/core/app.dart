import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:who_was_here/constants/colors.dart';
import 'package:who_was_here/constants/constants.dart';
import 'package:who_was_here/modules/main_page.dart';

// TODO: add qr code scanning
// TODO: add paste from clipboard feature

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      locale: const Locale('pt', ''),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: ExtendedColors.jet,
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Poppins'),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(24)),
          ),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('pt', ''),
      ],
      routes: {
        MainPage.route: (context) => const MainPage(),
      },
    );
  }
}
