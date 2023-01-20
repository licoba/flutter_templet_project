//
//  MyPopverDemo.dart
//  flutter_templet_project
//
//  Created by shang on 1/20/23 8:09 AM.
//  Copyright © 1/20/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';

class MyPopverDemo extends StatefulWidget {

  MyPopverDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyPopverDemoState createState() => _MyPopverDemoState();
}

class _MyPopverDemoState extends State<MyPopverDemo> {

  final _globalKey = GlobalKey();

  var btnIdx = 0;
  var isVisible = false;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: ListView(
        children: [
          ...List.generate(10, (index) => ListTile(title: Text("top_$index"),)).toList(),
          _buildSection(),
          ...List.generate(20, (index) => ListTile(title: Text("row_$index"),)).toList(),
        ],
      ),
    );
  }

  _buildSection() {
    return Stack(
      key: _globalKey,
      clipBehavior: Clip.none,
      // fit: StackFit.expand,
      children: [
        _buildMenu(),
        if (isVisible)
        Positioned(
          // left: 0,
          right: 0.0,
          top: 30 * 0.9,
          width: context.screenSize.width,
          height: 300.0,
          child: _buildDropBox(),
        ),
      ],
    );
  }

  _buildMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (index) => ElevatedButton(
          onPressed: () {
            print("菜单$index");
            btnIdx = index;
            isVisible = !isVisible;
            setState(() {});
          },
          child: Text("菜单$index"),
        )).map((e) => Expanded(child: e)).toList(),
    );
  }

  _buildDropBox() {
    return Builder(
      builder: (context) {
        if (btnIdx == 0) {
          return _buildDropBox1();
        }
        if (btnIdx == 1) {
          return _buildDropBox2();
        }
        return _buildDropBox3();
      }
    );
  }

  _buildDropBox1() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(width: 5, color: Colors.red),
        ),
        child: Center(child: Text("one"))
    );
  }

  _buildDropBox2() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(width: 5, color: Colors.yellow),
        ),
        child: Center(child: Text("two"))
    );
  }

  _buildDropBox3() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        // borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(
        children: [
          Column(
            children: [
              ...List.generate(20, (index) => ListTile(title: Text("我是弹窗_$index"),)).toList(),
            ],
          ),
        ],
      ),
    );
  }

  final OutlineInputBorder _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(4.0),
    borderSide: BorderSide(
      color: Colors.grey,
      width: 1.0,
    ),
  );

}