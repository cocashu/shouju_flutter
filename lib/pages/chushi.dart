import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:hy_shouju/models/mysqlite.dart';

class MychushiPage extends StatefulWidget {
  const MychushiPage({Key? key}) : super(key: key); //嵌套模式
  @override
  _MychushiPageState createState() => _MychushiPageState();
}

class _MychushiPageState extends State<MychushiPage> {
  final TextEditingController _gsname = TextEditingController();
  final TextEditingController _gsnameall = TextEditingController();
  final TextEditingController _username = TextEditingController();
  //插入数据
  Future<void> insertData(String gsname, String gsnameall) async {
    Database database = await openDatabaseConnection();
    String tableName = "zt";
    Map<String, dynamic> data = {
      "zhangtao": gsname,
      "gsname": gsnameall,
    };
    await database.insert(tableName, data);

    await database.close();
  }

//插入数据
  Future<void> userinsertData(String username, String zhangtao) async {
    Database database = await openDatabaseConnection();
    String tableName = "user";
    Map<String, dynamic> data = {
      "user": username,
      "password": generateMd5(username),
      "zhangtao": zhangtao,
    };
    await database.insert(tableName, data);
    await database.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("账套初始化"),
      ),
      body: Center(
        child: Column(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final leftWidth = constraints.maxWidth / 2;
                return Container(
                  width: leftWidth,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Text(
                        '公司简称',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: leftWidth,
                        child: TextField(
                          controller: _gsname,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                      const Text(
                        '公司全称',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: leftWidth,
                        child: TextField(
                          controller: _gsnameall,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: leftWidth,
                        child: ElevatedButton(
                          onPressed: () {
                            // 按钮点击事件处理逻辑
                            insertData(_gsname.text, _gsnameall.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('账套初始化完成'),
                                backgroundColor: Colors.red, // 设置背景色为红色
                              ),
                            );
                            // Navigator.pop(context);
                          },
                          child: const Text('增加'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final leftWidth = constraints.maxWidth / 2;
                return Container(
                  width: leftWidth,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Text(
                        '增加用户',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: leftWidth,
                        child: TextField(
                          controller: _username,
                          decoration: const InputDecoration(
                            // hintText: '文本框',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: leftWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              // 按钮点击事件处理逻辑
                              userinsertData(_username.text, _gsname.text);
                            },
                            child: const Text('增加')),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
