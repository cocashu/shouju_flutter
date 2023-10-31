import 'package:flutter/material.dart';
import 'package:hy_shouju/main.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class user_TypeManagementPage extends StatefulWidget {
  const user_TypeManagementPage({Key? key}) : super(key: key); //嵌套模式
  @override
  _TypeManagementPageState createState() => _TypeManagementPageState();
}

class _TypeManagementPageState extends State<user_TypeManagementPage> {
  final Controller c = Get.put(Controller());
  final TextEditingController _username = TextEditingController();

  List<Map<String, dynamic>> user_dataList = [];
  Future<Database> openDatabaseConnection() async {
    String databasePath = await getDatabasesPath();
    String databaseFile = join(databasePath, 'my_database.db');
    return openDatabase(databaseFile);
  }

  String generateMd5(String input) {
    var bytes = utf8.encode(input); // 将字符串转换为字节数组
    var digest = md5.convert(bytes); // 进行MD5加密
    return digest.toString(); // 将加密结果转换为字符串
  }

//插入数据
  Future<void> insertData(String username, String zhangtao) async {
    Database database = await openDatabaseConnection();
    String tableName = "user";
    Map<String, dynamic> data = {
      "username": username,
      "password": generateMd5(username),
      "zhangtao": zhangtao,
    };
    await database.insert(tableName, data);
    // 重新获取数据并更新UI
    setState(() {
      fetchData();
    });
    await database.close();
  }

  // 删除数据
  Future<void> deleteData(int id) async {
    Database database = await openDatabaseConnection();
    String tableName = "user";
    await database.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    // 重新获取数据并更新UI
    setState(() {
      fetchData();
    });
    await database.close();
  }

  Future<void> updateuser(int id, BuildContext context) async {
    TextEditingController textEditingController = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('修改密码'),
          content: TextField(
            controller: textEditingController,
          ),
          actions: [
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () async {
                String newpass = textEditingController.text;
                await performUpdate(id, newpass);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 修改数据
  Future<void> performUpdate(int id, String newpass) async {
    // 在这里执行实际的更新操作
    // 使用传入的id和newJflx参数更新数据库中的数据
    Database database = await openDatabaseConnection();
    String tableName = "user";

    Map<String, dynamic> updatedData = {
      "password": generateMd5(newpass),
    };
    await database.update(
      tableName,
      updatedData,
      where: 'id = ?',
      whereArgs: [id],
    );
    // 重新获取数据并更新UI
    setState(() {
      fetchData();
    });
    await database.close();
  }

// 刷新数据
  Future<void> fetchData() async {
    Database database = await openDatabaseConnection();
    String tableName = "user";
    List<Map<String, dynamic>> result = await database.query(tableName);
    setState(() {
      user_dataList = result;
    });
    await database.close();
  }

  void handleListItemTap(int index, BuildContext itemContext) {
    // 显示一个弹出菜单，让用户选择删除或修改数据
    showModalBottomSheet(
      context: itemContext,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('修改'),
                onTap: () {
                  // 处理修改操作
                  print('修改' + index.toString());
                  updateuser(index, itemContext);
                  Navigator.pop(context); // 关闭弹出菜单
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('删除'),
                onTap: () {
                  // 处理删除操作
                  print('删除' + index.toString());
                  deleteData(index);
                  Navigator.pop(context); // 关闭弹出菜单
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('类型管理'),
      // ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 3,
            child: LayoutBuilder(
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
                          onPressed: null, // 将onPressed设置为null
                          child: Text('禁止增加'),
                          // onPressed: () {
                          //   // 按钮点击事件处理逻辑
                          //   print(_username.text);
                          //   insertData(_username.text, c.gsiname.toString());
                          // },
                          // child: const Text('增加')
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 7,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final leftWidth = constraints.maxWidth / 2;
                return Container(
                  width: leftWidth,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Text(
                        '当前用户列表(点击项目可修改-待处理)',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        flex: 7,
                        child: user_dataList.isNotEmpty
                            ? ListView.builder(
                                itemCount: user_dataList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                        'ID: ${user_dataList[index]['id']}--${user_dataList[index]['username']}'),
                                    subtitle: Text(
                                        '账套: ${user_dataList[index]['zhangtao']}--${user_dataList[index]['password']}'),
                                    onTap: () {
                                      // 处理点击事件
                                      // 可以在这里进行类型编辑、删除等操作
                                      handleListItemTap(
                                          user_dataList[index]['id'], context);
                                    },
                                  );
                                },
                              )
                            : const Center(
                                child: Text('没有数据'),
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
