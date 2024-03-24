

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_origin_sheet.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/network/RequestConfig.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';


class LoginPageOne extends StatefulWidget {

  const LoginPageOne({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageOneState createState() => _LoginPageOneState();
}

class _LoginPageOneState extends State<LoginPageOne> {

  // 控制器
  final _unameController =  TextEditingController();
  final _pwdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // 焦点
  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();

  bool isEye = true;
  bool isBtnEnabled = false;
  bool showLoading = false;
  final _unameExp = RegExp(r'^(?![0-9]+$)(?![a-z]+$)[0-9a-z]{6,12}$'); //用户名正则
  final _pwdExp = RegExp(r'^(?![0-9]+$)(?![a-z]+$)[0-9a-z]{6,12}$'); //密码正则


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text('登录', style: TextStyle(color: Colors.white)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    var childrens = <Widget>[];
    final _main = Center(
      child: ListView(
        padding: EdgeInsets.only(left: 30.0, right: 30.0,top: 60.0),
        children: [
          Hero(
            tag: 'avatar',
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 50.0,
              child: Image.asset('avatar.png'.toPath()),
            ),
          ),
          NOriginSheet(),
          SizedBox(height: 30),
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                TextFormField( //用户名
                  controller: _unameController,
                  focusNode: focusNode1,//关联focusNode1
                  keyboardType: TextInputType.text,//键盘类型
                  maxLength: 12,
                  textInputAction: TextInputAction.next,//显示'下一步'
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    hintText: '请输入账号',
                    // labelText: "账号",
                    // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    prefixIcon:Icon(Icons.perm_identity),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0) //圆角大小
                    ),
                    suffixIcon: _unameController.text.isNotEmpty ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 21,
                        color: Color(0xff666666),
                      ),
                      onPressed: (){
                        setState(() {
                          _unameController.text = '';
                          checkLoginText();
                        });
                      },
                    ):null
                  ),
                  validator: (v) {
                    return !_unameExp.hasMatch(v!)?'账号由6到12位数字与小写字母组成':null;
                  },
                  onEditingComplete: ()=>FocusScope.of(context).requestFocus(focusNode2),
                  onChanged: (v){
                    checkLoginText();
                    setState(() {});
                  },
                ),
                // SizedBox(height: 15.0),
                TextFormField( //密码
                  controller: _pwdController,
                  focusNode: focusNode2,//关联focusNode1
                  obscureText: isEye, //密码类型 内容用***显示
                  maxLength: 12,
                  textInputAction: TextInputAction.done, //显示'完成'
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    hintText: '请输入密码',
                    // labelText: '密码',
                    // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    prefixIcon:Icon(Icons.lock),
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(40.0)
                    // ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        size: 21,
                      ),
                      onPressed: (){
                        setState(() {
                          isEye = !isEye;
                        });
                      },
                    )
                  ),
                  validator:(v){
                    return !_pwdExp.hasMatch(v!)?'密码由6到12位数字与小写字母组成':null;
                  },
                  onChanged: (v){
                    checkLoginText();
                    setState(() {});
                  },
                  onEditingComplete: onLogin, //'完成'回调
                )
              ],
            ),
          ),
          SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)
              ),
            ),
            onPressed: !isBtnEnabled? null : onLogin,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('登录',style: TextStyle(fontSize: 18.0, color: Colors.white))
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigator.pushNamed(context, 'forget');
              Get.toNamed(APPRouter.forgetPasswordPage, arguments: "forget");
            },
            child: Text('忘记密码?', style: TextStyle(color: Colors.black54,fontSize: 15.0)),
          ),
          // buildOriginSheet(),
        ],
      ),
    );

    childrens.add(_main);
    // if(this.showLoading){
    //   childrens.add(Loadding());
    // }
    return Stack(children: childrens);
  }

  // 异步操作
  Future loginRequest() async {
    return Future.delayed(Duration(seconds: 3),(){
      debugPrint('login success');
    });
  }

  // 登录按钮是否可点击
  void checkLoginText(){
    if(_unameExp.hasMatch(_unameController.text)&&_pwdExp.hasMatch(_pwdController.text)){
      isBtnEnabled = true;
    }else{
      isBtnEnabled = false;
    }
  }

  // 登录提交
  void onLogin(){
    FocusScope.of(context).requestFocus(FocusNode()); //收起键盘
    setState((){
      showLoading = true;
    });
    loginRequest().then((v) => {
      setState((){
        showLoading = false;
      }),
      // toast提示
      // 模拟登录跳转首页
      // ToastCom.show('登录成功', context),
      // Navigator.pushNamed(context, '/')

      Get.toNamed(APPRouter.homePage)
      // showDialog(
      //     context: context,
      //     builder: (context){
      //         String alertText = "登录成功!!!"+"\n用户名:"+_unameController.text+"\n密码:"+_pwdController.text;
      //         return AlertDialog(content: Text(alertText));
      //     }
      // )
    });
  }

}
