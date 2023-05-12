

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/uti/color_uti.dart';

///选择盒子
class NChoiceBox extends StatefulWidget {

  NChoiceBox({
    Key? key,
    required this.items,
    required this.onChanged,
    this.title,
    this.itemMargin = const EdgeInsets.symmetric(vertical: 4),
    this.itemColor = bgColor,
    this.itemSelectedColor = Colors.blue,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.wrapSpacing = 16,
    this.wrapRunSpacing = 12,
    this.wrapAlignment = WrapAlignment.start,
    this.isSingle = false,
  }) : super(key: key);

  List<ChoiceBoxModel> items;

  ValueChanged<List<ChoiceBoxModel>> onChanged;

  String? title;

  CrossAxisAlignment crossAxisAlignment;

  double wrapSpacing;

  double wrapRunSpacing;

  WrapAlignment wrapAlignment;

  EdgeInsets itemMargin;
  /// 元素背景色
  Color itemColor;
  /// 选中元素背景色
  Color itemSelectedColor;

  /// 是否单选
  bool isSingle;


  @override
  _NChoiceBoxState createState() => _NChoiceBoxState();
}

class _NChoiceBoxState extends State<NChoiceBox> {

  final _choicItems = <ChoiceBoxModel>[];
  /// 选中的 items
  List<ChoiceBoxModel> get seletectedItems => widget.items.where((e) => e.isSelected == true).toList();

  List<String> get seletectedItemNames => seletectedItems.map((e) => e.title).toList();

  @override
  void initState() {
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: [
        Wrap(
          spacing: widget.wrapSpacing,
          runSpacing: widget.wrapRunSpacing,
          alignment: WrapAlignment.spaceBetween,
          children: widget.items.map((e) => Theme(
            // data: ThemeData(canvasColor: widget.itemColor),
            data: ThemeData(canvasColor: Colors.transparent),
            child: ChoiceChip(
              label: Text(e.title,
                style: TextStyle(
                  color: e.isSelected == true ? Colors.white : fontColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
              ),),
              // padding: EdgeInsets.only(left: 15, right: 15),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              selected: e.isSelected == true,
              selectedColor: widget.itemSelectedColor,
              backgroundColor: widget.itemColor,
              onSelected: (bool selected) {
                for (final element in widget.items) {
                  if (element.id == e.id) {
                    element.isSelected = selected;
                  } else {
                    if (widget.isSingle) {
                      element.isSelected = false;
                    }
                  }
                }
                setState(() {});
                widget.onChanged(seletectedItems);
                // widget.onChanged(_choicItems);
                debugPrint("seletectedItemNames: ${seletectedItemNames}");
              },
            ),
          ),).toList(),
        ),
      ],
    );
  }
}

/// ChoiceBox组件匹配模型
class ChoiceBoxModel<T> {

  ChoiceBoxModel({
    required this.title,
    required this.id,
    required this.isSelected,
    this.data,
  }) ;

  String title;

  String id;

  bool isSelected;

  T? data;
}