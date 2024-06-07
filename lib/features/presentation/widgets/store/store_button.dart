import 'package:flutter/material.dart';

class StoreButton extends StatelessWidget {
  const StoreButton({super.key, required this.title, required this.icon, required this.onPressed});

  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green)),
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: Text(
        title,
        style: const TextStyle(color: Colors.white, inherit: true),
      ),
    );
  }
}
