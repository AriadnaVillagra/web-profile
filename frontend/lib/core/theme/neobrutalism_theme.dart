import 'package:flutter/material.dart';

class NeoColors {
  static const Color background = Color(
    0xFFFAF7F2,
  ); // Crema claro suave de fondo
  static const Color primary = Color(0xFFFF6B6B); // Rojo/Coral vibrante
  static const Color secondary = Color(0xFF4ECDC4); // Menta / Turquesa
  static const Color accent = Color(0xFFFFD166); // Amarillo neobrutalista
  static const Color purple = Color(0xFFA663CC); // Púrpura brillante
  static const Color border = Color(
    0xFF1E1E1E,
  ); // Negro casi puro para bordes y sombras
  static const Color cardBg = Color(0xFFFFFFFF); // Blanco puro para tarjetas
  static const Color bg = Color(0xFFFFFBEB);
}

class NeoStyle {
  // Bordes sólidos negros característicos
  static Border border({double width = 3.0, Color color = NeoColors.border}) {
    return Border.all(color: color, width: width);
  }

  // Sombra dura (Hard Shadow) neobrutalista
  static List<BoxShadow> hardShadow({
    Offset offset = const Offset(5, 5),
    Color color = NeoColors.border,
  }) {
    return [
      BoxShadow(
        color: color,
        offset: offset,
        blurRadius: 0, // ¡Sin desenfoque!
        spreadRadius: 0,
      ),
    ];
  }

  // Decoración base reutilizable para tarjetas
  static BoxDecoration cardDecoration({
    Color backgroundColor = NeoColors.cardBg,
    BorderRadius? borderRadius,
    Offset shadowOffset = const Offset(5, 5),
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      border: border(),
      boxShadow: hardShadow(offset: shadowOffset),
    );
  }
}
