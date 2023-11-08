import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:hy_shouju/models/mysqlite.dart';

class MyAppbiaobiaoPage extends StatefulWidget {
  const MyAppbiaobiaoPage({Key? key}) : super(key: key); //嵌套模式
  @override
  _MyAppbiaobiaoPageState createState() => _MyAppbiaobiaoPageState();
}

class _MyAppbiaobiaoPageState extends State<MyAppbiaobiaoPage> {
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> zffs_dataList = [];
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

  Future<void> zffsData() async {
    Database database = await openDatabaseConnection();
    String tableName = "zffs";
    List<Map<String, dynamic>> result = await database.query(tableName);
    setState(() {
      zffs_dataList = result;
    });
    await database.close();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    zffsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        '点击项目查看报表',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        flex: 7,
                        child: (dataList.isNotEmpty || zffs_dataList.isNotEmpty)
                            ? ListView.builder(
                                itemCount:
                                    dataList.length + zffs_dataList.length + 2,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    // 显示固定的标题
                                    return ListTile(
                                      title: Text('按缴费类型汇总'),
                                      onTap: () {
                                        // 处理点击事件
                                        // 可以在这里进行类型编辑、删除等操作
                                      },
                                    );
                                  } else if (index == 1) {
                                    // 显示固定的标题
                                    return ListTile(
                                      title: Text('按支付方式汇总'),
                                      onTap: () {
                                        // 处理点击事件
                                        // 可以在这里进行类型编辑、删除等操作
                                      },
                                    );
                                  } else if (index <= dataList.length + 1) {
                                    // 显示dataList中的数据
                                    int dataIndex = index - 2;
                                    return ListTile(
                                      title: Text(
                                          '缴费分类：${dataList[dataIndex]['jflx']}'),
                                      subtitle: Text(
                                          '账套: ${dataList[dataIndex]['zhangtao']}'),
                                      onTap: () {
                                        // 处理点击事件
                                        // 可以在这里进行类型编辑、删除等操作
                                      },
                                    );
                                  } else {
                                    // 显示zffs_dataList中的数据
                                    int zffsIndex = index - dataList.length - 2;
                                    return ListTile(
                                      title: Text(
                                          '支付方式：${zffs_dataList[zffsIndex]['zffs']}'),
                                      subtitle: Text(
                                          '账套: ${zffs_dataList[zffsIndex]['zhangtao']}'),
                                      onTap: () {
                                        // 处理点击事件
                                        // 可以在这里进行类型编辑、删除等操作
                                      },
                                    );
                                  }
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
          const VerticalDivider(),
          Expanded(flex: 7, child: Text('data')),
        ],
      ),
    );
  }
}
