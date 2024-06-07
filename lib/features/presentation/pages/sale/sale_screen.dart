import 'package:flutter/material.dart';
import 'package:uv_pos/features/presentation/widgets/sale_button.dart';
import 'package:uv_pos/features/presentation/widgets/sale_product_price.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Sale'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_note_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.qr_code_2),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: SafeArea(
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                color: Colors.black12,
                height: 300,
              ),
              Container(
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black38))),
                width: double.infinity,
                child: Column(
                  children: [
                    const Column(
                      children: [
                        SaleProductPrice(title: 'Sub Total', price: '\$0'),
                        SaleProductPrice(title: 'Discount', price: '\$0', procedure: 0),
                        SaleProductPrice(title: 'Total', price: '\$0'),
                      ],
                    ),
                    SizedBox(
                      width: size.width,
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        children: [
                          SaleButton(title: 'Save', onPressed: () {}, bgColor: Colors.orange),
                          SaleButton(title: 'Discount', onPressed: () {}, bgColor: Colors.blue),
                          SaleButton(title: 'Clear', onPressed: () {}, bgColor: Colors.red),
                          SaleButton(title: 'Play', onPressed: () {}, bgColor: Colors.green),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
