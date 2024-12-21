import 'package:flutter/material.dart';

class Design {
  final BuildContext context;

  Design(this.context);


  ColorScheme get colorScheme => Theme.of(context).colorScheme;


  Color get primary => colorScheme.primary; //black
  Color get secondary => colorScheme.secondary;//blue 
  Color get background => colorScheme.background;
  Color get surface => colorScheme.surface;
  Color get error => colorScheme.error; //red
  Color get onPrimary => colorScheme.onPrimary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get onBackground => colorScheme.onBackground;
  Color get onSurface => colorScheme.onSurface;
  Color get onError => colorScheme.onError;


  Map<String, Color> getErrorAttributes() {
    return {
      'error': error,
      'onError': onError,
    };
  }


  Map<String, Color> getAllColors() {
    return {
      'primary': primary,
      'secondary': secondary,
      'background': background,
      'surface': surface,
      'error': error,
      'onPrimary': onPrimary,
      'onSecondary': onSecondary,
      'onBackground': onBackground,
      'onSurface': onSurface,
      'onError': onError,
    };
  }
}
