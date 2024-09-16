import 'package:flutter/material.dart';

class SaleButton extends StatelessWidget {
  const SaleButton({super.key, required this.title, required this.onPressed, required this.bgColor, this.minWidth});

  final String title;
  final Color bgColor;
  final VoidCallback onPressed;
  final double? minWidth;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: bgColor,
      minWidth: minWidth ?? size.width / 2 - 15,
      height: 40,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}
