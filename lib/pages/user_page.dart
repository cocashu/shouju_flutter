import 'package:flutter/material.dart';
import 'package:hy_shouju/main.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:hy_shouju/models/mysqlite.dart';

// ignore: camel_case_types
class user_TypeManagementPage extends StatefulWidget {
  const user_TypeManagementPage({Key? key}) : super(key: key); //嵌套模式
  @override
  // ignore: library_private_types_in_public_api
  _TypeManagementPageState createState() => _TypeManagementPageState();
}

class _TypeManagementPageState extends State<user_TypeManagementPage> {
  final Controller c = Get.put(Controller());
  final TextEditingController _username = TextEditingController();

  // ignore: non_constant_identifier_names
  List<Map<String, dynamic>> user_dataList = [];

//插入数据
  Future<void> insertData(String username, String zhangtao) async {
    // 检查用户名是否重复
    bool isUsernameDuplicate = await checkUsernameDuplicate(username);

    if (isUsernameDuplicate) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('用户名重复'),
            content: const Text('该用户名已存在，请输入一个不同的用户名。'),
            actions: [
              TextButton(
                child: const Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      Database database = await openDatabaseConnection();
      String tableName = "user";
      Map<String, dynamic> data = {
        "user": username,
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
  }

  // 删除数据

  Future<void> deleteData(int id) async {
    TextEditingController oldPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('修改密码'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '原密码',
                ),
              ),
            ],
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
                String oldPassword = oldPasswordController.text;
                // 进行原密码验证逻辑，例如与数据库中的密码进行比较
                if (await verifyOldPassword(
                    id, oldPassword, c.gsname.toString())) {
                  // 原密码验证通过，执行密码更新操作
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
                  Navigator.of(context).pop();
                } else {
                  // 原密码验证失败，显示错误提示
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('原密码错误'),
                        content: const Text('请重新输入正确的原密码。'),
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
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateuser(int id, BuildContext context) async {
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('修改密码'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '原密码',
                ),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '新密码',
                ),
              ),
            ],
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
                String oldPassword = oldPasswordController.text;
                String newPassword = newPasswordController.text;

                // 进行原密码验证逻辑，例如与数据库中的密码进行比较
                if (await verifyOldPassword(id, oldPassword, c.gsname.string)) {
                  // 原密码验证通过，执行密码更新操作
                  await performUpdate(id, newPassword);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  // 原密码验证失败，显示错误提示
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('原密码错误'),
                        content: const Text('请重新输入正确的原密码。'),
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
              },
            ),
          ],
        );
      },
    );
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('修改'),
              onTap: () {
                // 处理修改操作
                updateuser(index, itemContext);
                // Navigator.pop(context); // 关闭弹出菜单
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('删除'),
              onTap: () {
                deleteData(index);
                // Navigator.pop(context); // 关闭弹出菜单
              },
            ),
          ],
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
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
                        '当前用户列表(点击项目可修改)',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                          flex: 7,
                          child: ListView.builder(
                            itemCount: user_dataList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                    'ID: ${user_dataList[index]['id']}--${user_dataList[index]['user']}'),
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
                          )),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
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
                                        insertData(_username.text,
                                            c.gsname.toString());
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
