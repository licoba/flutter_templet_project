

import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

/// 新增折叠多选或单选菜单
class EnhanceExpansionChoic<T> extends StatefulWidget {

  EnhanceExpansionChoic({
    Key? key,
    this.primryColor = Colors.blue,
    this.trailingColor = Colors.blue,
    required this.title,
    this.trailingBuilder,
    required this.models,
    this.collapseCount = 6,
    this.isSingle = true,
    this.isExpand = false,
    required this.cbID,
    required this.cbTitle,
    required this.cbSelected,
    required this.onChanged,
  }) : super(key: key);

  /// chip 选择颜色
  Color primryColor;
  /// 尾部颜色
  Color? trailingColor;
  /// 标题
  Text title;

  /// 标签组
  List<T> models;
  /// 折叠时最小显示数量
  int collapseCount;
  /// 单选
  bool isSingle;
  /// 开始状态
  bool isExpand;
  /// 唯一标识符回调函数
  String Function(T) cbID;
  /// 标题回调函数
  String Function(T) cbTitle;
  /// 选择回调函数
  bool Function(T) cbSelected;
  /// 改变回调函数
  ValueChanged<List<ChoiceBoxModel<T>>> onChanged;
  /// 尾部组件构造函数
  Widget Function(bool isExpand)? trailingBuilder;


  @override
  _EnhanceExpansionChoicState<T> createState() => _EnhanceExpansionChoicState<T>();
}

class _EnhanceExpansionChoicState<T> extends State<EnhanceExpansionChoic<T>> {


  @override
  Widget build(BuildContext context) {

    return buildBoxChoic(
      color: widget.primryColor,
      trailingColor: widget.trailingColor,
      isSingle: widget.isSingle,
      title: widget.title,
      trailingBuilder: widget.trailingBuilder,
      models: widget.models,
      collapseCount: widget.collapseCount,
      cbID: widget.cbID,
      cbTitle: widget.cbTitle,
      cbSelected: widget.cbSelected,
      onChanged: widget.onChanged,
    );
  }

  /// 筛选弹窗 标签选择
  Widget buildBoxChoic({
    Color color = const Color(0xffFF7E6E),
    Color? trailingColor = const Color(0xffFF7E6E),
    required Text title,
    Widget Function(bool isExpand)? trailingBuilder,
    required List<T> models,
    required String Function(T) cbID,
    required String Function(T) cbTitle,
    required bool Function(T) cbSelected,
    required ValueChanged<List<ChoiceBoxModel<T>>> onChanged,
    bool isExpand = false,
    bool isSingle = true,
    int collapseCount = 6,
  }) {
    final disable = (models.length <= collapseCount);

    return StatefulBuilder(
      builder: (context, setState) {

        final items = isExpand ? models : models.take(collapseCount).toList();

        return buildExpandMenu(
          color: color,
          trailingColor: trailingColor,
          title: title,
          trailingBuilder: trailingBuilder,
          disable: disable,
          isExpand: isExpand,
          onExpansionChanged: (val) {
            isExpand = !isExpand;
            setState(() {});
          },
          childrenHeader: (onTap) => Column(
            children: [
              NChoiceBox(
                isSingle: isSingle,
                itemColor: Colors.transparent,
                items: items.map((e) => ChoiceBoxModel<T>(
                  id: cbID(e),
                  title: cbTitle(e),
                  isSelected: cbSelected(e),
                  data: e,
                )).toList(),
                onChanged: onChanged,
              ),
            ],
          ),
          children: [],
        );
      }
    );
  }


  Widget buildExpandMenu({
    required Text title,
    Widget Function(bool isExpand)? trailingBuilder,
    List<Widget> children = const [],
    bool isExpand = true,
    ValueChanged<bool>? onExpansionChanged,
    Color color = const Color(0xffFF7E6E),
    Color? trailingColor = const Color(0xffFF7E6E),
    bool disable = false,
    ExpansionWidgetBuilder? childrenHeader,
    ExpansionWidgetBuilder? childrenFooter,
  }) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: EnhanceExpansionTile(
        childrenHeader: childrenHeader,
        // childrenFooter: childrenFooter,
        // childrenFooter: (isOpen, onTap) => Container(
        //   height: 30,
        //   color: Colors.blueAccent,
        // ),
        tilePadding: const EdgeInsets.symmetric(horizontal: 0),
        // leading: Icon(Icons.ac_unit),
        // trailing: OutlinedButton.icon(
        //     onPressed: (){
        //       debugPrint("arrow");
        //     },
        //     icon: Icon(Icons.expand_more),
        //     label: Text("展开"),
        //   style: OutlinedButton.styleFrom(
        //     shape: StadiumBorder()
        //   ),
        // ),
        trailing: disable ? const SizedBox() : trailingBuilder?.call(isExpand) ?? buildTrailing(
          isExpand: isExpand,
          color: trailingColor ?? color,
        ),
        collapsedTextColor: fontColor,
        textColor: fontColor,
        iconColor: color,
        collapsedIconColor: color,
        title: title,
        initiallyExpanded: disable ? false : isExpand,
        onExpansionChanged: onExpansionChanged,
        children: children,
      ),
    );
  }

  buildTrailing({
    bool isExpand = true,
    Color color = Colors.blueAccent,
  }) {
    final title = isExpand ? "收起" : "展开";
    final icon = isExpand
        ? Icon(Icons.expand_less, size: 24, color: color,)
        : Icon(Icons.expand_more, size: 24, color: color,);

    // return Container(
    //   width: 70,
    //   height: 30,
    //   padding: EdgeInsets.only(left: 8.w, right: 8.w,),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.all(Radius.circular(15.w)),
    //     border: Border.all(color: color.withOpacity(0.3)),
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text(
    //         title,
    //         style: TextStyle(color: color),
    //       ),
    //       const SizedBox(width: 4,),
    //       icon,
    //     ],
    //   )
    // );


    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size(50, 18),
        maximumSize: Size(90, 35),
        foregroundColor: color,
        shape: StadiumBorder(),
        side: BorderSide(color: color.withOpacity(0.3)),

      ),
      onPressed: null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: color),
            ),
          ) ,
          icon,
        ],
      )
    );
  }

}


// mixin ChoicMixin{
//   String id;
//
// }