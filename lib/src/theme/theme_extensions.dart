// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ColorsExtension extends ThemeExtension<ColorsExtension> {
  const ColorsExtension({
    this.backgroundColor,
    this.textColor,
    this.textWhiteColor,
    this.defaultCardColor,
    this.redSpeciesColor,
    this.greenSpeciesColor,
    this.blueSpeciesColor,
    this.pokeballColor,
  });

  final Color? backgroundColor;
  final Color? textColor;
  final Color? textWhiteColor;
  final Color? defaultCardColor;
  final Color? redSpeciesColor;
  final Color? greenSpeciesColor;
  final Color? blueSpeciesColor;
  final Color? pokeballColor;

  @override
  ThemeExtension<ColorsExtension> copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? textWhiteColor,
    Color? defaultCardColor,
    Color? redSpeciesColor,
    Color? greenSpeciesColor,
    Color? blueSpeciesColor,
    Color? pokeballColor,
  }) {
    return ColorsExtension(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      textWhiteColor: textWhiteColor ?? this.textWhiteColor,
      defaultCardColor: defaultCardColor ?? this.defaultCardColor,
      redSpeciesColor: redSpeciesColor ?? this.redSpeciesColor,
      greenSpeciesColor: greenSpeciesColor ?? this.greenSpeciesColor,
      blueSpeciesColor: blueSpeciesColor ?? this.blueSpeciesColor,
      pokeballColor: pokeballColor ?? this.pokeballColor,
    );
  }

  @override
  ThemeExtension<ColorsExtension> lerp(
    covariant ThemeExtension<ColorsExtension>? other,
    double t,
  ) {
    if (other is! ColorsExtension) return this;
    return ColorsExtension(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      textWhiteColor: Color.lerp(textWhiteColor, other.textWhiteColor, t),
      defaultCardColor: Color.lerp(defaultCardColor, other.defaultCardColor, t),
      redSpeciesColor: Color.lerp(redSpeciesColor, other.redSpeciesColor, t),
      greenSpeciesColor:
          Color.lerp(greenSpeciesColor, other.greenSpeciesColor, t),
      blueSpeciesColor: Color.lerp(blueSpeciesColor, other.blueSpeciesColor, t),
      pokeballColor: Color.lerp(pokeballColor, other.pokeballColor, t),
    );
  }
}
