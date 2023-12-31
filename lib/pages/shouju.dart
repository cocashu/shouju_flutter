import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hy_shouju/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../numbertochinese.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:hy_shouju/pages/pdfexport/pdfpreview.dart';
import 'package:hy_shouju/models/invoice.dart';
import 'package:get/get.dart';
import 'package:hy_shouju/models/mysqlite.dart';

class shouju_page extends StatefulWidget {
  const shouju_page({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<shouju_page> {
  final TextEditingController _jine = TextEditingController(text: '0');
  final jineText = ''.obs;
  final sjhmText = ''.obs;
  late SingleValueDropDownController _fklx;
  late SingleValueDropDownController _fkfs;

  final TextEditingController _sjhm = TextEditingController();
  final TextEditingController _fkdw = TextEditingController();
  final TextEditingController _fkzy = TextEditingController();
  Future<List<DropDownValueModel>>? _jflx_loadDataFuture;
  Future<List<DropDownValueModel>>? _zffs_loadDataFuture;
  late Invoice invoice;
  final Controller c = Get.put(Controller());
  List<String> errorMessages = [];
  @override
  void initState() {
    _fklx = SingleValueDropDownController();
    _fkfs = SingleValueDropDownController();
    _jflx_loadDataFuture = jflx_loadData();
    _zffs_loadDataFuture = zffs_loadData();
    super.initState();
  }

// 加载缴费类型
  Future<List<DropDownValueModel>> jflx_loadData() async {
    Database database = await openDatabaseConnection();
    String tableName = "jflx";
    List<Map<String, dynamic>> result = await database.query(tableName);
    List<DropDownValueModel> dataList = result.map((row) {
      String name = row['jflx'];
      String value = row['id'].toString();
      return DropDownValueModel(name: name, value: value);
    }).toList();
    // print(dataList.toString());
    await database.close();
    return dataList;
  }

// 加载支付当时
  Future<List<DropDownValueModel>> zffs_loadData() async {
    Database database = await openDatabaseConnection();
    String tableName = "zffs";
    List<Map<String, dynamic>> result = await database.query(tableName);
    List<DropDownValueModel> zffs_dataList = result.map((row) {
      String name = row['zffs'];
      String value = row['id'].toString();
      return DropDownValueModel(name: name, value: value);
    }).toList();
    // print(dataList.toString());
    await database.close();
    return zffs_dataList;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    // _jine.dispose();
    // _fklx.dispose();
    // _fkfs.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final String currentDate =
        DateFormat('yyyy年MM月dd日').format(DateTime.now()).toUpperCase();
    final Size size = MediaQuery.of(context).size;
    final double width = size.width - 300;
    // 使用Get.put()实例化你的类，使其对当下的所有子路由可用。

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SizedBox(
                  width: width * 0.6,
                  child: Text(
                    currentDate,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.4 - 30,
                  child: TextField(
                    controller: _sjhm,
                    decoration: const InputDecoration(
                      hintText: '收据编号',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 150,
                child: Text(
                  ' 缴费类型：',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: width - 190,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: FutureBuilder<List<DropDownValueModel>>(
                  future: _jflx_loadDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // 显示加载指示器
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}'); // 显示错误信息
                    } else if (snapshot.hasData) {
                      List<DropDownValueModel> dataList = snapshot.data!;
                      return DropDownTextField(
                        controller: _fklx,
                        clearOption: false,
                        enableSearch: true,
                        clearIconProperty: IconProperty(color: Colors.green),
                        searchDecoration:
                            const InputDecoration(hintText: "在这输入过滤文字"),
                        dropDownItemCount: 6,
                        dropDownList: dataList,
                        onChanged: (val) async {
                          //需要查询当前类型下面有多少数据
                          int result = int.parse(val.value);
                          String sjhm = await queryBysjhm(result, 1);
                          int sjhmInt = int.parse(sjhm);
                          int incrementedSjhm = sjhmInt + 1;
                          String resultString = incrementedSjhm.toString();
                          sjhmText.value = resultString;
                          _sjhm.text =
                              '${val.value.toString().padLeft(2, '0')}-${resultString.padLeft(8, '0')}';
                        },
                      );
                    } else {
                      return const Text('没有可用选项，请先管理选项'); // 没有数据时显示消息
                    }
                  },
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                const SizedBox(
                  width: 150,
                  child: Text(
                    ' 付款单位：',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: width - 190,
                  child: TextField(
                    controller: _fkdw,
                    decoration: const InputDecoration(
                      hintText: '',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                const SizedBox(
                  width: 150,
                  child: Text(
                    ' 付款摘由：',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: width - 190,
                  child: TextField(
                    controller: _fkzy,
                    decoration: const InputDecoration(
                      hintText: '',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                const SizedBox(
                  width: 150,
                  child: Text(
                    ' 付款金额：',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: width - 190,
                  child: TextField(
                    controller: _jine,
                    decoration: const InputDecoration(
                      hintText: '',
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,9}(\.\d{0,2})?$')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        jineText.value = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 150,
                child: Text(
                  ' 付款方式：',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: width - 190,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: FutureBuilder<List<DropDownValueModel>>(
                  future: _zffs_loadDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // 显示加载指示器
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}'); // 显示错误信息
                    } else if (snapshot.hasData) {
                      List<DropDownValueModel> zffsDatalist = snapshot.data!;
                      return DropDownTextField(
                        controller: _fkfs,
                        clearOption: false,
                        enableSearch: true,
                        clearIconProperty: IconProperty(color: Colors.green),
                        searchDecoration:
                            const InputDecoration(hintText: "在这输入过滤文字"),
                        dropDownItemCount: 6,
                        dropDownList: zffsDatalist,
                        onChanged: (val) {
                          // _sjhm.text = val.value.toString();
                          //需要查询当前类型下面有多少数据
                        },
                      );
                    } else {
                      return const Text('没有可用选项，请先管理选项'); // 没有数据时显示消息
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                const SizedBox(width: 10),
                const SizedBox(
                  width: 150,
                  child: Text(
                    '金额大写：',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  child: Text(
                    convertToChineseMoney(jineText.value),
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // 按钮的点击事件处理逻辑InvoicePage
                    if (_fkdw.text.isNotEmpty == true &&
                        _fkzy.text.isNotEmpty == true &&
                        _fklx.dropDownValue != null &&
                        _jine.text != null &&
                        double.tryParse(_jine.text)! > 0.00 &&
                        _fkfs.dropDownValue != null) {
                      // 保存数据的过程
                      Invoice invoice = Invoice(
                        fklx_id: int.parse(_fklx.dropDownValue!.value),
                        zffs_id: int.parse(_fkfs.dropDownValue!.value),
                        user_id: c.userid.value,
                        fkdw: _fkdw.text,
                        fkzy: _fkzy.text,
                        fkje: double.parse(_jine.text) ?? 0,
                        fksj: DateTime.now().toString(),
                        sjhm: sjhmText.value,
                        ztid: c.zhangtaoid.value,
                      );
                      insertDataToTable(invoice);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfPreviewPage(
                            invoice: Invoice(
                              fklx_id: int.parse(_fklx.dropDownValue!.value),
                              zffs_id: int.parse(_fkfs.dropDownValue!.value),
                              user_id: c.userid.value,
                              fkdw: _fkdw.text,
                              fkzy: _fkzy.text,
                              fkje: double.parse(_jine.text) ?? 0,
                              fksj: DateTime.now().toString(),
                              sjhm: sjhmText.value,
                              ztid: c.zhangtaoid.value,
                            ),
                          ),
                        ),
                      );
                    } else {
                      // 处理变量为空的情况
                      if (_fklx.dropDownValue == null) {
                        errorMessages.add('付款类型未选择');
                      }
                      if (_fkdw.text?.isEmpty == true) {
                        errorMessages.add('付款单位未填写');
                      }
                      if (_fkzy.text?.isEmpty == true) {
                        errorMessages.add('付款摘要未填写');
                      }
                      if (_fkfs.dropDownValue == null) {
                        errorMessages.add('付款方式未选择');
                      }
                      if (_jine.text?.isEmpty == true ||
                          double.tryParse(_jine.text)! <= 0.00) {
                        errorMessages.add('金额填写错误');
                      }
                      if (errorMessages.isNotEmpty) {
                        String errorMessage = errorMessages.join(', ');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('错误提示$errorMessage'),
                            backgroundColor: Colors.red, // 设置背景色为红色
                          ),
                        );
                        errorMessages = [];
                      }
                    }
                  },
                  child: const Text('保存'),
                ),
              ),
              SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _fkdw.text = '';
                    _fkzy.text = '';
                    _jine.text = '0';
                    _sjhm.text = '';
                    jineText.value = '0';
                    sjhmText.value = '';
                  },
                  child: const Text('清空'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
