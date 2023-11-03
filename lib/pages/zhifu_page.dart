import 'package:flutter/material.dart';
import 'package:hy_shouju/main.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Type {
  final String name;
  final String description;
  Type(this.name, this.description);
}

class zffs_TypeManagementPage extends StatefulWidget {
  const zffs_TypeManagementPage({Key? key}) : super(key: key); //嵌套模式
  @override
  _TypeManagementPageState createState() => _TypeManagementPageState();
}

class _TypeManagementPageState extends State<zffs_TypeManagementPage> {
  final Controller c = Get.put(Controller());
  final TextEditingController _zhifuleixing = TextEditingController();
  bool isPasswordCorrect = false; // 管理密码是否正确的标志

  //查询user 表中ID为1 的密码
  Future<String> queryPassword() async {
    Database database = await openDatabaseConnection();
    String tableName = "user";
    var result =
        await database.query(tableName, where: 'id =?', whereArgs: [1]);
    if (result.isNotEmpty) {
      return result.first['password'].toString();
    } else {
      return '未找到指定项目';
    }
  }

  // 管理密码校验逻辑
  Future<bool> checkPassword() async {
    var password = await queryPassword();
    isPasswordCorrect =
        password.toString() == '672c9e8060c35db2c0f7d79bda8fc0d1';
    print(isPasswordCorrect.toString());
    return isPasswordCorrect;
  }

  List<Map<String, dynamic>> zffs_dataList = [];
  Future<Database> openDatabaseConnection() async {
    String databasePath = await getDatabasesPath();
    String databaseFile = join(databasePath, 'my_database.db');
    return openDatabase(databaseFile);
  }

//插入数据
  Future<void> insertData(String jflx, String zhangtao) async {
    Database database = await openDatabaseConnection();
    String tableName = "zffs";
    Map<String, dynamic> data = {
      "zffs": jflx,
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
    String tableName = "zffs";

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

  Future<void> updatezffs(int id, BuildContext context) async {
    TextEditingController textEditingController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('修改支付方式'),
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
                String newJflx = textEditingController.text;
                await performUpdate(id, newJflx);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 修改数据
  Future<void> performUpdate(int id, String newJflx) async {
    // 在这里执行实际的更新操作
    // 使用传入的id和newJflx参数更新数据库中的数据
    Database database = await openDatabaseConnection();
    String tableName = "zffs";

    Map<String, dynamic> updatedData = {
      "zffs": newJflx,
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
    String tableName = "zffs";
    List<Map<String, dynamic>> result = await database.query(tableName);
    setState(() {
      zffs_dataList = result;
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
                  updatezffs(index, itemContext);
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
    checkPassword();
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
                        '增加支付方式',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: leftWidth,
                        child: TextField(
                          controller: _zhifuleixing,
                          decoration: const InputDecoration(
                            // hintText: '文本框',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            checkPassword();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: leftWidth,
                        child: ElevatedButton(
                          onPressed: isPasswordCorrect
                              ? () {
                                  // 按钮点击事件处理逻辑
                                  print(_zhifuleixing.text);
                                  insertData(
                                      _zhifuleixing.text, c.gsiname.toString());
                                }
                              : null, // 当密码不正确时禁用按钮
                          child: const Text('增加'),
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
                        '当前支付方式(点击项目可修改-待处理)',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        flex: 7,
                        child: zffs_dataList.isNotEmpty
                            ? ListView.builder(
                                itemCount: zffs_dataList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                        'ID: ${zffs_dataList[index]['id']}-${zffs_dataList[index]['zffs']}'),
                                    subtitle: Text(
                                        '账套: ${zffs_dataList[index]['zhangtao']}'),
                                    onTap: isPasswordCorrect
                                        ? () {
                                            // 处理点击事件
                                            // 可以在这里进行类型编辑、删除等操作
                                            handleListItemTap(
                                                zffs_dataList[index]['id'],
                                                context);
                                          }
                                        : null,
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
