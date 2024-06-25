import 'package:flutter/material.dart';

List<PopupMenuEntry<Widget>> popupMenuList = [
  const PopupMenuItem(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.language_outlined,
          color: Colors.blue,
        ),
        SizedBox(width: 10),
        Text(
          'Change Language',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ],
    ),
  ),
  const PopupMenuItem(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RotatedBox(
          quarterTurns: 2,
          child: Icon(
            Icons.brightness_2,
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 10),
        Text(
          'Toggle Theme',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ],
    ),
  ),
  const PopupMenuItem(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.person,
          color: Colors.blue,
        ),
        SizedBox(width: 10),
        Text(
          'Update Profile',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ],
    ),
  ),
  const PopupMenuItem(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.password,
          color: Colors.blue,
        ),
        SizedBox(width: 10),
        Text(
          'Change Password',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ],
    ),
  ),
  const PopupMenuItem(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          // radius: 20,
          minRadius: 13,
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.question_mark_rounded,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 10),
        Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ],
    ),
  ),
  const PopupMenuItem(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.logout,
          color: Colors.blue,
        ),
        SizedBox(width: 10),
        Text(
          'Logout',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ],
    ),
  ),
];
