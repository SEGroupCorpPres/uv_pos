import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  const SearchDialog({super.key, required this.fieldList, required this.actionList});

  final List<Widget> fieldList;
  final List<Widget> actionList;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width * .8,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: fieldList,
          ),
        ),
        const SizedBox(height: 15),
        const Divider(indent: 20, endIndent: 20),
        Row(
          children: actionList,
        )
      ],
    );
  }
}
