import 'package:flutter/material.dart';
import 'package:future_pos/app/data/local/data_sources/popup_menu_list.dart';

List<Widget> homeActions(BuildContext context) => [
      PopupMenuButton(
        itemBuilder: (BuildContext context) => popupMenuList(context),
      ),
    ];
