//
//  BottomSheetDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/8/21 1:31 PM.
//  Copyright © 12/8/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_label_and_icon.dart';
import 'package:flutter_templet_project/extension/button_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/navigator_ext.dart';
import 'package:flutter_templet_project/pages/TopDrawer.dart';

class BottomSheetDemo extends StatelessWidget {
  final String? title;

  const BottomSheetDemo({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$this"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            presentTopFilter(context);
          },)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Builder(
      builder: (context) {
        return Center(
          child: TextButton(
            onPressed: () {
              showSheet(context);
            },
            child: Text('SHOW BOTTOM SHEET'),
          ),
        );
      },
    );
  }

  presentTopFilter(BuildContext context){
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {

        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 300),
          child: TopDrawer(
            builder: (onHide) {

              return Scaffold(
                appBar: AppBar(
                  title: Text("TopDrawer"),
                  automaticallyImplyLeading: false,
                  actions: [
                    TextButton(
                      onPressed: onHide,
                      child: Text('取消',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ]
                ),
                body: buildBody(),
              );
            },
          )
        );
      },
    );
  }

  showSheet(BuildContext context) {
    final content = SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildList(context),
          Positioned(
            top: -30,
            right: 15,
            child: FloatingActionButton(
              foregroundColor: Colors.blue,
              backgroundColor: Colors.white,
              onPressed: () {
                ddlog("directions_bike");
              },
              child: Icon(Icons.directions_bike),
            ),
          ),
        ],
      ),
    );

    showModalBottomSheet(
      // showDragHandle: true,
      context: context,
      builder: (context) {

        return content;
      },
    );
  }

  _buildList(BuildContext context) {
    final theme = Theme.of(context);

    final titleMediumStyle = theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onPrimary);

    return Wrap(
      children: [
        Container(
          height: 80,
          color: theme.colorScheme.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Header',
                  style: titleMediumStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'this is subtitle',
                      style: titleMediumStyle,
                    ),
                    Text(
                      "trailing",
                      style: titleMediumStyle,
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
        buildMid(
          cb: (i){
            debugPrint("index: $i");
          }
        ),
        Divider(),
        buildBottom(
          cb: (i){
            debugPrint("index: $i");
          }
        ),
      ],
    );
  }
  
  Widget buildMid({required ValueChanged<int?> cb}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        NLabelAndIcon<int>(
          label: Text("CALL"),
          icon: Icon(Icons.call),
          direction: Axis.vertical,
          data: 0,
        ),
        NLabelAndIcon(
          label: Text("SHARE"),
          icon: Icon(Icons.open_in_new),
          direction: Axis.vertical,
          data: 1,
        ),
        NLabelAndIcon(
          label: Text("SAVE"),
          icon: Icon(Icons.playlist_add),
          direction: Axis.vertical,
          data: 2,
        ),
      ].map((e) {
        return TextButton(
          onPressed: () {
            cb(e.data);
          },
          child: e,
        );
      }).toList(),
    );
  }

  Widget buildBottom({required ValueChanged<int?> cb}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        NLabelAndIcon<int>(
          label: Text("Share"),
          icon: Icon(Icons.share, color: Colors.blue,),
          data: 0,
        ),
        NLabelAndIcon(
          label: Text("Get link"),
          icon: Icon(Icons.link, color: Colors.blue,),
          data: 1,
        ),
        NLabelAndIcon(
          label: Text("Edit name"),
          icon: Icon(Icons.edit, color: Colors.blue,),
          data: 2,
        ),
        NLabelAndIcon(
          label: Text('Delete collection'),
          icon: Icon(Icons.delete, color: Colors.blue,),
          data: 3,
        ),
      ].map((e) {
        return ListTile(
          leading: e.icon,
          title: e.label,
          onTap: () {
            cb(e.data);
          }
        );
      }).toList(),
    );
  }
}
