import 'package:flutter/material.dart';

///Class containing all the color scheme for the app, as well as style of fonts.
abstract class AppTheme {
  //COLORS used by the app:
  ///Background Color; used for unaccentuated widgets
  static const Color bgColor = Color.fromARGB(255, 255, 240, 230);
  ///Background Color; used for accentuated widgets (such as buttons)
  static const Color secondaryBgColor = Color.fromARGB(255, 255, 202, 181);
  ///Splash bg color for Inwells and MaterialButtons
  static const Color splashColor = Color.fromARGB(255, 255, 173, 133);

  ///Logo for the app
  static final Widget logo = Container(
    width: 105.0,
    height: 50.0, 
    child: Center(child: Image.asset('assets/images/logo.png'))
  );

  ///Primary text theme: headings and paragraphs
  static const Color primary = Color.fromARGB(255, 148, 124, 87);
  ///Secondary text theme: buttons
  static const Color secondary = Color.fromARGB(255, 89, 70, 39);

  //Text-styles:
  /// Heading one, style used for titles
  static const TextStyle headingOne = TextStyle(
    color: primary,
    fontSize: 25.0,
    fontWeight: FontWeight.w300,
  );

  /// Text style used for dialog boxes
  static const TextStyle dialog = TextStyle(
    color: primary,
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
  );

  /// Dialog boxes text style, but lighter
  static const TextStyle dialogLight = TextStyle(
    color: primary,
    fontSize: 20.0,
    fontWeight: FontWeight.w300,
  );

  ///Counter Text, style used for the counter on-screen
  static const TextStyle counterText = TextStyle(
    color: primary,
    fontSize: 75.0,
    fontWeight: FontWeight.w400,
  );
  
  ///Style used on MaterialButtons and alike
  static const TextStyle button = TextStyle(
    color: secondary,
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
  );
}