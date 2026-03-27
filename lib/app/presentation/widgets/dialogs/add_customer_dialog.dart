import 'package:flutter/material.dart';
import 'dialogs.dart';

class AddCustomerDialog extends StatefulWidget {
  const AddCustomerDialog({super.key, required this.customerController, required this.onPressed});

  final TextEditingController customerController;
  final VoidCallback onPressed;

  @override
  State<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0).r,
          child: TextField(
            controller: widget.customerController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Customer name',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
