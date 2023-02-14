//
//  NnCollectionNavWidgetDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2/13/23 3:21 PM.
//  Copyright © 2/13/23 shang. All rights reserved.
//



import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/nn_collection_nav_widget.dart';
import 'package:flutter_templet_project/basicWidget/number_stepper.dart';
import 'package:flutter_templet_project/uti/R.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class NNCollectionNavWidgetDemo extends StatefulWidget {

  NNCollectionNavWidgetDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _NNCollectionNavWidgetDemoState createState() => _NNCollectionNavWidgetDemoState();
}

class _NNCollectionNavWidgetDemoState extends State<NNCollectionNavWidgetDemo> {

  List<String> imgUrls = R.image.imgUrls;

  var _items = <AttrNavItem>[];

  ///金刚区每页行数
  int pageRowNum = 2;
  ///金刚区每页列数
  int pageColumnNum = 5;

  /// 图标默认高度
  double iconSize = DEFALUT_ICON_SIZE;
  /// 垂直间距
  double columnSpacing = 16;
  /// 水平间距
  double rowSpacing = CROSS_AXIS_SP;
  /// 文字间距
  double textOffset = 5;

  var tuples = <Tuple4<String, int, int, Function>>[];

  // List<Function> get notifiers => tuples.map((e) => e.item4).toList();
  /// viewModel
  var _collectionNavModel = NNCollectionNavNotify();

  @override
  void initState() {
    _items = List.generate(imgUrls.length, (index) => AttrNavItem(
        icon: imgUrls[index],
        name: "标题_${index}"
      )
    );

    tuples = [
      Tuple4("列数 row", 1, 5, _collectionNavModel.changePageRowNum),
      Tuple4("行数 column", 1, 5, _collectionNavModel.changePageColumnNum),
      Tuple4("划动方式", 0, 2, _collectionNavModel.changeScrollTypeIndex),
      // Tuple4("行数", 1, 2, ValueNotifier(2)),
    ];

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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
      body: ListView(
        children: [
          Column(
            children: [
              ..._buildHeader(),

              AnimatedBuilder(
                animation: _collectionNavModel,
                builder: (context, child) {
                  print("AnimatedBuilder");
                  return NNCollectionNavWidget(
                    isDebug: true,
                    items: _items,
                    iconSize: 68,
                    textGap: 5,
                    pageColumnNum: _collectionNavModel.pageColumnNum,
                    pageRowNum: _collectionNavModel.pageRowNum,
                    scrollType: _collectionNavModel.scrollType,
                  );
                }
              ),
            ],
          )
        ]
      ),
    );
  }

  /// 多值变化
  List<Widget> _buildHeader() {
    return tuples.map((e) => Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(e.item1, style: TextStyle(fontSize: 20),),
          SizedBox(width: 10,),
          NumberStepper(
            minValue: e.item2,
            maxValue: e.item3,
            stepValue: 1,
            iconSize: 30,
            value: e.item3,
            color: Theme.of(context).primaryColor,
            style: NumberStepperStyle.outlined,
            block: (value){
              e.item4.call(value);
            },
          ),
        ],
      ),
    )).toList();
  }

  /// 多值监听
  Widget _buildAnimatedBuilder() {
    return AnimatedBuilder(
        animation: _collectionNavModel,
        builder: (context, child) {
          print("AnimatedBuilder");
          return NNCollectionNavWidget(
            isDebug: true,
            items: _items,
            iconSize: 68,
            textGap: 5,
            pageColumnNum: _collectionNavModel.pageColumnNum,
            pageRowNum: _collectionNavModel.pageRowNum,
            scrollType: _collectionNavModel.scrollType,
          );
        }
    );
  }


}


/// ChangeNotifier(不推荐使用,麻烦)
class NNCollectionNavNotify extends ChangeNotifier {

  ///金刚区每页行数
  int pageRowNum = 2;
  ///金刚区每页列数
  int pageColumnNum = 5;

  ///金刚区每页列数
  int scrollTypeIndex = 0;

  PageViewScrollType get scrollType => PageViewScrollTypeExt.allCases[scrollTypeIndex];

  void changePageRowNum(int value) {
    pageRowNum = value;
    notifyListeners();
  }

  void changePageColumnNum(int value) {
    pageColumnNum = value;
    notifyListeners();
  }

  void changeScrollTypeIndex(int value) {
    scrollTypeIndex = value;
    notifyListeners();
  }

  @override
  String toString() {
    return "${this.runtimeType}_pageRowNum:${pageRowNum}_pageColumnNum:${pageColumnNum}_scrollType:${scrollType}";
  }
}