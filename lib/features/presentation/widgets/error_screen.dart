import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onRetry;
  final String retryText;
  final bool isEmpty;

  const ErrorScreen({
    Key? key,
    this.title = 'Xatolik yuz berdi',
    required this.message,
    this.icon = Icons.error_outline,
    this.iconColor = Colors.red,
    this.onRetry,
    this.retryText = 'Retry',
    this.isEmpty = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isEmpty ? Colors.grey : iconColor,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              isEmpty ? 'Maxsulot topilmadi' : title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
               isEmpty ? 'Iltimos do\'konga maxsulot qo\'shing' : message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(retryText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}