//
//  ValueListenableBuilderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 5:09 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NNet/NNet.dart';
import 'package:flutter_templet_project/basicWidget/NNet/NNetContainerListView.dart';
import 'package:flutter_templet_project/provider/notifier_demo.dart';
import 'package:flutter_templet_project/service/connectivity_service.dart';

class NetStateListenerDemo extends StatefulWidget {

  NetStateListenerDemo({
    Key? key,
    this.title
  }) : super(key: key);

  String? title;

  @override
  _NetStateListenerDemoState createState() => _NetStateListenerDemoState();
}

class _NetStateListenerDemoState extends State<NetStateListenerDemo> {

  final _refreshKey = GlobalKey<NNetContainerListViewState>();

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () => print(e),)
        ).toList(),
      ),
      body: Column(
        children: [
          _buildNetState(),
          _buildNetOnline(),
          _buildNet(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _refreshKey.currentState?.easyRefreshController.callRefresh(),
                child: Text("callRefresh"),
              ),
              ElevatedButton(
                onPressed: () => _refreshKey.currentState?.easyRefreshController.callLoad(),
                child: Text("callLoad"),
              ),
            ]
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(color: Colors.red, width: 2),
            ),
            height: 400,
            width: double.maxFinite,
            child: NNetContainerListView<String>(
              key: _refreshKey,
              onRequest: (bool isRefesh, int page, int pageSize, last) async {
                return await Future.delayed(const Duration(milliseconds: 1500), () {
                  final result = List<String>.generate(3, (i) => 'page_${page}_pageSize_${pageSize}_Item_${i}');
                  return Future.value(result);
                });
              },
              itemBuilder: (BuildContext context, int index, data) {
                return ListTile(
                  leading: Icon(Icons.ac_unit),
                  title: Text("${data}"),
                );
              },
            ),
          )

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

        // netState.value = value == false ? NNetState.offline : NNetState.normal;

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


  _buildNet() {
    return NNet(
      // state: netState,
      childBuilder: (ctx, child) {
        return ElevatedButton(
            onPressed: () => print("ElevatedButton"),
            child: Text("ElevatedButton"),
        );
      },
      errorBuilder: (ctx, child) {
        return TextButton(
          onPressed: () => print("offlineBuilder"),
          child: Text("offlineBuilder"),
        );
      },

    );
  }
  

}


