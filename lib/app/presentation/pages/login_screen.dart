import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_auth_buttons/social_auth_buttons.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static Page page() => Platform.isIOS
      ? const CupertinoPage(
          child: LoginScreen(),
        )
      : const MaterialPage(
          child: LoginScreen(),
        );

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'loginFormKey');
  late AppBloc authBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _loginController.text;
      final password = _passwordController.text;
      context.read<AppBloc>().add(AuthLoggedIn(email, password));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0).r,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 150.h),
                  const Text(
                    'UV POS',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  StoreTextField(
                    hintText: 'Email address or Phone number',
                    icon: Icons.phone,
                    textEditingController: _loginController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  StoreTextField(
                    textEditingController: _passwordController,
                    hintText: 'Password',
                    icon: Icons.lock,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      // BlocProvider.of<AppBloc>(context).add(
                      //   NavigateToHomeScreen(),
                      // );
                      _login();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(size.width, 40.h),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<AppBloc>(context).add(
                        NavigateToRegistrationScreen(),
                      );
                    },
                    child: const Text('Register', style: TextStyle(color: Colors.blue)),
                  ),
                  const Text('Or'),
                  SizedBox(
                    height: 10.h,
                  ),
                  GoogleAuthButton(
                    borderRadius: 30.r,
                    borderColor: Colors.transparent,
                    onPressed: () {
                      BlocProvider.of<AppBloc>(context).add(
                        AuthGoogleSignInRequested(),
                      );
                    },
                    darkMode: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
