// loading_screen.dart
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  static Page page() => Platform.isIOS
      ? const CupertinoPage(
          child: LoadingScreen(),
        )
      : const MaterialPage(
          child: LoadingScreen(),
        );

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator.adaptive(),
            SizedBox(height: 20),
            Text('Loading, please wait...'),
          ],
        ),
      ),
    );
  }
}
