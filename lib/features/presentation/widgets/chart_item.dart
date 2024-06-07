import 'package:flutter/material.dart';

class ChartItem extends StatelessWidget {
  final String title;
  final String? price;

  const ChartItem({super.key, required this.title, this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            price != null ? const Spacer() : Container(),
            price != null ? Text('\$$price',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blueAccent),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
