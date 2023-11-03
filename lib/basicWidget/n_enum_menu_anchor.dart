//
//  NEnumMenuAnchor.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/31 19:29.
//  Copyright © 2023/10/31 shang. All rights reserved.
//


import 'package:flutter/material.dart';


class NEnumMenuAnchor<E extends Enum> extends StatelessWidget {

  NEnumMenuAnchor({
    super.key,
    required this.values,
    // this.selectedItem,
    this.initialItem,
    this.defaultValue = "-",
    this.itemBuilder,
    required this.onChanged,
  });

  final List<E> values;
  // E? selectedItem;
  final E? initialItem;
  final String defaultValue;
  final Widget Function(MenuController controller, E? selectedItem)? itemBuilder;
  final ValueChanged<E> onChanged;

  @override
  Widget build(BuildContext context) {
    E? selectedItem;
    selectedItem ??= initialItem;

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {

          return MenuAnchor(
            builder: (context, MenuController controller, Widget? child) {

              return itemBuilder?.call(controller, selectedItem) ?? OutlinedButton(
                style: OutlinedButton.styleFrom(
                  // backgroundColor: Color(0xff5690F4).withOpacity(0.1),
                  // foregroundColor: Color(0xff5690F4),
                  elevation: 0,
                  // shape: StadiumBorder(),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  // minimumSize: Size(64, 32),
                  padding: EdgeInsets.only(left: 8, right: 2, top: 6, bottom: 6),
                ),
                onPressed: (){
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                // child: Text(selectedItem?.name ?? defaultValue),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(selectedItem?.name ?? defaultValue),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              );
            },
            menuChildren: values.map((e) {
              return MenuItemButton(
                onPressed: () {
                  selectedItem = e;
                  setState(() {});
                  onChanged.call(e);
                },
                child: Text(e.name),
              );
            }).toList(),
          );
        }
    );
  }
}