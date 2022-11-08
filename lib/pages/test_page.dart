//
//  TestPage.dart
//  flutter_templet_project
//
//  Created by shang on 12/2/21 2:16 PM.
//  Copyright © 12/2/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/Language/Property.dart';
import 'package:flutter_templet_project/basicWidget/RadiusWidget.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/string_extension.dart';
import 'package:flutter_templet_project/extension/map_extension.dart';

import 'package:flutter_templet_project/extension/buildContext_extension.dart';
import 'package:tuple/tuple.dart';


class TestPage extends StatefulWidget {

  final String? title;

  TestPage({ Key? key, this.title}) : super(key: key);

  
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  var titles = ["splitMapJoin", "1", "2", "3", "4", "5", "6", "7"];
  int time = 60;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Column(
          children: [
            buildWrap(),
            buildSection1(),
            StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return buildSection2();
            }),
            RepaintBoundary(child: buildSection3(),),
            Container(
              margin: const EdgeInsets.all(8),
              child: RadiusWidget(
                radius: 8,
                child: Container(
                    width: 200,
                    height: 40,
                    child: Text('widget.title')
                ),
                color: Colors.green,
              ),
            ),
            TextField(
              cursorColor: Colors.purple,
              cursorRadius: Radius.circular(8.0),
              cursorWidth: 8.0,
            ),
            buildBtnColor(),
            buildSection4(),
          ],
        )
    );
  }

  Wrap buildWrap() {
    return Wrap(
      spacing: 8.0, // 主轴(水平)方向间距
      runSpacing: 8.0, // 纵轴（垂直）方向间距
      alignment: WrapAlignment.start, //沿主轴方向居中
      children: titles.map((e) => ActionChip(
        avatar: CircleAvatar(backgroundColor: Theme.of(context).primaryColor,
            child: Text("${e.characters.first.toUpperCase()}")
        ),
        label: Text(e),
        onPressed: (){
          _onPressed(titles.indexOf(e));
        },
      )).toList(),
    );
  }

  buildSection1() {
    return Column(
      children: [
        Row(
          children: [
            Text('倒计时'),
            Text('$time')
          ],
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.send),
          label: Text("ElevatedButton"),
          onPressed: () {
            setState(() {
              time++;
            });
          },
        ),
      ],
    );
  }

  buildSection2() {
    return Column(
        children: [
          Row(
            children: [
              Text('倒计时'),
              Text('$time')
            ],
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.send),
            label: Text("ElevatedButton"),
            onPressed: () {
              setState(() {
                time++;
              });
            },
          ),
        ],
      );
  }

  buildSection3() {
    return Column(
      children: [
        Row(
          children: [
            Text('倒计时'),
            Text('$time')
          ],
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.send),
          label: Text("ElevatedButton"),
          onPressed: () {
            setState(() {
              time++;
            });
          },
        ),
      ],
    );
  }

  buildSection4() {
    final tuples = [
      Tuple2('Color(0xFF4286f4)', Color(0xFF4286f4)),
      Tuple2('Color(0xFF4286f4).withOpacity(0.5)', Color(0xFF4286f4).withOpacity(0.5)),
      Tuple2('Colors.black.withOpacity(0.4)', Colors.black.withOpacity(0.4)),
    ];
    return Column(
      children: tuples.map((e) => Row(
          children: [
            Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(left: 16, right: 8),
              color: e.item2,
            ),
            Text('${e.item1}'),
          ]
      )).toList(),

    );
  }


  buildBtnColor() {
    return
    TextButton(
      onPressed: () {},
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed))
            return Colors.green;
          return Colors.black87; // Defer to the widget's default.
        }),
      ),
      child: Text('Change My Color', style: TextStyle(fontSize: 30),
      ),
    );
  }

  void _onPressed(int e) {
    final a = 'Eats shoots leaves'.splitMapJoin((RegExp(r'shoots')),
         onMatch:    (m) => '${m[0]}',  // (or no onMatch at all)
         onNonMatch: (n) => '*'); // Result: "*shoots*"
    ddlog(a);

    final b = 'Eats shoots leaves'.splitMapJoin((RegExp(r's|o')),
        onMatch: (m) => "_",
    );
    ddlog(b);

    final c = 'Eats shoots leaves'.split(RegExp(r's|o'));
    ddlog(c);

    final d = "easy_refresh_plugin".camlCase("_");
    ddlog(d);

    final d1 = "easyRefreshPlugin".uncamlCase("_");
    ddlog(d1);

    final d2 = "easyRefreshPlugin".toCapitalize();
    ddlog(d2);

    ddlog(screenSize);

    showSnackBar(SnackBar(content: Text(d2)));

    Map<String, dynamic> map = {
      'msgType': '5',
      'msgTag': '官方号',
      'msgUnreadNum': 3,
    };

    ddlog('getUrlParams():${getUrlParams(map: map)}');
    ddlog('map.join():${map.join()}' );
  }

  getUrlParams({Map<String, dynamic> map = const {}}) {
    if (map.keys.length == 0) {
      return '';
    }
    String paramStr = '';
    map.forEach((key, value) {
      paramStr += '${key}=${value}&';
    });
    String result = paramStr.substring(0, paramStr.length - 1);
    return result;
  }

  testProperty(){
    // PropertyInfo.getVariableType();
  }
}

// typedef RadiusBuilder = Widget Function(BuildContext context, StateSetter setState);

