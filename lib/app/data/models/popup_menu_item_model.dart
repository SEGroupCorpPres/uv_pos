import 'package:flutter/cupertino.dart';

class PopupMenuItemModel{
  final String title;
  final IconData iconData;
  final VoidCallback onTap;

  PopupMenuItemModel({required this.title, required this.iconData, required this.onTap});
}