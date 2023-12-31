import 'package:flutter/material.dart';
import 'package:my_pokemon_list/src/theme/theme_extensions.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  ColorsExtension get colors => theme.extension<ColorsExtension>()!;
  Size get size => MediaQuery.of(this).size;
  double get height => size.height;
  double get width => size.width;
  double get aspectRatio => size.aspectRatio;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomBarHeight => MediaQuery.of(this).padding.bottom;
  Size get screenSize => MediaQuery.sizeOf(this);
  double responsive(double value) => screenSize.aspectRatio * value;
}
