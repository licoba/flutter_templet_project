//
//  TestPage.dart
//  flutter_templet_project
//
//  Created by shang on 12/2/21 2:16 PM.
//  Copyright © 12/2/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_templet_project/Language/Property.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/map_ext.dart';

import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/uti/Singleton.dart';
import 'package:flutter_templet_project/uti/R.dart';


class TestPage extends StatefulWidget {
  const TestPage({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with SingleTickerProviderStateMixin {
  List<String> items = List.generate(6, (index) => 'item_$index').toList();
  late TabController _tabController;

  var titles = ["splitMapJoin", "1", "2", "3", "4", "5", "6", "7"];
  int time = 60;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: items.length, vsync: this)
    ..addListener(() {
      if(!_tabController.indexIsChanging){
        debugPrint("_tabController:${_tabController.index}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("_TestPageState this:${this}");
    debugPrint("_TestPageState widget:$widget");

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(R.image.urls[5]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(widget.title ?? "$widget"),
          actions: ['done',].map((e) => TextButton(
            onPressed: onDone,
            child: Text(e,
                style: TextStyle(color: Colors.white),
              ),)
          ).toList(),
          // bottom: buildAppBarBottom(),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: List.generate(6, (index) => Tab(text: 'item_$index')).toList(),
            // indicatorSize: TabBarIndicatorSize.label,
            // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildWrap(),
              buildSection1(),
              StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return buildSection2();
              }),
              RepaintBoundary(child: buildSection3(),),
              Container(
                margin: const EdgeInsets.all(8),
                color: Colors.green,
                child: Container(
                    width: 200,
                    height: 40,
                    child: Text('widget.title')
                ),
              ),
              TextField(
                cursorColor: Colors.purple,
                cursorRadius: Radius.circular(8.0),
                cursorWidth: 8.0,
              ),
              buildBtnColor(),
              buildSection4(),
              buildSection5(),
              // Image.asset(
              //   'images/img_update.png',
              //   repeat: ImageRepeat.repeat,
              // ),
            ],
          ),
        )
    );
  }

  buildAppBarBottom() {
    final items = List.generate(6, (index) => Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text('item_$index'),
    )).toList();
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: Row(
        children: items,
      ),
    );

    return PreferredSize(
      preferredSize: Size(screenSize.width, 60),
      child: Row(
        children: List.generate(16, (i) => Container(
          child: Text('item_$i'),
        )).toList(),
      ),
    );
  }

  onDone() {
    const a = true;
    final b = "nested ${a ? "strings" : "can"} be wrapped by a double quote";

    final shard = Singleton();
    final shard1 = Singleton.instance;
    final shard2 = Singleton.getInstance();

    debugPrint(shard.toString());
    debugPrint(shard1.toString());
    debugPrint(shard2.toString());
    debugPrint("${shard == shard1}");
    debugPrint("${shard1 == shard2}");
    debugPrint("${shard == shard2}");

    const aa = "我是谁";
    const bb = "9999";
    const cc = "https://stackoverflow.com/questions/26107125/cannot-read-property-addeventlistener-of-null";

    final map = {
      r"a": aa,
      r"b": bb,
      r"c": cc,
    };
    debugPrint("map:$map");
    debugPrint("c:${map["c"]}");
    debugPrint("d:${map["d"]}");

  }


  Wrap buildWrap() {
    return Wrap(
      spacing: 8.0, // 主轴(水平)方向间距
      runSpacing: 8.0, // 纵轴（垂直）方向间距
      alignment: WrapAlignment.start, //沿主轴方向居中
      children: titles.map((e) => ActionChip(
        avatar: CircleAvatar(backgroundColor: Theme.of(context).primaryColor,
            child: Text(e.characters.first.toUpperCase())
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
            Text(e.item1),
          ]
      )).toList(),
    );
  }

  buildSection5() {
    return Listener(
      onPointerDown: (e){
        debugPrint("onPointerDown:$e");
      },
      child: Container(
        height: 400,
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (ctx, index) {
            return Container(
              height: 60,
              child: ColoredBox(
                color: ColorExt.random,
                child: Text('Row_$index')
              ),
            );
          }
        ),
      ),
    );
  }


  buildBtnColor() {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.green;
          }
          return Colors.black87; // Defer to the widget's default.
        }),
      ),
      child: Text('Change My Color', style: TextStyle(fontSize: 30),
      ),
    );
  }

  void _onPressed(int e) {
    final a = 'Eats shoots leaves'.splitMapJoin((RegExp(r'shoots')),
         onMatch:    (m) => m[0] ?? "",  // (or no onMatch at all)
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

    var map = <String, dynamic>{
      'msgType': '5',
      'msgTag': '官方号',
      'msgUnreadNum': 3,
    };

    ddlog('getUrlParams():${getUrlParams(map: map)}');
    ddlog('map.join():${map.join()}' );

    double? z;
    double? z1;
    final list = [z, z1];
    debugPrint('z1:$list');

    List<String>? items;
    final zz = items?[0];
    debugPrint('zz:$zz');

    final map1 = {
      'a': 1,
      'b': 11,
      'c': 111
    };

    debugPrint('map: $map1');
    debugPrint('map1: $map1');

    List<String>? strs;
    if (strs == null || strs.isEmpty == true) {
      debugPrint('strs: isEmpty');
    }
  }

  getUrlParams({Map<String, dynamic> map = const {}}) {
    if (map.keys.isEmpty) {
      return '';
    }
    var paramStr = '';
    map.forEach((key, value) {
      paramStr += '$key=$value&';
    });
    var result = paramStr.substring(0, paramStr.length - 1);
    return result;
  }

}

// typedef RadiusBuilder = Widget Function(BuildContext context, StateSetter setState);

