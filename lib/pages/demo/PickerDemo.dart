import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/PickerUtil.dart';
import 'package:flutter_templet_project/basicWidget/n_picker_tool_bar.dart';
import 'package:flutter_templet_project/basicWidget/chioce_wrap.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/date_time_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/basicWidget/chioce_list.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/mixin/bottom_sheet_mixin.dart';
import 'package:flutter_templet_project/pages/demo/AlertSheetDemo.dart';

import 'package:flutter_templet_project/pages/demo/ListTileDemo.dart';
import 'package:get_storage/get_storage.dart';

class PickerDemo extends StatefulWidget {
  const PickerDemo({Key? key}) : super(key: key);

  @override
  _PickerDemoState createState() => _PickerDemoState();
}

class _PickerDemoState extends State<PickerDemo> with BottomSheetMixin {

  var title = "";

  late final List<({String name, VoidCallback action})> items = [
    (name: "datePicker", action: onDate),
    (name: "datePicker mixin封装", action: onDateMixin),
    (name: "Picker浅封装", action: onSelect),
    (name: "自定义", action: onCustom),
    (name: "单选滚动列表", action: onSingle),
    (name: "多选滚动列表", action: onMuti),
    (name: "多种类按钮", action: onPage),
    (name: "日期选择", action: onCalendarDate),
    (name: "日期时段选择", action: onRangeDate),
    (name: "单项选择", action: onSingleOne),
    (name: "多项选择", action: onWeight),
  ];


  /// 体重
  final weightData = <List<String>>[
    List<String>.generate(240, (index) => (index + 10).toString()).toList(),
    List<String>.generate(10, (index) => '.$index').toList(),
  ];

  late final weightSelectedData = [
    weightData[0][1],
    weightData[1][1],
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildGridView(),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      padding: EdgeInsets.all(15.0),
      //一行多少个
      crossAxisCount: 3,
      //滚动方向
      scrollDirection: Axis.vertical,
      // 左右间隔
      crossAxisSpacing: 8,
      // 上下间隔
      mainAxisSpacing: 8,
      //宽高比
      childAspectRatio: 1 / 0.3,
      children: items.map((e) {
        final i = items.indexOf(e);

        return OutlinedButton(
          onPressed: e.action,
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 1.0, color: Colors.blue),
            padding: EdgeInsets.all(0),
          ),
          child: Text('${e.name}_${i}',
              style: TextStyle(fontSize: 12,
                color: Colors.black87,
              )
          ),
        );
      }).toList(),
    );
  }

  Future<void> onDate() async {
    _showDatePicker(
      context: context,
      onCancel: (){
        ddlog("${DateTime.now()}");
        Navigator.of(context).pop();
      },
      onConfirm: () {
        ddlog("${DateTime.now()}");
        Navigator.of(context).pop();
      },
      onDateTimeChanged: (DateTime val) {
        debugPrint("${val}");
      },
    );
  }

  Future<void> onDateMixin() async {
    presentCupertinoDatePicker(
      context: context,
      onDateTimeConfirm: (DateTime val) {
        debugPrint("${val}");
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> onSelect() async {
    var _selectedValue = 0;

    presentBottomSheet(
      context: context,
      onConfirm: () {
        debugPrint("${DateTime.now()} ${_selectedValue}");
        Navigator.of(context).pop();
      },
      child: CupertinoPicker(
        backgroundColor: Colors.white,
        itemExtent: 30,
        scrollController: FixedExtentScrollController(
            initialItem: _selectedValue),
        onSelectedItemChanged: (val) {
          _selectedValue = val;
      // setState(() {});
        },
        children: List.generate(10, (index) {
          return Text('选择_$index',
            style: TextStyle(fontSize: 16),
          );
        }),
      ),
    );
  }

  Future<void> onCustom() async {
    presentBottomSheet(
      context: context,
// height: 600,
      onConfirm: () {
        debugPrint("${DateTime.now()}");
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.green,
// height: 500,
        child: TextButton(
          onPressed: () {
            ddlog("Button");
          }, child: Text("Button"),
        ),
      ),
    );
  }

  Future<void> onSingle() async {
    presentBottomSheet(
      context: context,
// height: 500,
      onConfirm: () {
        debugPrint("${DateTime.now()}");
        Navigator.of(context).pop();
      },
      child: Material(
        child: Container(
// color: Colors.green,
          child: ChioceList(
// isMutiple: true,
            children: payTypes * 5,
            indexs: [0],
            canScroll: true,
            callback: (Object index) {
              ddlog(index);
            },
          ),
        ),
      ),
    );
  }

  Future<void> onMuti() async {
    presentBottomSheet(
      context: context,
// height: 600,
      onConfirm: () {
        debugPrint("${DateTime.now()}");
        Navigator.of(context).pop();
      },
      child: Container(
// color: Colors.green,
// height: 500,
        child: ChioceList(
          isMutiple: true,
          children: payTypes * 5,
          indexs: [0],
          canScroll: true,
          callback: (Object index) {
            ddlog(index);
          },
        ),
      ),
    );
  }

  Future<void> onPage() async {
    presentBottomSheet(
      context: context,
// height: 600,
      onConfirm: () {
        debugPrint("${DateTime.now()}");
        Navigator.of(context).pop();
      },
      child: Container(
// height: 300,
          child: ListTileDemo()
      ),
    );
  }

  Future<void> onCalendarDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2020, 11, 17),
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'Select a date',
    );

    title = newDate.toString();
    setState(() {});
  }

  Future<void> onRangeDate() async {
    final dateRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime(2020, 11, 17),
        end: DateTime(2020, 11, 24),
      ),
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'Select a date',
    );

    title = dateRange.toString();
    setState(() {});
  }

  Future<void> onSingleOne() async {
    PickerUtil.show(
        context: context,
        data: weightData[0],
        selectedData: weightData[0][1],
        onChanged: (val) {
          debugPrint('onChanged: $val');
        },
        onSelected: (val) {
          debugPrint('onSelected: $val');
        },
        onConfirm: (val) {
          debugPrint('onConfirm: $val');
          Navigator.of(context).pop();
        },
        onCancel: () {
          Navigator.of(context).pop();
        }
    );
  }

  Future<void> onWeight() async {
    PickerUtil.showMultiple(
        context: context,
        data: weightData,
        selectedData: weightSelectedData,
        onChanged: (val) {
          debugPrint('onChanged: $val');
        },
        onSelected: (val) {
// debugPrint('onSelected: $val');
        },
        onConfirm: (selectedItems) {
          debugPrint('onConfirm: $selectedItems');
          Navigator.of(context).pop();
        },
        onCancel: () {
          Navigator.of(context).pop();
        }
    );
  }

  void _showDatePicker({
    required BuildContext context,
    DateTime? initialDateTime,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
    required ValueChanged<DateTime> onDateTimeChanged,
    VoidCallback? onCancel,
    required VoidCallback onConfirm,
  }) {
    var dateTime = initialDateTime ?? DateTime.now();

    showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return Container(
            height: 300,
            // color: Color.fromARGB(255, 255, 255, 255),
            color: Colors.white,
            child: Column(
              children: [
                NPickerToolBar(
                  onCancel: onCancel,
                  onConfirm: onConfirm,
                ),
                Divider(height: 1.0),
                Container(
                  height: 216,
                  color: Colors.white,
                  child: CupertinoDatePicker(
                      mode: mode,
                      initialDateTime: dateTime,
                      dateOrder: DatePickerDateOrder.ymd,
                      onDateTimeChanged: (val) {
                        dateTime = val;
                        onDateTimeChanged(val);
                        setState(() {});
                      }
                  ),
                ),
              ],
            ),
          );
        }
    );
  }


}


class DatePickerDemo extends StatefulWidget {

  DatePickerDemo({
    Key? key,
    this.dateTime,
    this.callback,
  }) : super(key: key);

  DateTime? dateTime = DateTime.now();

  void Function(DateTime dateTime)? callback;

  @override
  _DatePickerDemoState createState() => _DatePickerDemoState();
}

class _DatePickerDemoState extends State<DatePickerDemo> {

  @override
  Widget build(BuildContext context) {
    final time = widget.dateTime != null
        ? widget.dateTime!.toString19()
        : 'datetime picked';
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('$widget.dateTime'),
        // This button triggers the _showDatePicker function
        trailing: Container(child:
        CupertinoButton(
          padding: EdgeInsetsDirectional.zero,
          onPressed: () {
            // _showDatePicker(context);
            // _datePickerValueChange();
          },
          child: Text('Show Picker'),
        ),),
      ),
      child: SafeArea(
        child: Center(
            child: TextButton(
              onPressed: () {
                // _showDatePicker(context);
                //   _datePickerValueChange();
              },
              child: Text(time),
            )
        ),
      ),
    );
  }

///时间变动
// void _datePickerValueChange() {
//   context.showDatePicker(
//       mode: CupertinoDatePickerMode.date,
//       callback: (datetime, title){
//     ddlog("$datetime, $title");
//     if (title == "取消") {
//       return;
//     }
//     setState(() {
//       widget.dateTime = datetime;
//     });
//   });

// groovyScript("def result = ''; _1.split().eachWithIndex { item, index -> result = result + index.next() + '. ' + item + System.lineSeparator() }; return result;", SELECTION);
// groovyScript("return _editor.filePath().split('/').get(4)");
// }

}

