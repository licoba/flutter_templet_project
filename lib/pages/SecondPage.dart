import 'dart:math';

import 'package:dash_painter/dash_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/basicWidget/GradientBoundPainter.dart';
import 'package:flutter_templet_project/basicWidget/after_layout_builder.dart';
import 'package:flutter_templet_project/basicWidget/n_dash_decoration.dart';
import 'package:flutter_templet_project/basicWidget/n_label_and_icon.dart';
import 'package:flutter_templet_project/basicWidget/n_painter_arc.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_text_button.dart';
import 'package:flutter_templet_project/basicWidget/radial_button.dart';
import 'package:flutter_templet_project/basicWidget/header.dart';
import 'package:flutter_templet_project/basicWidget/triangle_decoration.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/decoration_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/pages/demo/CirclePainter.dart';
import 'package:flutter_templet_project/basicWidget/n_popup_route.dart';
import 'package:flutter_templet_project/basicWidget/upload_button.dart';
import 'package:flutter_templet_project/extension/button_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/pages/demo/curve_painter.dart';
import 'package:flutter_templet_project/util/app_util.dart';

import 'package:tuple/tuple.dart';

class SecondPage extends StatefulWidget {
  final String? title;

  const SecondPage({Key? key, this.title}) : super(key: key);

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
        actions: [
          IconButton(
            icon: Icon(Icons.change_circle_outlined),
            color: Colors.white,
            onPressed: () {
              debugPrint("AppUti.navigatorKey: ${AppUtil.navigatorKey.currentWidget}");

              _isList = !_isList;
              setState(() {});
            },
          ),
        ],
      ),
      body: Center(
        child: _isList ? buildListView() : buildGridView(),
      ),
    );
  }

  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey _globalKey1 = GlobalKey();

  buildListView() {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildSection(
              title: "RadialButton",
              child: Column(
                children: [
                  ...[
                    Alignment.topRight,
                    Alignment.centerRight,
                    Alignment.bottomRight,
                    Alignment.center,
                  ].map((e) => RadialButton(
                    text: Text('一二'),
                    center: e,
                    onTap: () => debugPrint("RadialButton"),
                  )).toList(),
                  ...[
                    Alignment.topRight,
                    Alignment.centerRight,
                    Alignment.bottomRight,
                  ].map((e) => RadialButton(
                    text: Text('一二三四五六'),
                    center: e,
                    onTap: () => debugPrint("RadialButton"),
                  )).toList(),
                ],
              ),
            ),
            buildSection(
              title: "AfterLayoutBuilder",
              child: AfterLayoutBuilder(
                builder: (BuildContext context, Widget? child, Size? size) {
                  debugPrint("AfterLayoutBuilder size:$size");
                  if (size == null) {
                    return child ?? SizedBox();
                  }
                  return Container(
                    color: Colors.greenAccent,
                    child: child,
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: SelectableText("离离原上草, 一岁一枯荣")
                ),
              ),
            ),
            buildSection(
              title: "LinearGradient",
              child: _buildGradientButton(
                onTap: () => debugPrint("LinearGradient"),
              ),
            ),
            buildSection(
              title: "MaterialButton",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    elevation: 0,
                    color: context.primaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    onPressed: () => debugPrint("MaterialButton: ${DateTime.now()}"),
                    child: Text("MaterialButton",),
                  ),
                  MaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    minWidth: 0,
                    textColor: context.primaryColor,
                    // color: Colors.green,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: context.primaryColor,),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onPressed: () {
                      debugPrint("MaterialButton");
                    },
                    child: NLabelAndIcon(
                      label: Text("MaterialButton"),
                      icon: Icon(Icons.info),
                    ),
                  ),
                ],
              ),
            ),
            buildSection(
              title: "BackButton",
              child: BackButton(
                color: Colors.red,
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.all(1)),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: MaterialStatePropertyAll(Size(24, 24)),
                  // fixedSize: MaterialStatePropertyAll(Size(24, 24)),
                ),
                onPressed: () => debugPrint("BackButton"),
              ).toColoredBox(),
            ),
            buildSection(
              title: "IconButton",
              child: IconButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size(50, 18),
                  // backgroundColor: Colors.green.withOpacity(0.1),
                  // foregroundColor: Colors.green,
                ),
                tooltip: '这是一个图标按钮',
                icon: Icon(Icons.arrow_back_ios_new),
                iconSize: 30,
                color: Theme.of(context).colorScheme.primary,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {
                  ddlog("这是一个图标按钮");
                },
              ).toColoredBox(),
            ),
            buildSection(
              title: "FilledButton",
              child: Row(
                children: [
                  FilledButton(
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
            ),
            buildSection(
              title: "TextButton",
              child: Row(
                children: [

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
                  TextButton(
                    style: TextButton.styleFrom(
                      // padding: EdgeInsets.zero,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size(50, 18),
                      backgroundColor: Colors.green.withOpacity(0.1),
                      foregroundColor: Colors.green,
                    ),
                    onPressed: () => ddlog('TextButton'),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("TextButton"),
                        SizedBox(width: 5),
                        Icon(Icons.send),
                      ].reversed.toList(),
                    ),
                  ),
                ],
              ),
            ),
            buildSection(
              title: "OutlinedButton",
              child: OutlinedButton.icon(
                key: _globalKey1,
                icon: Icon(Icons.add),
                label: Text("OutlinedButton"),
                onPressed: () {
                  ddlog([_globalKey1.position(),
                    _globalKey1.size]);
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  side: BorderSide(
                      width: 1.0,
                      color: Theme.of(context).colorScheme.secondary,
                      style: BorderStyle.solid
                  ),
                ),
              ),
            ),
            buildSection(
              title: "ElevatedButton",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: TextDirection.values.reversed.map((e){
                  return Directionality(
                    textDirection: e,
                    child: ElevatedButton.icon(
                      onPressed: () { debugPrint("ElevatedButton"); },
                      icon: Icon(Icons.send,),
                      label: Text("ElevatedButton"),
                    )
                  );
                }).toList(),
              ),
            ),
            buildSection(
              title: "ElevatedButton",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      elevation: 4,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      debugPrint("Elevated");
                    },
                    child: Text('Elevated Button'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      elevation: 4,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      debugPrint("Elevated");
                    },
                    child: const Center(child: Icon(Icons.add)),
                  ),
                ],
              ),
            ),
            buildSection(
              title: "ElevatedButton OutlinedBorder",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.red),
                  ),
                  StadiumBorder(
                    side: BorderSide(width: 1, style: BorderStyle.solid),
                  ),
                  CircleBorder(
                    // side: BorderSide(color: Colors.yellow, width: 2, style: BorderStyle.solid),
                    // eccentricity: 0.0,
                  ),
                ].map((e){
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size(50, 18),
                      shape: e,
                    ),
                    onPressed: () {
                      debugPrint("ElevatedButton ButtonStyle");
                    },
                    child: Text("确定",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            buildSection(
              title: "FloatingActionButton",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton.extended(
                    extendedIconLabelSpacing: 0,
                    elevation: 0,
                    // isExtended: false,
                    extendedPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    backgroundColor: const Color(0xff03dac6),
                    // foregroundColor: Colors.black,
                    onPressed: () {
                      ddlog("FloatingActionButton.extended");
                    },
                    icon: SizedBox(),
                    label: Text('EXTEND'.toLowerCase()),
                  ),
                  FloatingActionButton(
                    mini: true,
                    elevation: 0,
                    backgroundColor: const Color(0xff03dac6),
                    // foregroundColor: Colors.black,
                    onPressed: () {
                      ddlog("FloatingActionButton");
                    },
                    child: Icon(Icons.open_with),
                  ),
                  FloatingActionButton.extended(
                    elevation: 0,
                    // isExtended: false,
                    extendedPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    backgroundColor: const Color(0xff03dac6),
                    // foregroundColor: Colors.black,
                    onPressed: () {
                      ddlog("FloatingActionButton.extended");
                    },
                    icon: Icon(Icons.add),
                    label: Text('EXTEND'.toLowerCase()),
                  ),
                ],
              ),
            ),
            buildSection(
              title: "TextSelectionToolbarTextButton",
              child: TextSelectionToolbarTextButton(
                padding: EdgeInsets.all(8),
                onPressed: (){
                    debugPrint("TextSelectionToolbarTextButton");
                },
                child: Text("TextSelectionToolbarTextButton"),
              ),
            ),
            buildSection(
              title: "NLabelAndIcon + OutlinedButton",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: iconDirectionItems().map((e) => OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(8.0),
                      // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      side: BorderSide(color: ColorExt.random),
                    ),
                    onPressed: () {
                      debugPrint("TextButton");
                    },
                    child: e,
                  )).toList(),
              ),
            ),
            buildSection(
              title: "NLabelAndIcon + ElevatedButton",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: iconDirectionItems().map((e) => ElevatedButton(
                  // style: ElevatedButton.styleFrom(
                  //   padding: EdgeInsets.zero,
                  //   // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  //   side: BorderSide(color: ColorExt.random),
                  // ),
                  onPressed: () {
                    debugPrint("ElevatedButton");
                  },
                  child: e,
                ).copy(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8.0),
                    // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    // side: BorderSide(color: ColorExt.random),
                  ),
                )).toList(),
              ),
            ),
            buildSection(
              title: "ToggleButtons",
              child: buildToggleButtons(),
            ),
            buildSection(
              title: "DropdownButton",
              child: _buildDropdownButton()
            ),
            buildSection(
              title: "_buildDropdownButton1",
              child: _buildDropdownButton1()
            ),
            buildSection(
              title: "_buildPopupMenuButtonExt",
              child: _buildPopupMenuButtonExt()
            ),
            buildSection(
              title: "UploadButton",
              child: UploadButton(
                image: Image.asset("img_update.png".toPath(),
                  fit: BoxFit.fill,
                  width: 100,
                  height: 100,
                ),
                deteleImage: Image.asset("icon_delete.png".toPath(),
                  fit: BoxFit.fill,
                  width: 25,
                  height: 25,
                ),
                onPressed: () {
                  ddlog("onPressed");
                },
                onDetele: (){
                  ddlog("onDetele");
                },
              ),
            ),
            buildSection(
              title: "SpreadArea",
              child: Column(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      ddlog("OutlinedButton");
                    },
                    child: Text("OutlinedButton")
                  ),
                  GestureDetector(
                    ///这里设置behavior
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      ddlog("onTap");
                    },
                    child: Container(
                      color: Colors.yellow,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: OutlinedButton(
                        onPressed: () {
                          ddlog("OutlinedButton");
                        },
                        child: Text("OutlinedButton")
                      ),
                    ),
                  )
                ],
              ),
            ),
            buildSection(
              title: "_buildCustomPaint",
              child: _buildCustomPaint()
            ),
            buildSection(
              title: "MyPainterArc",
              child: Container(
                height: 100,
                width: 120,
                // color: Colors.green,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: CustomPaint(
                    painter: NPainterArc(
                      color: Colors.yellow,
                      percent: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            buildSection(
              title: "_buildInkWell",
              child: _buildInkWell(),
            ),
            buildSection(
              title: "_buildButtonBar",
              child: ButtonBar(
                children: ['Ok', 'Cancel', ].map((e) => ElevatedButton(
                  onPressed: () {
                    debugPrint(e);
                  },
                  child: Text(e),
                )).toList(),
              ),
            ),
            Container(
              height: 100,
              width: 100,
              child: CustomPaint(
                painter: CurvePainter(
                  color: Colors.yellow,
                ),
              ),
            ),
            Container(
              width: 160,
              height: 60,
              decoration: NDashDecoration(
                step: 4,
                // pointWidth: 2,
                // pointCount: 1,
                radius: Radius.circular(15),
                strokeWidth: 1,
                strokeColor: Colors.red,
              ),
              alignment: Alignment.center,
              child: Text("自定义虚线\nNDashDecoration"),
            ),
            SizedBox(height: 8,),
            Container(
              width: 160,
              height: 60,
              decoration: DashDecoration(
                step: 5,
                span: 5,
                // pointCount: 0,
                pointWidth: 1,
                radius: Radius.circular(15),
                gradient: SweepGradient(
                  colors: [
                    Colors.blue,
                    Colors.red,
                    Colors.yellow,
                    Colors.green
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Text("dash_painter"),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: TriangleDecoration(color: Colors.red, size: 8.0),
              child: NText("TriangleDecoration"),
            ),
            SizedBox(height: 20,),

            _buildGradientBound(),
            SizedBox(height: 20,),

            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildSection({required String title, required Widget child}) {
    return Column(
      children: [
        Divider(),
        NHeader.h5(title: title),
        child,
      ],
    );
  }

  /// icon 上下左右
  List<NLabelAndIcon> iconDirectionItems() {
    return [
      NLabelAndIcon(
        label: Text("left"),
        icon: Icon(Icons.info),
      ),
      NLabelAndIcon(
        label: Text("right"),
        icon: Icon(Icons.info),
        isReverse: true,
      ),
      NLabelAndIcon(
        label: Text("top"),
        icon: Icon(Icons.info),
        direction: Axis.vertical,
      ),
      NLabelAndIcon(
        label: Text("bottom"),
        icon: Icon(Icons.info),
        direction: Axis.vertical,
        isReverse: true,
      ),
    ];
  }

  buildGridView() {
    return GridView.count(
      padding: EdgeInsets.all(15.0),
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 4 / 3,
      children: _tuples.map((e) => GridTile(
        footer: Container(
          color: Colors.green,
          height: 25,
          child: Center(child: Text(e.item1))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            e.item2,
          ]
        ),
      )).toList(),
    );
  }

  List<Tuple2<String, Widget>> get _tuples {
    return <Tuple2<String, Widget>>[
      Tuple2(
      "ClipRRectGradientButton",
      _buildGradientButton(),
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
              ),
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
      Tuple2(
        "IconButton",
        IconButton(
          tooltip: '这是一个图标按钮',
          icon: Icon(Icons.person),
          iconSize: 30,
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            ddlog("这是一个图标按钮");
          },
        ),
      ),
      Tuple2(
        "ToggleButtons",
        buildToggleButtons(),
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

  final List<bool> _selecteds = [false, false, true];

  Widget buildToggleButtons() {
    return ToggleButtons(
      isSelected: _selecteds,
      onPressed: (index) {
        _selecteds[index] = !_selecteds[index];
        setState(() {});
        debugPrint("ToggleButtons _selecteds: $_selecteds");
      },
      children: <Widget>[
        Icon(Icons.format_align_right),
        Icon(Icons.format_align_center),
        Icon(Icons.format_align_left),
      ],
    );
  }

  var _dropValue = '语文';

  Widget _buildDropdownButton() {
    var list = ['语文', '数学', '英语'];
    return DropdownButton(
      value: _dropValue,
      items: list.map((e) => DropdownMenuItem(
          value: e,
          child: Text(e),
        ),
      ).toList(),
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

  Widget _buildDropdownButton1() {
    var items = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
    ];

    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(color: Colors.greenAccent, border: Border.all()),
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

  Widget _buildPopupMenuButtonExt() {
    final json = {
    "aa": "0",
    "bb": "1",
    "cc": "2"
    };
    return Column(
      children: [
        PopupMenuButtonExt.fromJson<String>(
          child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.greenAccent, border: Border.all()),
              child: Text('PopupMenuButtonExt.fromJson')
          ),
          json: json,
          onSelected: (value) {
            setState(() => ddlog(value));
          }
        ),

        PopupMenuButtonExt.fromEntryJson(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.greenAccent, border: Border.all()),
            child: Text('PopupMenuButtonExt.fromEntryJson')
          ),
          json: json,
          checkedString: "aa",
          callback: (value) {
            setState(() => ddlog(value));
          }
        ),

        PopupMenuButtonExt.fromCheckList(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.greenAccent, border: Border.all()),
            child: Text('PopupMenuButtonExt.fromCheckList')
          ),
          list: ["a", "b", "c"],
          checkedIdx: 1,
          callback: (value) {
            setState(() => ddlog(value));
          }
        ),
      ]
    );
  }

  Widget _buildCustomPaint() {
    return GestureDetector(
      onTap: (){
        ddlog("ontap");
      },
      child: Container(
        height: 100,
        width: 100,
        color: Colors.green,
        child: CustomPaint(
          painter: CirclePainter(
            color: Colors.yellow,
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    Gradient? gradient,
    Widget? child,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: gradient ?? LinearGradient(
            colors: <Color>[
              context.primaryColor,
              context.primaryColor.withOpacity(0.5),
            ],
          ),
        ),
        child: child ?? Text("LinearGradient",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }


  Widget _buildGradientBound({
    Gradient? gradient,
    Widget? child,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 48,
        child: CustomPaint(
          painter: GradientBorderPainter(
            // width: constraints.maxWidth,
            // height: constraints.maxHeight,
              colors: [
                const Color(0xFFFA709A),
                const Color(0xFFFA709A).withOpacity(0.3),
              ]
          ),
          child: Center(child: Text("GradientBoundPainter")),
        ),
      ),
    );
  }

  int _volume = 0;
  Widget _buildInkWell() {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          InkWell(
            splashColor: Colors.green,
            highlightColor: Colors.blue,
            onTap: () {
              _volume += 2;
              setState(() {});
            },
            child: NLabelAndIcon(
              direction: Axis.vertical,
              label: Text(_volume.toString(), style: TextStyle(fontSize: 20)),
              icon: Icon(Icons.ring_volume, size: 30),
            ),
          ),
        ],
      );
    });
  }
  
}


