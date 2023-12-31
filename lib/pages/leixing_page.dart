import 'package:flutter/material.dart';
import 'package:hy_shouju/main.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:hy_shouju/models/mysqlite.dart';

class Type {
  final String name;
  final String description;
  Type(this.name, this.description);
}

class TypeManagementPage extends StatefulWidget {
  const TypeManagementPage({Key? key}) : super(key: key); //嵌套模式
  @override
  _TypeManagementPageState createState() => _TypeManagementPageState();
}

class _TypeManagementPageState extends State<TypeManagementPage> {
  final Controller c = Get.put(Controller());
  final TextEditingController _jiaofeileixing = TextEditingController();

  List<Map<String, dynamic>> dataList = [];

//插入数据
  Future<void> insertData(String jflx, String zhangtao) async {
    Database database = await openDatabaseConnection();
    String tableName = "jflx";
    Map<String, dynamic> data = {
      "jflx": jflx,
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
    String tableName = "jflx";

    // 查询数据总数
    int count = await database.rawQuery(
      'SELECT COUNT(*) FROM fkmx WHERE jflx_id = ?',
      [id],
    ).then((value) => value.first.values.first as int);

    if (count == 0) {
      await database.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      // 重新获取数据并更新UI
      setState(() {
        fetchData();
      });
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('无法删除数据'),
            content: const Text('该数据仍有关联的记录，无法删除。'),
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
    }

    await database.close();
  }

  Future<void> updateJflx(int id, BuildContext context) async {
    TextEditingController textEditingController = TextEditingController();
    Database database = await openDatabaseConnection();
    // 查询数据总数
    int count = await database.rawQuery(
      'SELECT COUNT(*) FROM fkmx WHERE jflx_id = ?',
      [id],
    ).then((value) => value.first.values.first as int);

    if (count == 0) {
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('修改缴费类型'),
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
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('无法修改数据'),
            content: const Text('该数据仍有关联的记录，无法修改。'),
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
    }

    await database.close();
  }

  // 修改数据
  Future<void> performUpdate(int id, String newJflx) async {
    // 在这里执行实际的更新操作
    // 使用传入的id和newJflx参数更新数据库中的数据
    Database database = await openDatabaseConnection();
    String tableName = "jflx";
    Map<String, dynamic> updatedData = {
      "jflx": newJflx,
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
    String tableName = "jflx";
    List<Map<String, dynamic>> result = await database.query(tableName);
    setState(() {
      dataList = result;
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
                updateJflx(index, itemContext);
                // Navigator.pop(context); // 关闭弹出菜单
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('删除'),
              onTap: () {
                // 处理删除操作
                deleteData(index);
                Navigator.pop(context); // 关闭弹出菜单
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
                        '当前缴费类型(点击项目可修改)',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        flex: 7,
                        child: dataList.isNotEmpty
                            ? ListView.builder(
                                itemCount: dataList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                        'ID: ${dataList[index]['id']}-${dataList[index]['jflx']}'),
                                    subtitle: Text(
                                        '账套: ${dataList[index]['zhangtao']}'),
                                    onTap: () {
                                      // 处理点击事件
                                      // 可以在这里进行类型编辑、删除等操作
                                      handleListItemTap(
                                          dataList[index]['id'], context);
                                    },
                                  );
                                },
                              )
                            : const Center(
                                child: Text('没有数据'),
                              ),
                      ),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          // final leftWidth = constraints.maxWidth / 2;
                          return Container(
                            // width: leftWidth,
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                const Text(
                                  '增加缴费类型',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: leftWidth,
                                  child: TextField(
                                    controller: _jiaofeileixing,
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
                                      insertData(_jiaofeileixing.text,
                                          c.gsname.toString());
                                    }, // 当密码不正确时禁用按钮
                                    child: const Text('增加'),
                                  ),
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
