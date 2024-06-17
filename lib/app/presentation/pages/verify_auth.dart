import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:uv_pos/app/presentation/bloc/auth/auth_bloc.dart';

class VerifyAuthScreen extends StatefulWidget {
  final String verificationId;

  const VerifyAuthScreen({super.key, required this.verificationId});

  @override
  State<VerifyAuthScreen> createState() => _VerifyAuthScreenState();
}

class _VerifyAuthScreenState extends State<VerifyAuthScreen> {
  final TextEditingController verifyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'verifyAuthFormKey');
  OtpFieldControllerV2 otpController = OtpFieldControllerV2();

  late String otpCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    verifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0).r,
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 200.h),
                    const Text(
                      'UV POS',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        SizedBox(width: 5.w),
                        const Text(
                          'OTP codni kiriting',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    OTPTextFieldV2(
                      controller: otpController,
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldWidth: 45,
                      fieldStyle: FieldStyle.box,
                      outlineBorderRadius: 15,
                      style: const TextStyle(fontSize: 17),
                      onChanged: (pin) {
                        setState(() {
                          otpCode = pin;
                        });
                        if (kDebugMode) {
                          print("Changed: $pin");
                        }
                      },
                      onCompleted: (pin) {
                        if (kDebugMode) {
                          print("Completed: $pin");
                        }
                        if (_formKey.currentState!.validate()) {
                          final otp = otpCode;
                          BlocProvider.of<AuthBloc>(context).add(
                            AuthPhoneOTPVerified(widget.verificationId, otp),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        SizedBox(width: 5.w),
                        const Text(
                          'OTP codni qaytadan jo\'natish',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        const Spacer(),
                        TextButton(onPressed: (){}, child: const Text('Resend'))
                      ],
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       Platform.isIOS
                    //           ? CupertinoPageRoute(
                    //               builder: (_) => const StoreListScreen(),
                    //             )
                    //           : MaterialPageRoute(
                    //               builder: (_) => const StoreListScreen(),
                    //             ),
                    //     );
                    //   },
                    //   style: TextButton.styleFrom(
                    //     backgroundColor: Colors.blue,
                    //     minimumSize: Size(size.width, 40),
                    //   ),
                    //   child: const Text(
                    //     'Login',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 15,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
