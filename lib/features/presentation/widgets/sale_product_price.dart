import 'package:flutter/material.dart';

class SaleProductPrice extends StatelessWidget {
  const SaleProductPrice({super.key, required this.title, required this.price, this.procedure});

  final String title;
  final String price;
  final double? procedure;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
          procedure == null
              ? const Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    '\$0',
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                  ),
                )
              : const Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    '0%(\$0)',
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                  ),
                ),
        ],
      ),
    );
  }
}
