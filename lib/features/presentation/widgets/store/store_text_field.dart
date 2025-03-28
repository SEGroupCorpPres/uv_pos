import 'package:flutter/material.dart';

class StoreTextField extends StatelessWidget {
  const StoreTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.textEditingController,
    this.isPassword = false,
    this.validator,
    this.onSaved,
    this.onTap,
    this.textInputType = TextInputType.text,
  });

  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextInputType? textInputType;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final ValueChanged<String?>? onSaved;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Icon(
              icon,
              color: Colors.grey,
            ),
          ),
        ),
        Flexible(
          flex: 9,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            height: 65,
            child: TextFormField(
              keyboardType: textInputType,
              onTap: onTap,
              controller: textEditingController,
              obscureText: isPassword,
              validator: validator,
              onSaved: onSaved,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
