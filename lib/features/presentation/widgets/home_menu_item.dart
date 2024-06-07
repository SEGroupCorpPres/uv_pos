import 'package:flutter/material.dart';

class HomeMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const HomeMenuItem({super.key, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Icon(
                icon,
                color: Colors.blue,
                size: 90,
              ),
            ),
            Container(
              clipBehavior: Clip.none,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              alignment: Alignment.center,
              height: 25,
              width: size.width / 2 - 40,
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
