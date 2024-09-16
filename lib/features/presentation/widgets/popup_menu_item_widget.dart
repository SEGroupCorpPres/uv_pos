import 'package:flutter/material.dart';
import 'package:uv_pos/features/data/local/models/popup_menu_item_model.dart';

class PopupMenuItemWidget extends StatelessWidget {
  const PopupMenuItemWidget({
    super.key, required this.itemModel,
  });

  final PopupMenuItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem(
      onTap: itemModel.onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            itemModel.iconData,
            color: Colors.blue,
          ),
          SizedBox(width: 10),
          Text(
            itemModel.title,
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
