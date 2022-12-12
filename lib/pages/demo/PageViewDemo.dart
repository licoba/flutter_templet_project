import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/pages/FirstPage.dart';
import 'package:flutter_templet_project/pages/SecondPage.dart';
import 'package:flutter_templet_project/pages/ThirdPage.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';

import 'package:get/get.dart';

import 'package:flutter_templet_project/extension/actionSheet_extension.dart';
import 'package:flutter_templet_project/extension/widget_extension.dart';
import 'package:tuple/tuple.dart';


class PageViewDemo extends StatefulWidget {

  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {

  var titles = ["PageViewTabBarWidget", "2", "3"];

  final title = "新版本 v${2.1}";
  final message = """
1、支持立体声蓝牙耳机，同时改善配对性能;
2、提供屏幕虚拟键盘;
3、更简洁更流畅，使用起来更快;
4、修复一些软件在使用时自动退出bug;
""";

  final rightTitles = ["默认", "done"];



  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: rightTitles.map((e) => TextButton(
          onPressed: (){
            _actionTap(value: e);
          },
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
        )).toList(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildPageView(),
      ),
    );
  }

  Widget buildPageView() {
    return PageView(
      scrollDirection: Axis.horizontal,
      pageSnapping: true,
      onPageChanged: (index){
        print('当前为第$index页');
      },
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
          ),
          child: Center(child: Text('第0页')),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
          ),
          child: Center(child: Text('第1页')),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text('第2页')),
        ),
      ],
    );
  }

  void _actionTap({required String value}) {
    switch(value){
      case "自定义":
        {

        }
        break;
      default:
        {
          CupertinoActionSheet(
            title: Text(title),
            message: Text(message),
            actions: titles.map((e) => CupertinoActionSheetAction(
              child: Text(e),
              onPressed: () {
                ddlog(e);
                Navigator.pop(context);
                Get.toNamed(APPRouter.pageViewTabBarWidget);
              },
            ),).toList(),
            cancelButton: CupertinoActionSheetAction(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
              .toShowCupertinoModalPopup(context: context)
          ;
        }
        break;
    }
  }

}

/*--------------------------------------------------------------------------------------------------*/

class PageViewTabBarWidget extends StatefulWidget {

  final List<Tuple2<BottomNavigationBarItem, Widget>> items = [
    Tuple2(
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: '首页',
      ),
      FirstPage()
    ),
    Tuple2(
      BottomNavigationBarItem(
        icon: Icon(Icons.mail),
        label: '邮件',
      ),
      SecondPage()
    ),
    Tuple2(
      BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: '我的',
      ),
      ThirdPage()
    ),
  ];

  var index = 0;
  var title = "PageViewTabBarWidget";
  var isAnimateToPage = false;
  // PageViewTabBarWidget({this.title, this.barItems, required this.pageWidgetList, this.index, this.isAnimateToPage});

  @override
  _PageViewTabBarWidgetState createState() => _PageViewTabBarWidgetState();
}

class _PageViewTabBarWidgetState extends State<PageViewTabBarWidget> {
  late PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
      body: buildPageView(context),
    );
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: widget.items.map((e) => e.item1).toList(),
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.index,
      selectedFontSize: 14,
      selectedItemColor: Theme.of(context).primaryColor,
      selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor, size: 28),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedFontSize: 12,
      unselectedItemColor: Colors.black,
      unselectedIconTheme: IconThemeData(color: Colors.black, size: 24),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      elevation: 10,
      onTap: (index) {
        ddlog('onTap: $index');
        widget.index = index;
        setState(() {
          if (widget.isAnimateToPage) {
            _pageController.animateToPage(widget.index, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          } else {
            _pageController.jumpToPage(widget.index);
          }
        });
      },
    );
  }

  PageView buildPageView(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      children: widget.items.map((e) => e.item2).toList(),
      controller: _pageController,
      onPageChanged: (index) {
        ddlog('onPageChanged: $index');
        widget.index = index;
        setState(() {});
      },
      pageSnapping: true,
      physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
    );
  }
}

