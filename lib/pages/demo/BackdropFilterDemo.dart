//
//  BackdropFilterDemo.dart
//  flutter_templet_project
//
//  Created by shang on 7/30/21 11:13 AM.
//  Copyright © 7/30/21 shang. All rights reserved.
//


import 'dart:ui';
import 'package:flutter/material.dart';

class BackdropFilterDemo extends StatefulWidget {

  final String? title;

  BackdropFilterDemo({ Key? key, this.title}) : super(key: key);
  
  @override
  _BackdropFilterDemoState createState() => _BackdropFilterDemoState();
}

class _BackdropFilterDemoState extends State<BackdropFilterDemo> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildBody(),
    );
  }

  _buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          'images/bg.jpg',
          fit: BoxFit.cover,
        ),
        Center(
          child: ClipRect(  // <-- clips to the 200x200 [Container] below
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                alignment: Alignment.center,
                width: 200.0,
                height: 200.0,
                // color: Colors.red,
                child: const Text('Hello World'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
