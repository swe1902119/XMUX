import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xmux/config.dart';
import 'package:xmux/initapp/init.dart';
import 'package:xmux/mainapp/HomePage.dart';
import 'package:xmux/mainapp/academic/gpacalculator.dart';
import 'package:xmux/mainapp/academic/wolframengine/inputconstructor.dart';
import 'package:xmux/mainapp/explore/lostandfound/lostandfoundpage.dart';
import 'package:xmux/mainapp/settings/me.dart';
import 'package:xmux/mainapp/payment.dart';
import 'package:xmux/translations/translation.dart';

class MainApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'XMUX',
      home: new HomePage(),
      theme: defaultTheme,
      routes: <String, WidgetBuilder>{
        "/wolframengine/constructor": (BuildContext context) =>
        new InputConstructor(),
        "/acdemic/gpacalculator": (BuildContext context) =>
        new GPACalculatorPage(),
        "/me": (BuildContext context) => new MePage(),
        "/drawer/epayment": (BuildContext context) =>
        new PaymentPage(globalCalendarState.paymentData),
        "/explore/lostandfound": (BuildContext context) =>
        new LostAndFoundPage(),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        MainLocalizationsDelegate.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CN'),
        const Locale('en', 'US'),
      ],
    );
  }
}