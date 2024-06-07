import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChartName extends StatelessWidget {
  final Color color;
  final String title;
  const ChartName({super.key, required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          color: color,
        ),
        SizedBox(width: 10),
        Text(title),
      ],
    );
  }
}
