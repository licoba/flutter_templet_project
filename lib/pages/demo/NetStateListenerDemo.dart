//
//  ValueListenableBuilderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 5:09 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/service/connectivity_service.dart';

class NetStateListenerDemo extends StatefulWidget {

  NetStateListenerDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _NetStateListenerDemoState createState() => _NetStateListenerDemoState();
}

class _NetStateListenerDemoState extends State<NetStateListenerDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => print(e),)
        ).toList(),
      ),
      body: Column(
        children: [
          _buildNetState(),
          _buildNetOnline(),
        ],
      ),
    );
  }
  
  _buildNetState() {
    return ValueListenableBuilder<ConnectivityResult>(
      valueListenable: ConnectivityService().netState,
      child: Text("监听 ConnectivityService().netState"),
      builder: (context, value, child) {
        print('ValueListenableBuilder: netState:${value}');

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            child!,
            Text('$value'),
          ],
        );
      },
    );
  }

  _buildNetOnline() {
    return ValueListenableBuilder<bool>(
      valueListenable: ConnectivityService().onLine,
      child: Text("监听 ConnectivityService().onLine"),
      builder: (context, value, child) {
        print('ValueListenableBuilder: onLine:${value}');

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            child!,
            Text('$value'),
          ],
        );
      },
    );
  }
  
  

}