// check_email_screen.dart
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_pos/app/presentation/bloc/auth/auth_bloc.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key, required this.email});
  final String email;

  static Page page(String email) => Platform.isIOS
      ? CupertinoPage(
          child: CheckEmailScreen(email: email),
        )
      : MaterialPage(
          child: CheckEmailScreen(email: email),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'A verification link has been sent to $email. Please check your email to verify your account.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthSendEmailVerificationRequested(),
                    );
              },
              child: const Text('Return to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
