import 'package:flutter/material.dart';

class SliverAnimatedListDemo extends StatefulWidget {
  const SliverAnimatedListDemo({Key? key}) : super(key: key);

  @override
  _SliverAnimatedListDemoState createState() => _SliverAnimatedListDemoState();
}

class _SliverAnimatedListDemoState extends State<SliverAnimatedListDemo> {
  final _listKey = GlobalKey<SliverAnimatedListState>();
  final List<int> _list = [0, 1, 2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'SliverAnimatedList'
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: _insert,
              iconSize: 32,
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: _remove,
              iconSize: 32,
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAnimatedList(
              key: _listKey,
              initialItemCount: _list.length,
              itemBuilder: _buildItem,
            ),
          ],
        ),
      );
  }

  // 创建item
  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          title: Text('Item $index',),
        ),
      ),
    );
  }

  // 新增item
  _insert() {
    final _index = _list.length;
    _list.insert(_index, _index);
    _listKey.currentState!.insertItem(_index);
  }

  // 移除最后一个item
  _remove() {
    if (_list.isEmpty) {
      return;
    }
    final _index = _list.length - 1;
    var item = _list[_index];
    _listKey.currentState!.removeItem(_index,
            (context, animation) => _buildItem(context, item, animation));
    _list.removeAt(_index);
  }

}