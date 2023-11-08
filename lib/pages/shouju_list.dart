import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hy_shouju/models/invoice.dart';
import 'package:hy_shouju/pages/pdfexport/pdfpreview.dart';
import 'package:hy_shouju/models/mysqlite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class InvoicePage extends StatefulWidget {
  InvoicePage({Key? key}) : super(key: key);

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  List<Map<String, dynamic>> dataList = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

// 加载收据列表
  Future<void> fetchData() async {
    Database database = await openDatabaseConnection();
    String tableName = "fkmx";
    List<Map<String, dynamic>> result = await database.query(tableName);
    setState(() {
      dataList = result;
    });
    await database.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: dataList.isNotEmpty
          ? ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = dataList[index];
                Invoice invoice = Invoice(
                  fklx_id: data['jflx_id'],
                  zffs_id: data['zffs_id'],
                  user_id: data['user_id'],
                  fkdw: data['fkdw'],
                  fkzy: data['fkzy'],
                  fkje: data['jine'],
                  fksj: data['uptime'],
                  sjhm: data['sjhm'], // 根据你的实际情况进行修改
                  ztid: data['zhangtao_id'],
                );
                return Dismissible(
                  key: Key(dataList[index].toString()),
                  onDismissed: (direction) async {
                    // 处理滑动操作的逻辑
                  },
                  background: Container(
                    color: Colors.red, // 左滑时显示的背景颜色
                    child: Icon(Icons.settings), // 左滑时显示的图标或其他内容
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart &&
                        data['zf_jine'] != 0.0) {
                      // 显示"作废"和"取消"选项
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('还原作废？'),
                            content: const Text('您确定要还原这条数据吗？'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () {
                                  unmodifyData(invoice.fklx_id, invoice.sjhm);
                                  Navigator.of(context).pop(false);
                                  fetchData();
                                },
                                child: const Text('还原'),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (direction == DismissDirection.startToEnd &&
                        data['jine'] != 0.0) {
                      // 左滑操作
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('确认作废？'),
                            content: const Text('您确定要作废这条数据吗？'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () {
                                  modifyData(invoice.fklx_id, invoice.sjhm);
                                  Navigator.of(context).pop(false);
                                  fetchData();
                                },
                                child: const Text('作废'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return true;
                  },
                  child: ListTile(
                    title: invoice.fkje == 0
                        ? Text(
                            '${invoice.fkdw}【已作废】',
                          )
                        : Text(invoice.fkdw),
                    //待添加文字颜色
                    subtitle: Text(invoice.fkzy),
                    trailing: Text('\￥${invoice.fkje.toStringAsFixed(2)}'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (builder) =>
                              PdfPreviewPage(invoice: invoice),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : const Center(
              child: Text('没有数据'),
            ),
    );
  }
}
