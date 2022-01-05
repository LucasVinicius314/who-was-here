import 'package:flutter/material.dart';
import 'package:who_was_here/constants/colors.dart';
import 'package:who_was_here/constants/constants.dart';
import 'package:who_was_here/models/main_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: ExtendedColors.jet,
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Poppins'),
      ),
      routes: {
        MainPage.route: (context) => const MainPage(),
      },
    );
  }
}
