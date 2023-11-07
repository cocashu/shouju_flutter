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
                return ListTile(
                  title: Text(invoice.fkdw),
                  subtitle: Text(invoice.fkzy),
                  trailing: Text('\￥${invoice.fkje.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (builder) => PdfPreviewPage(invoice: invoice),
                      ),
                    );
                  },
                );
              },
            )
          : const Center(
              child: Text('没有数据'),
            ),
    );
  }
}
