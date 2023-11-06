import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hy_shouju/main.dart';
import 'package:hy_shouju/models/mysqlite.dart';
import 'package:hy_shouju/pages/main1.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Controller c = Get.put(Controller());

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    String result =
        await queryBypass(_usernameController.text, c.gsiname.toString());

    // 在这里进行登录验证逻辑，例如与数据库中的用户名和密码进行比较
    if (generateMd5(password) == result) {
      // 赋值公共数据
      c.userid.value = 1;
      c.username.value = username;
      c.gsiname.value = 'xx商贸';
      c.gsinameall.value = 'yyyy市xx商贸有限责任公司';
      // 登录成功
      Get.off(const MyCustomForm());
    } else {
      // 登录失败
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
            ElevatedButton(
              child: const Text('登录'),
              onPressed: () {
                _login();
              },
            ),
          ],
        ),
      ),
    );
  }
}
