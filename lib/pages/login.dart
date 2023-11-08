import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hy_shouju/main.dart';
import 'package:hy_shouju/models/mysqlite.dart';
import 'package:hy_shouju/pages/main1.dart';
import 'package:hy_shouju/pages/chushi.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Controller c = Get.put(Controller());
  RxBool myBool = false.obs;
  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    void processZtTableData() async {
      List<Map<String, dynamic>> queryResult = await queryZtTable();
      for (var result in queryResult) {
        // 在这里使用变量 gsname、zhangtao 和 zhangtaoId 进行后续处理
        // 例如，将它们赋值给 c.gsname、c.zhangtao 和 c.zhangtao_id
        c.gsname.value = result['zhangtao'];
        c.gsnameall.value = result['gsname'];
        c.zhangtaoid.value = result['id'];
      }
      print('账套信息已加载');
    }

    List<Map<String, dynamic>> results = await readFromSettingsTable();
    // 处理查询结果
    for (var result in results) {
      String name = result['name'];
      String value = result['value'];

      // 根据name进行区分赋值
      if (name == 'topMargin') {
        c.topMargin.value = double.parse(value);
      } else if (name == 'leftMargin') {
        c.leftMargin.value = double.parse(value);
      } else if (name == 'rightMargin') {
        c.rightMargin.value = double.parse(value);
      }
      print('设置信息已加载');
    }

    void assignUserIdToC() async {
      String username = _usernameController.text;
      c.username.value = _usernameController.text;
      int userId = await getUserIdByUsername(username);
      c.userid.value = userId;
      print('用户信息已加载');
    }

    @override
    Future<void> initState() async {
      super.initState();

      processZtTableData(); // 处理zt数据
    }

    String result = await queryBypass(_usernameController.text);
    // 在这里进行登录验证逻辑，例如与数据库中的用户名和密码进行比较
    if (generateMd5(password) == result) {
      // if (1 == 1) {
      assignUserIdToC();
      processZtTableData();
      // 登录成功
      Get.off(const MyCustomForm());
    } else {
      // 登录失败
      myBool.value = await isExistData('zt');

// ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('登录失败'),
            content: const Text('用户名或密码不正确，请重试。'),
            actions: [
              ElevatedButton(
                child: const Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: '用户名',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '密码',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            Row(
              //屏幕居中
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // 按钮点击事件处理逻辑
                      _login();
                    },
                    child: const Text(
                      '登录',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // 按钮点击事件处理逻辑
                      if (myBool.value) {
                        Get.to(const MychushiPage());
                      }
                    },
                    child: myBool.value
                        ? const Text(
                            '账套初始化',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          )
                        : const Text(
                            '账套已建立',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
