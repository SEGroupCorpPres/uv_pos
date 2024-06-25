import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/presentation/widgets/store/store_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  static Page page() => Platform.isIOS
      ? const CupertinoPage(
          child: RegistrationScreen(),
        )
      : const MaterialPage(
          child: RegistrationScreen(),
        );

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'registrationFormKey');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      // Trigger the registration event in AuthBloc
      context.read<AppBloc>().add(
            AuthRegister(
              _emailController.text,
              _passwordController.text,
              _phoneController.text,
              _nameController.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
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
                  SizedBox(height: 100.h),
                  const Text(
                    'UV POS',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  StoreTextField(
                    hintText: 'Name',
                    textEditingController: _nameController,
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  StoreTextField(
                    hintText: 'Email',
                    textEditingController: _emailController,
                    icon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  StoreTextField(
                    hintText: 'Phone number',
                    icon: Icons.phone,
                    textEditingController: _phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  StoreTextField(
                    hintText: 'Password',
                    icon: Icons.lock,
                    textEditingController: _passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  StoreTextField(
                    hintText: 'Confirm Password',
                    icon: Icons.lock,
                    textEditingController: _confirmPasswordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      _onRegisterPressed();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(size.width, 40),
                    ),
                    child: const Text(
                      'Registration',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<AppBloc>(context).add(NavigateToLoginScreen());
                    },
                    child: const Text('Login', style: TextStyle(color: Colors.blue)),
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
