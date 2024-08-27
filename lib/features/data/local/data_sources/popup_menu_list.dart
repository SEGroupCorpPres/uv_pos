import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';

List<PopupMenuEntry<Widget>> popupMenuList(BuildContext context) => [
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
   PopupMenuItem(
    onTap: (){
      showAdaptiveDialog(
        context: context,
        builder: (contex) {
          return buildAlertDialog(contex);
        },
      );
    },
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
AlertDialog buildAlertDialog(BuildContext context) {
  return AlertDialog.adaptive(
    icon: Icon(
      Icons.logout,
      size: 30.sp,
    ),
    content: Text(
      'Accountdan chiqishni hohlaysizmi ?',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20.sp),
    ),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, minimumSize: Size(100.w, 40.h)),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<AppBloc>(context).add(AuthLoggedOut());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: Size(100.w, 40.h)),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ],
  );
}
