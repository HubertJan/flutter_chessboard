import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final Color color;
  late Color highlightColor;
  final double size;
  final Widget? child;
  final bool highlight;

  Square({
    required this.color,
    required this.size,
    Color? highlightColor,
    this.child,
    this.highlight = false,
  }) : this.highlightColor =
            highlightColor ?? Color.fromRGBO(128, 128, 128, .3);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: color,
          height: size,
          width: size,
        ),
        if (highlight == true)
          Container(
            color: highlightColor,
            height: size,
            width: size,
          ),
        if (child != null) child!,
      ],
    );
  }
}
