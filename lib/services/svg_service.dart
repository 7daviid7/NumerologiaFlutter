import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Defineix el widget personalitzat
class CustomSvgWidget extends StatelessWidget {

  final double width;
  final double height;
  final String name; 

  // Constructor del widget
  CustomSvgWidget({required this.width, required this.height, required this.name});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      name,
      height: height,
      width: width,
      // Altres opcions que pots afegir aquí si cal
    );
  }
}
