import 'package:flutter/material.dart';

abstract final class ColorConstants {
  static const List<ServerColor> serverColors = [
    ServerColor('Default', 0xFF6C63FF),
    ServerColor('Ocean Blue', 0xFF2196F3),
    ServerColor('Sky Blue', 0xFF03A9F4),
    ServerColor('Teal', 0xFF009688),
    ServerColor('Emerald', 0xFF4CAF50),
    ServerColor('Lime', 0xFF8BC34A),
    ServerColor('Amber', 0xFFFFC107),
    ServerColor('Orange', 0xFFFF9800),
    ServerColor('Deep Orange', 0xFFFF5722),
    ServerColor('Red', 0xFFF44336),
    ServerColor('Pink', 0xFFE91E63),
    ServerColor('Purple', 0xFF9C27B0),
    ServerColor('Deep Purple', 0xFF673AB7),
    ServerColor('Indigo', 0xFF3F51B5),
    ServerColor('Cyan', 0xFF00BCD4),
    ServerColor('Brown', 0xFF795548),
    ServerColor('Grey', 0xFF9E9E9E),
    ServerColor('Blue Grey', 0xFF607D8B),
    ServerColor('Mint', 0xFF26A69A),
    ServerColor('Coral', 0xFFFF7043),
  ];

  static const int defaultServerColor = 0xFF6C63FF;
}

class ServerColor {
  final String name;
  final int value;

  const ServerColor(this.name, this.value);

  Color get color => Color(value);
}
