import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/horizontal_cell.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/uti/R.dart';

class BadgesDemo extends StatefulWidget {

  const BadgesDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _BadgesDemoState createState() => _BadgesDemoState();
}

class _BadgesDemoState extends State<BadgesDemo> {
  var sliderVN = ValueNotifier(100.0);

  int _counter = 0;
  bool showElevatedButtonBadge = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: _bottomNavigationBar(),
        appBar: AppBar(
          leading: _buildBadgeRedPoint(
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {},
            ),
          ),
          title: Text('Badge Demo', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          actions: <Widget>[
            _shoppingCartBadge(),
          ],
          bottom: _tabBar(),
        ),
        body: Column(
          children: <Widget>[
            _buildSlider(),
            _addRemoveCartButtons(),
            _textBadge(),
            _directionalBadge(),
            _elevatedButtonBadge(),
            _chipBadge(),
            _badgeOnly(),
            _badgesWithBorder(),
            _listView(),
            _buildCell(),
            SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }
  /// 透明度滑动组件
  _buildSlider() {
    return Row(
      children: [
        Expanded(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Slider(
                inactiveColor: Color(0xffC0C0C0),
                activeColor: Color(0xff21BA45),
                divisions: 100,
                //label: 'Admitida',
                value: sliderVN.value,
                min: 0.0,
                max: 100.0,
                onChanged: (double value) {
                  sliderVN.value = value;
                  setState(() {});
                },
              );
            }
          ),
        ),
        ValueListenableBuilder(
          valueListenable: sliderVN,
          builder: (BuildContext context, double value, Widget? child) {
            final result = (value/100).toStringAsFixed(2);
            return TextButton(
              onPressed: () { debugPrint(result); },
              child: Text(result),
            );
          }
        ),
      ],
    );
  }

  _buildGraint({
    double opacity = 1.0,
  }) {
    return LinearGradient(
      colors: [
        Colors.red.withOpacity(opacity),
        Colors.green.withOpacity(opacity),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  /// 右上角点
  _buildBadgeRedPoint({
    required Widget child,
    Color badgeColor = Colors.red,
  }) {
    return badges.Badge(
      badgeColor: badgeColor,
      position: badges.BadgePosition.topEnd(top: 10, end: 10),
      badgeContent: null,
      child: child,
    );
  }

  _buildBadgeText({
    required Widget child,
    Widget? badgeContent,
    double badgeContentOpacity = 1,
    String? badgeValue,
    Color badgeColor = Colors.white,
    badges.BadgeShape shape = badges.BadgeShape.square,
    Gradient? gradient,
  }) {
    final badgeChild = badgeValue != null ? Text(badgeValue,
      style: TextStyle(
          color: badgeColor,
          fontSize: 10,
          fontWeight: FontWeight.bold
      ),
    ) : badgeContent;

    return badges.Badge(
      shape: shape,
      elevation: 0,
      borderRadius: BorderRadius.circular(5),
      position: badges.BadgePosition.topEnd(top: -12, end: -20),
      padding: EdgeInsets.all(2),
      gradient: gradient,
      badgeContent: Opacity(
        opacity: badgeContentOpacity,
        child: badgeChild
      ),
      child: child,
    );
  }

  Widget _shoppingCartBadge() {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: Duration(milliseconds: 300),
      animationType: badges.BadgeAnimationType.slide,
      badgeContent: Text(
        _counter.toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(
        icon: Icon(Icons.shopping_cart, color: Colors.black),
        onPressed: () {}
      ),
    );
  }

  PreferredSizeWidget _tabBar() {
    return TabBar(tabs: [
      Tab(
        icon: badges.Badge(
          badgeColor: Colors.blue,
          badgeContent: Text('3',
            style: TextStyle(color: Colors.white),
          ),
          child: Icon(Icons.account_balance_wallet, color: Colors.grey),
        ),
      ),
      Tab(
        icon: _buildBadgeText(
          badgeValue: 'NEW',
          child: Text('MUSIC',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
      Tab(
        icon: ValueListenableBuilder(
          valueListenable: sliderVN,
          builder: (BuildContext context, double value, Widget? child) {
            final result = (value/100);
            return _buildBadgeText(
              shape: badges.BadgeShape.square,
              gradient: _buildGraint(opacity: result),
              badgeValue: '你我他',
              badgeColor: Colors.black,
              // badgeContentOpacity: result,
              child: Text('Video',
                style: TextStyle(color: Colors.black),
              ),
            );
          }
        ),
      ),
      Tab(
        icon: ValueListenableBuilder(
          valueListenable: sliderVN,
          builder: (BuildContext context, double value, Widget? child) {
            final result = (value/100);
            return _buildBadgeText(
              shape: badges.BadgeShape.square,
              gradient: _buildGraint(opacity: result),
              badgeValue: '你我他',
              badgeColor: Colors.black,
              badgeContentOpacity: result,
              child: Text('Game',
                style: TextStyle(color: Colors.black),
              ),
            );
          }
        ),
      )
    ]);
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          label: 'Events',
          icon: Icon(Icons.event),
        ),
        BottomNavigationBarItem(
          label: 'Messages',
          icon: Icon(Icons.message),
        ),
        BottomNavigationBarItem(
          label: 'Settings',
          icon: badges.Badge(
            shape: badges.BadgeShape.circle,
            position: badges.BadgePosition.center(),
            borderRadius: BorderRadius.circular(100),
            badgeContent: Container(
              height: 5,
              width: 5,
              decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
            child: Icon(Icons.settings),
          ),
        ),
      ],
    );
  }
  /// 购物车动作
  Widget _addRemoveCartButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _counter++;
              });
            },
            icon: Icon(Icons.add),
            label: Text('Add to cart')
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (_counter > 0) {
                setState(() {
                  _counter--;
                });
              }
            },
            icon: Icon(Icons.remove),
            label: Text('Remove from cart')
          ),
        ],
      ),
    );
  }

  Widget _textBadge() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: badges.Badge(
        padding: EdgeInsets.all(6),
        gradient: LinearGradient(colors: [
          Colors.black,
          Colors.red,
        ]),
        badgeContent: Text(
          '!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        position: badges.BadgePosition.topStart(top: -15),
        child: Text('This is a text'),
      ),
    );
  }
  /// ElevatedButton 按钮角标
  Widget _elevatedButtonBadge() {
    return badges.Badge(
      showBadge: showElevatedButtonBadge,
      padding: EdgeInsets.all(8),
      badgeColor: Colors.deepPurple,
      badgeContent: Text(
        '!',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            showElevatedButtonBadge = !showElevatedButtonBadge;
          });
        },
        child: Text('ElevatedButton Button'),
      ),
    );
  }
  /// Chip 角标
  Widget _chipBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Chip with zero padding:'),
        badges.Badge(
          badgeContent: Text(
            '!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          child: Chip(
            label: Text('Hello'),
            padding: EdgeInsets.all(0),
          ),
        ),
      ]
    );
  }

  Widget _badgeOnly() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Badges:'),
        for (int i = 0; i < 5; i++)
          _getExampleBadge(padding: (i * 2).toDouble())
      ],
    );
  }

  Widget _getExampleBadge({double? padding}) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: badges.Badge(
        badgeColor: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(20),
        padding: EdgeInsets.all(padding ?? 4),
        shape: badges.BadgeShape.square,
        badgeContent: Text(
          'Hello',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
  /// badge 带边框
  Widget _badgesWithBorder() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Badges with borders:'),
          badges.Badge(
            shape: badges.BadgeShape.square,
            padding: EdgeInsets.all(2),
            borderRadius: BorderRadius.circular(8),
            badgeContent: Text('99+'),
            child: Icon(Icons.person, size: 30),
          ),
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: 0, end: 2),
            elevation: 0,
            shape: badges.BadgeShape.circle,
            badgeColor: Colors.red,
            borderSide: BorderSide(color: Colors.black),
            child: Icon(
              Icons.person,
              size: 30,
            ),
          ),
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: -5, end: -5),
            shape: badges.BadgeShape.square,
            badgeColor: Colors.blue,
            badgeContent: SizedBox(
              height: 5,
              width: 5,
            ),
            elevation: 0,
            borderSide: BorderSide(
              color: Colors.black,
              width: 3,
            ),
            child: Icon(
              Icons.games_outlined,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listView() {
    return Expanded(
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return _listTile(title: 'Messages', badgeValue: '2', shape: badges.BadgeShape.square);
            case 1:
              return _listTile(title: 'Friends', badgeValue: '你我他', shape: badges.BadgeShape.square);
            default:
              return _listTile(title: 'Events', badgeValue: '!', shape: badges.BadgeShape.circle);
          }
        },
      ),
    );
  }



  Widget _listTile({
    required String title,
    required String badgeValue,
    badges.BadgeShape shape = badges.BadgeShape.circle,
    double radius = 8,
  }) {
    return ListTile(
      dense: true,
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            badges.Badge(
              elevation: 0,
              shape: shape,
              padding: EdgeInsets.all(7),
              borderRadius: BorderRadius.circular(radius),
              badgeContent: Text(
                badgeValue,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _buildText(String text) {
    return Text(text, style: TextStyle(fontSize: 16));
  }

  Widget _directionalBadge() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: badges.Badge(
        elevation: 0,
        position: badges.BadgePosition.topEnd(),
        padding: EdgeInsetsDirectional.only(end: 4),
        badgeColor: Colors.transparent,
        badgeContent: Icon(Icons.error, size: 16.0, color: Colors.red),
        child: Text('This is RTL'),
      ),
    );
  }

  _buildCell() {
    return HorizontalCell(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          color: Colors.green,
        ),
        title: _buildText("title"),
        titleRight: _buildText("titleRight"),
        subtitle: _buildText("subtitle"),
        subtitleRight: _buildText("subtitleRight"),
        // useIntrinsicHeight: false,
        // titleSpace: Spacer(),
        // titleSpace: Container(
        //   height: 20,
        //   color: Colors.green,
        // ),
        left: FadeInImage(
          height: 60,
          image: NetworkImage(R.image.urls[4]),
          placeholder: "img_placeholder.png".toAssetImage(),
        ),
        // mid: Container(
        //   width: 60,
        //   height: 60,
        //   color: Colors.blue,
        // ),
        right: Container(
          width: 60,
          height: 100,
          color: Colors.yellow,
        ),
        arrow: Container(
          // color: Colors.green,
          // padding: EdgeInsets.all(8),
          child: Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Colors.grey
          ),
        )
    );
  }
}