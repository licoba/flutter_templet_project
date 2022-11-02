import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/extension/buildContext_extension.dart';
import 'package:flutter_templet_project/extension/textStyle_extension.dart';
import 'package:flutter_templet_project/pages/demo/MyPainter.dart';
import 'package:flutter_templet_project/basicWidget/NNPopupRoute.dart';
import 'package:flutter_templet_project/basicWidget/gesture_detector_container.dart';
import 'package:flutter_templet_project/basicWidget/upload_button.dart';
import 'package:flutter_templet_project/extension/button_extension.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

import 'package:flutter_templet_project/extension/navigator_extension.dart';

import 'package:flutter_templet_project/network/fileManager.dart';
import 'package:flutter_templet_project/basicWidget/hud/progresshud.dart';

import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

class SecondPage extends StatefulWidget {
  final String? title;

  SecondPage({Key? key, this.title}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  bool _isList = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        // leading: BackButton(
        //           color: Colors.white,
        //           onPressed: (){ NavigatorExt.popPage(context); }
        //           ),
        // // .gestures(onTap: ()=> ddlog("back")
        actions: [
          IconButton(
            icon: Icon(Icons.change_circle_outlined),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _isList = !_isList;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: _isList ? buildListView() : buildGridView(),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     APPThemeSettings.instance.changeTheme();
      //   },
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  GlobalKey _globalKey = GlobalKey();
  GlobalKey _globalKey1 = GlobalKey();

  buildListView() {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const SizedBox(height: 30),

            _buildClipRRectGradientButton(),
            SizedBox(
              height: 10,
            ),

            Divider(),
            _buildSectionTitle("MaterialButton"),
            MaterialButton(
              color: Colors.blue.shade400,
              textColor: Colors.white,
              child: Text("MaterialButton"),
              onPressed: () => print("MaterialButton"),
            ),

            Divider(),
            _buildSectionTitle("BackButton"),
            BackButton(
              onPressed: () => print("BackButton"),
              color: Colors.red,
            ),

            Divider(),
            _buildSectionTitle("MaterialButton"),
            ElevatedButton.icon(
              icon: Icon(Icons.send),
              label: Text("ElevatedButton"),
              key: _globalKey,
              onPressed: () {
                // _showCustomPopView();
                ddlog([_globalKey.position(), _globalKey.size]);
                // test();
              },
            ),

            Divider(),
            _buildSectionTitle("Directionality ElevatedButton"),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ElevatedButton.icon(
                onPressed: () { print("ElevatedButton"); },
                icon: Icon(Icons.arrow_back,),
                label: Text("ElevatedButton"),
              )
            ),

            Divider(),
            _buildSectionTitle("OutlinedButton"),
            OutlinedButton.icon(
              icon: Icon(Icons.add),
              label: Text("OutlinedButton"),
              key: _globalKey1,
              onPressed: () {
                ddlog([_globalKey1.position(), _globalKey1.size]);
                // test();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    width: 1.0,
                    color: Theme.of(context).colorScheme.secondary,
                    style: BorderStyle.solid),
              ),
            ),

            Divider(),
            _buildSectionTitle("TextSelectionToolbarTextButton"),
            TextSelectionToolbarTextButton(
                child: Text("TextSelectionToolbarTextButton"),
                padding: EdgeInsets.all(8),
              onPressed: (){
                  print("TextSelectionToolbarTextButton");
              },
            ),

            Divider(),
            _buildSectionTitle("TextButton"),
            Row(
              children: [
                TextButton(
                  onPressed: () => ddlog('$this'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'TextButton',
                      ).padding(right: 5),
                      // SizedBox(width: 30),
                      Icon(Icons.call),
                    ],
                  ).decorated(
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                ),
                TextButton(
                  onPressed: () => ddlog('TextButton'),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("TextButton"),
                      SizedBox(width: 5),
                      Icon(Icons.send),
                    ],
                  ),
                ),
              ],
            ),

            Divider(),
            _buildSectionTitle("TextButtonExt"),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButtonExt.build(
                    text: Text("left"),
                    image: Icon(Icons.info),
                    imageAlignment: ImageAlignment.left,
                    side: BorderSide(width: 1.0, color: Colors.black12),
                    callback: (value, tag) {
                      ddlog([value.data, tag]);
                    }),
                  TextButtonExt.build(
                    text: Text("right"),
                    image: Icon(Icons.info),
                    imageAlignment: ImageAlignment.right,
                    side: BorderSide(width: 1.0, color: Colors.blue),
                    callback: (value, tag) {
                      ddlog(value.data);
                    }),
                  TextButtonExt.build(
                    text: Text("top"),
                    image: Icon(Icons.info),
                    imageAlignment: ImageAlignment.top,
                    side: BorderSide(width: 1.0, color: Colors.red),
                    callback: (value, tag) {
                      ddlog(value.data);
                    }),
                  TextButtonExt.build(
                    text: Text("bottom"),
                    image: Icon(Icons.info),
                    imageAlignment: ImageAlignment.bottom,
                    side: BorderSide(width: 1.0, color: Colors.green),
                    callback: (value, tag) {
                      ddlog(value.data);
                    }),
                ]
            ),

            Divider(),
            _buildSectionTitle("MaterialButton"),
            MaterialButton(
              padding: EdgeInsets.all(18),
              minWidth: 0,
              // color: Colors.green,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              onPressed: () { print("Press"); },
              child: TextButtonExt.buildTextAndImage(
                text: Text("bottom"),
                image: Icon(Icons.info),
                imageAlignment: ImageAlignment.top,
              ),
            ),

            Divider(),
            _buildSectionTitle("IconButton"),
            IconButton(
              tooltip: '这是一个图标按钮',
              icon: Icon(Icons.person),
              iconSize: 30,
              color: Theme.of(context).accentColor,
              onPressed: () {
                ddlog("这是一个图标按钮");
              },
            ),

            Divider(),
            _buildSectionTitle("ToggleButtons"),
            buildToggleButtons(context),

            Divider(),
            _buildSectionTitle("FloatingActionButton"),
            FloatingActionButton(
              mini: true,
              backgroundColor: const Color(0xff03dac6),
              foregroundColor: Colors.black,
              onPressed: () {
                ddlog("FloatingActionButton");
              },
              child: Icon(Icons.open_with),
            ),
            SizedBox(height: 10,),

            FloatingActionButton.extended(
              backgroundColor: const Color(0xff03dac6),
              foregroundColor: Colors.black,
              onPressed: () {
                ddlog("FloatingActionButton.extended");
              },
              icon: Icon(Icons.add),
              label: Text('EXTENDED'),
            ),

            Divider(),
            _buildSectionTitle("DropdownButton"),
            _buildDropdownButton(),

            _buildSectionTitle("_buildDropdownButton1"),
            _buildDropdownButton1(),

            Divider(),
            _buildSectionTitle("UploadButton"),
            UploadButton(
              image: Image.asset("images/img_update.png", fit: BoxFit.fill, width: 100, height: 100,),
              deteleImage: Image.asset("images/icon_delete.png", fit: BoxFit.fill, width: 25, height: 25,),
              onPressed: () {
                ddlog("onPressed");
              },
              onDetele: (){
                ddlog("onDetele");
              },
            ),

            Divider(),
            _buildSectionTitle("SpreadArea"),
            OutlinedButton(
                onPressed: () {
                  ddlog("OutlinedButton");
                },
                child:Text("OutlinedButton")
            ),
            _buildSpreadArea(),

            Divider(),
            _buildSectionTitle("GestureDetectorContainer"),
            GestureDetectorContainer(
              // edge: EdgeInsets.all(10),
              color: Colors.orange,
              onTap: (){
                ddlog("onTap");
              },
              child: OutlinedButton(
                child: Text("OutlinedButton"),
                onPressed: (){
                  ddlog("onPressed");
                },
              ),
            ),

            Divider(),
            _buildSectionTitle("_buildCustomPaint"),
            _buildCustomPaint(),

            Divider(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  // width: 100,
                  color: Colors.green,
                  child:  Column(
                      children: [
                        Text("07-08"),
                        Text("13:20"),
                      ]
                  ),
                ),
                // _buildTimeLineIndicator(0),
                Icon(Icons.add_circle, color: Colors.green),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "新建工单",
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                          maxLines: 2,
                        ),
                        SizedBox(height: 3, ),
                        Text(
                          "备注：降价1000客户可考虑，辛苦再撮合;备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Divider(),
            _buildSectionTitle("buildCustome"),
            _buildCustome(),

            Divider(),

          ],
        ),
      ],
    );
  }

  _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
    );
  }

  buildGridView() {
    return GridView.count(
      padding: EdgeInsets.all(15.0),
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 4 / 3,
      children: _tuples
          .map((e) => GridTile(
                footer: Container(
                    color: Colors.green,
                    height: 25,
                    child: Center(child: Text(e.item1))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      e.item2,
                    ]),
              ))
          .toList(),
    );
  }

  List<Tuple2<String, Widget>> get _tuples {
    return <Tuple2<String, Widget>>[
      Tuple2(
      "ClipRRectGradientButton",
      _buildClipRRectGradientButton(),
      ),
      Tuple2(
        "ElevatedButton",
        ElevatedButton.icon(
          icon: Icon(Icons.send),
          label: Text("ElevatedButton"),
          key: _globalKey,
          onPressed: () {
            // _showCustomPopView();
            ddlog([_globalKey.position(), _globalKey.size]);
            // test();
          },
        ),
      ),

      Tuple2(
        "OutlinedButton",
        OutlinedButton.icon(
          icon: Icon(Icons.add),
          label: Text("OutlinedButton"),
          key: _globalKey1,
          onPressed: () {
            ddlog([_globalKey1.position(), _globalKey1.size]);
            // test();
          },
        ),
      ),

      Tuple2(
        "TextButton",
        TextButton(
          onPressed: () => ddlog('$this'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'TextButton',
              ).padding(right: 5),
              // SizedBox(width: 30),
              Icon(Icons.call),
            ],
          ),
        ),
      ),

      Tuple2(
        "TextButton",
        TextButton(
          onPressed: () => ddlog('TextButton'),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("TextButton"),
              SizedBox(width: 5),
              Icon(Icons.send),
            ],
          ),
        ),
      ),

      // WidgetExt.buildBtn("菜单", Icon(Icons.send), ImageAlignment.right),
      Tuple2(
        "TextButtonExt",
        TextButtonExt.build(
            text: Text("个人信息"),
            image: Icon(Icons.person),
            imageAlignment: ImageAlignment.right,
            callback: (value, tag) {
              ddlog(value.data);
            }),
      ),

      Tuple2(
          "TextButtonExt",
          TextButtonExt.build(
              text: Text("菜单left"),
              image: Icon(Icons.info),
              imageAlignment: ImageAlignment.left,
              callback: (value, tag) {
                ddlog(value.data);
              })),

      Tuple2(
        "TextButtonExt",
        TextButtonExt.build(
            text: Text("菜单right"),
            image: Icon(Icons.info),
            imageAlignment: ImageAlignment.right,
            callback: (value, tag) {
              ddlog(value.data);
            }),
      ),

      Tuple2(
          "TextButtonExt",
          TextButtonExt.build(
              text: Text("菜单top"),
              image: Icon(Icons.info),
              imageAlignment: ImageAlignment.top,
              callback: (value, tag) {
                ddlog(value.data);
              })),

      Tuple2(
        "TextButtonExt",
        TextButtonExt.build(
            text: Text("菜单bottom"),
            image: Icon(Icons.info),
            imageAlignment: ImageAlignment.bottom,
            callback: (value, tag) {
              ddlog(value.data);
            }),
      ),

      Tuple2(
        "IconButton",
        IconButton(
          tooltip: '这是一个图标按钮',
          icon: Icon(Icons.person),
          iconSize: 30,
          color: Theme.of(context).accentColor,
          onPressed: () {
            ddlog("这是一个图标按钮");
          },
        ),
      ),

      Tuple2(
        "ToggleButtons",
        buildToggleButtons(context),
      ),

      Tuple2(
        "FloatingActionButton",
        FloatingActionButton(
          mini: true,
          backgroundColor: const Color(0xff03dac6),
          foregroundColor: Colors.black,
          onPressed: () {
            ddlog("FloatingActionButton");
          },
          child: Icon(Icons.open_with),
        ),
      ),

      Tuple2(
        "FloatingActionButton",
        FloatingActionButton.extended(
          backgroundColor: const Color(0xff03dac6),
          foregroundColor: Colors.black,
          onPressed: () {
            ddlog("FloatingActionButton.extended");
          },
          icon: Icon(Icons.add),
          label: Text('EXTENDED'),
        ),
      ),

      Tuple2(
        "DropdownButton",
        _buildDropdownButton(),
      ),
    ];
  }

  List<bool> _selecteds = [false, false, true];

  buildToggleButtons(BuildContext context) {
    return ToggleButtons(
      isSelected: _selecteds,
      children: <Widget>[
        Icon(Icons.format_align_right),
        Icon(Icons.format_align_center),
        Icon(Icons.format_align_left),
      ],
      onPressed: (index) {
        setState(() {
          _selecteds[index] = !_selecteds[index];
        });
      },
    );
  }

  var _dropValue = '语文';

  _buildDropdownButton() {
    var list = ['语文', '数学', '英语'];
    return DropdownButton(
      value: _dropValue,
      items: list
          .map(
            (e) => DropdownMenuItem(
              child: Text(e),
              value: e,
            ),
          )
          .toList(),
      onChanged: (value) {
        ddlog(value);
        if (value == null) return;
        setState(() {
          _dropValue = value as String;
        });
      },
    );
  }

  var dropdownvalue = 'Item 1';

  _buildDropdownButton1() {
    var items = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
    ];

    //Drop-Down
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(color: Colors.yellowAccent, border: Border.all()),
      child: DropdownButton(
        // Initial
        value: dropdownvalue,
        // Down Arrow
        icon: const Icon(Icons.keyboard_arrow_down),
        // Array list of
        items: items.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        // After selecting the desired option,it will
        // change button value to selected
        onChanged: (String? value) {
          setState(() {
            dropdownvalue = value!;
          });
        },
      ),
    );
  }

  _buildSpreadArea({EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 25)}) {
    return GestureDetector(
      ///这里设置behavior
      behavior: HitTestBehavior.translucent,
      onTap: (){
        ddlog("onTap");
      },
      child: Container(
        // height: 50,
        // width: 100,
        // color: Colors.transparent,
        color: Colors.yellow,
        padding: padding,
        child: OutlinedButton(
            onPressed: () {
              ddlog("OutlinedButton");
            },
            child:Text("OutlinedButton")),
      ),
    );
  }

  _buildCustomPaint() {
    return GestureDetector(
      onTap: (){
        ddlog("ontap");
      },
      child: Container(
        height: 100,
        width: 100,
        color: Colors.green,
        child: CustomPaint(
          painter: MyPainter(
            padding: EdgeInsets.only(top: 5, left: 10, bottom: 15, right: 20),
            color: Colors.yellow,
          ),
        ),
      ),
    );
  }



  Widget _buildLine(bool visible) {
    return Container(
      width: visible ? 10.0 : 0.0,
      height: 16.0,
      color: Colors.grey.shade400,
    );
  }

  _showCustomPopView() {
    Navigator.push(
      context,
      NNPopupRoute(
        child: Container(
          color: Colors.red,
          width: 91,
          height: 36,
          child: TextButton.icon(
            onPressed: () {
              ddlog("刷新");
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.refresh),
            label: Text("刷新"),
          ),
        ),
        onClick: () {
          print("exit");
        },
      ),
    );
  }

  _buildClipRRectGradientButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              primary: Colors.white,
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {},
            child: const Text('Gradient'),
          ),
        ],
      ),
    );
  }
// testPageRouteBuilder(){
// Navigator.of(context).push(
//     PageRouteBuilder(
//         barrierDismissible:true,
//         opaque:false,
//         barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//         barrierColor: Colors.black54,
//         transitionDuration: const Duration(milliseconds: 150),
//         pageBuilder: (p1, p2, p3) {
//           return Container(
//             padding: EdgeInsets.all(80),
//             color: Colors.black.withOpacity(0.3),
//             child: Container(
//               color: Colors.green,
//               child: TextButton(child: Text("button"),
//               onPressed: (){
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//           );
//         }
//     )
// ),
// }

  _buildCustome() {
    return Column(
      children: [
        SizedBox(
          height: 45,
          width: 200,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                elevation: 10, 
                shape: const StadiumBorder(),
            ),
            child: const Center(child: Text('Elevated Button')),
          ),
        ),
        SizedBox(
          height: 45,
          width: 60,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                elevation: 10, shape: const CircleBorder()),
            child: const Center(child: Icon(Icons.add)),
          ),
        ),

        Divider(),
        _buildSectionTitle("UIElevatedButton"),
        UIElevatedButton(
          height: 45,
          width: 200,
          child: Text('Elevated Button'),
          onPressed: () {
            print("Elevated");
          },
        ),
        UIElevatedButton(
          height: 45,
          width: 60,
          style: ElevatedButton.styleFrom(
              elevation: 4,
              shape: const CircleBorder(),
          ),
          child: const Center(child: Icon(Icons.add)),
          onPressed: () {
            print("Elevated");
          },
        ),

        Divider(),
        _buildSectionTitle("设置文字 3D效果"),
        Center(
          child: Text(
            'Hello, world!',
            style: TextStyle(
              fontSize: 42,
              color: Colors.pink,
              fontWeight: FontWeight.w900,
              shadows: shadow3D,
            ),
          ),
        ),

        Divider(),
        _buildSectionTitle("_buildInkWell"),
        _buildInkWell(),

        Divider(),
        _buildSectionTitle("_buildButtonBar"),
        _buildButtonBar(),
      ],
    );
  }


  int _volume = 0;
  _buildInkWell() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          InkWell(
            splashColor: Colors.green,
            highlightColor: Colors.blue,
            child: Icon(Icons.ring_volume, size: 30),
            onTap: () {
              setState(() {_volume += 2;});
            },
          ),
          Text(_volume.toString(), style: TextStyle(fontSize: 20)),
        ],
      );
    });
  }

  _buildButtonBar() {
    return ButtonBar(
        children: <Widget>[
          ElevatedButton(
            child: const Text ( 'Ok') ,
            onPressed: () {
              // To do
            },
          ),
          ElevatedButton(
            child: const Text ('Cancel') ,
            onPressed: () {
              // To do
            },
          ),
        ]
    );
  }

}


/// 自定义按钮
class UIElevatedButton extends StatelessWidget {

  const UIElevatedButton({
  	Key? key,
    this.width,
    this.height,
    this.child,
    required this.onPressed,
    this.style,
  }) : super(key: key);

  /// If non-null, requires the child to have exactly this width.
  final double? width;

  /// If non-null, requires the child to have exactly this height.
  final double? height;

  final Widget? child;

  final VoidCallback onPressed;

  final ButtonStyle? style;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.height,
      width: this.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style ?? ElevatedButton.styleFrom(
          elevation: 4,
          shape: const StadiumBorder(),
        ),
        child: child ?? const Center(child: Text('UIElevatedButton')),
      ),
    );
  }
}