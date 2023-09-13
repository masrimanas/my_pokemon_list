import 'package:flutter/material.dart';
import 'package:my_pokemon_list/src/theme/color_palette.dart';

final customAppTheme = ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white,
    backgroundColor: Colors.transparent,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
  extensions: const [customColors],
  scaffoldBackgroundColor: customColors.backgroundColor,
  tabBarTheme: const TabBarTheme(
    indicatorColor: Colors.blueAccent,
    labelColor: Colors.black,
    unselectedLabelColor: Colors.grey,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: Colors.blueAccent,
      ),
    ),
  ),
);
