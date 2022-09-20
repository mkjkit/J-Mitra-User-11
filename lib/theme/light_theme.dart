import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'TitilliumWeb',
  primaryColor: Color(0xFF1B7FED),
  brightness: Brightness.light,
  highlightColor: Colors.white,
  hintColor: Color(0xFF000000),
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);