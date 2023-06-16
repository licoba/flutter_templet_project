import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:get/get.dart';

import 'package:flutter_templet_project/extension/ddlog.dart';

import 'package:flutter_templet_project/basicWidget/chioce_list.dart';
import 'package:flutter_templet_project/basicWidget/chioce_wrap.dart';
import 'package:flutter_templet_project/extension/bottom_sheet_ext.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:tuple/tuple.dart';


class AlertSheetDemo extends StatefulWidget {
  const AlertSheetDemo({Key? key}) : super(key: key);


  @override
  _AlertSheetDemoState createState() => _AlertSheetDemoState();
}

class _AlertSheetDemoState extends State<AlertSheetDemo> {

  var titles = ["默认样式", "ListTile", "添加子视图", "自定义", "单选列表", "多选列表", "6", "7", "8"];

  final title = "新版本 v${2.1}";
  final message = """
1、支持立体声蓝牙耳机，同时改善配对性能;
2、提供屏幕虚拟键盘;
3、更简洁更流畅，使用起来更快;
4、修复一些软件在使用时自动退出bug;
""";


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text("$widget"),
        ),
        body: buildWrap()
    );
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

  _onPressed(int e) {
    switch (e) {
      case 1:
          showAlertSheetListTile();
        break;

      case 2:
        {
          CupertinoActionSheet(
            title: Text(title),
            message: Text(message),
            actions: [
              Container(
                color: Colors.lightGreen,
                height: 300,
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
          ).toShowCupertinoModalPopup(context: context);
        }
        break;

      case 3:
        {
          BottomSheetExt.presentSheet(
            context: context,
            title: title,
            onCancel: (){
              debugPrint("取消");
            },
            onConfirm: (){
              debugPrint("确定");
            },
            content: Container(
              child: Column(
                children: [
                  Text(message),
                  ...titles.map((e) {
                    return Column(
                      children: [
                        ListTile(title: Text(e),),
                        Divider(),
                      ],
                    );
                  }).toList(),
                ],
              ),
            )
          );
        }
        break;

      case 4:
        {
          _showChioceList(isMutiple: false);

        }
        break;

      case 5:
        {
          _showChioceList(isMutiple: true);

        }
        break;

      case 6:
        {
          // List<String> list = List.generate(100, (i) => 'item $i');
          // showSearch(context: context, delegate: CustomSearchDelegate(list: list, select: ""));
          Get.toNamed(APPRouter.showSearchDemo, arguments: []);
        }
        break;
      case 7:
        {
          context.showCupertinoSheet(
            title: Text(title),
            message: Text(message, textAlign: TextAlign.start),
            items: List.generate(5, (index) => Text("item_$index")).toList(),
            cancel: Text('取消'),
            onSelect: (BuildContext context, int index) {
              debugPrint(index.toString());
            },
            onCancell: (BuildContext context) {
              debugPrint('onCancell');
              Navigator.pop(context);
            },
          );
        }
        break;
      // case 8:
      //   {
      //
      //   }
      //   break;

      default:
          showAlertSheet();
        break;
    }
    // ddlog(e);
  }

  /// ios 弹窗
  void showAlertSheet({
    Widget title = const Text("请选择"),
    Widget? message,
    List<Widget>? actions,
    ScrollController? messageScrollController,
    ScrollController? actionScrollController,
  }) {
    CupertinoActionSheet(
      messageScrollController: messageScrollController,
      actionScrollController: actionScrollController,
      title: title,
      message: message,
      actions: actions ?? ["选择 1", "选择 2", "选择 3",].map((e) => CupertinoActionSheetAction(
        onPressed: () {
          ddlog(e);
          Navigator.pop(context);
        },
        child: Text(e),
      ),).toList(),
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('取消'),
      ),
    ).toShowCupertinoModalPopup(context: context);
  }

  showAlertSheetListTile() {
      final actions = [
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Add account'),
          trailing: Icon(Icons.check),
          onTap: () {
            ddlog("account");
            Navigator.pop(context);

          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Manage accounts'),
          onTap: () {
            ddlog("accounts");
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text(
            "Your Profile",
          ),
          onTap: () {
            ddlog("Profile");
            Navigator.pop(context);
          },
        ),
      ];

      CupertinoActionSheet(
        title: Text(title),
        message: Text(message, textAlign: TextAlign.left,),
        actions: [
          Material(
            type: MaterialType.canvas,
            elevation: 0,
            borderOnForeground: true,
            clipBehavior: Clip.none,
            animationDuration: kThemeChangeDuration,
            child: ColoredBox(
              color: Colors.black.withAlpha(10),
              child: Column(
                children: actions,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('取消'),
        ),
      )
          .toShowCupertinoModalPopup(context: context)

      ;
    }

  void _showChioceList({required bool isMutiple}){

      CupertinoActionSheet(
        title: Text(title, style: TextStyle(fontSize: 18, color: Colors.black)),
        message: Text(message, textAlign: TextAlign.start,),
        actions: [
          ChioceList(
            isMutiple: isMutiple,
            backgroudColor: Colors.black.withAlpha(5),
            children: payTypes,
            indexs: [1],
            canScroll: false,
            callback: (indexs) {
              ddlog([indexs.runtimeType, indexs]);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('取消'),
        ),
      )
          .toShowCupertinoModalPopup(context: context)
      ;
    }
}



///单选列表
class RadioListChooseNewWidget extends StatefulWidget {
  RadioListChooseNewWidget({Key? key}) : super(key: key);

  Object? selectedIndex = 0;

  @override
  _RadioListChooseNewWidgetState createState() => _RadioListChooseNewWidgetState();
}


class _RadioListChooseNewWidgetState extends State<RadioListChooseNewWidget> {

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RadioListTile(
            value: 0,
            onChanged: (value) {
              _changeValue(value);
            },
            groupValue: widget.selectedIndex,
            title: Text("一级标题"),
            subtitle: Text("二级标题"),
            secondary: Icon(Icons.camera),
            selected: widget.selectedIndex == 0,
          ),
          RadioListTile(
            value: 1,
            onChanged: (value) {
              _changeValue(value);
            },
            groupValue: widget.selectedIndex,
            title: Text("一级标题"),
            subtitle: Text("二级标题"),
            secondary: Icon(Icons.palette),
            selected: widget.selectedIndex == 1,
          ),
        ],
      ),
    );
  }

  void _changeValue(Object? value){
    setState(() {
      widget.selectedIndex = value;
    });
  }
}


///单选菜单
class RadioTileSexWidget extends StatefulWidget {
  Object selectedIndex = 0;

  RadioTileSexWidget({Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  _RadioTileSexWidgetState createState() => _RadioTileSexWidgetState();
}


class _RadioTileSexWidgetState extends State<RadioTileSexWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 0,
                groupValue: widget.selectedIndex,
                onChanged: (value) {
                  _changeValue(value);
                },
              ),
              Text("男"),
              SizedBox(width: 20),
              Radio(
                value: 1,
                groupValue: widget.selectedIndex,
                onChanged: (value) {
                  _changeValue(value);
                },
              ),
              Text("女"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("你选择的是${widget.selectedIndex == 1 ? "男" : "女"}")
            ],
          )
        ],
      ),
    );
  }

  void _changeValue(Object? value){
    if (value == null){
      return;
    }
    setState(() {
      widget.selectedIndex = value;
    });
    ddlog(widget.selectedIndex);
  }
}

///支付方式
final payTypes = <Tuple4<String, String, Widget, bool>>[
  Tuple4("微信支付", "微信支付，不止支付", Icon(Icons.camera), false),
  Tuple4("阿里支付", "支付就用支付宝", Icon(Icons.palette), false),
  Tuple4("银联支付", "不打开APP就支付", Icon(Icons.payment), false),
].map((e) => ChioceDataModel(
    title: Text(e.item1),
    subtitle: Text(e.item2),
    secondary: e.item3,
    selected: e.item4
)).toList();