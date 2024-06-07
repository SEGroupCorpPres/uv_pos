import 'package:flutter/material.dart';

class SearchDialogField extends StatelessWidget {
  const SearchDialogField({
    super.key,
    required this.controller,
    required this.title,
    this.isDateField = true,
    required this.onTap,
  });

  final TextEditingController controller;
  final String title;
  final bool? isDateField;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(flex: 4, child: SizedBox(width:85,child: Text(title,textAlign: TextAlign.right,))),
        Flexible(
          flex: 7,
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.green),
            textAlign: TextAlign.center,
            onTap: onTap,
            decoration: InputDecoration(
              isCollapsed: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              // enabled: true
            ),
            cursorHeight: isDateField! ? 0 : 20,
            cursorWidth: isDateField! ? 0 : 2,
          ),
        ),
      ],
    );
  }
}
