import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'numbertochinese.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './pages/shouju_list.dart';
import 'package:hy_shouju/pages/pdfexport/pdfpreview.dart';
import 'package:hy_shouju/models/invoice.dart';
import 'package:get/get.dart';

// void main() => runApp(RunMyApp());
void main() => runApp(GetMaterialApp(home: RunMyApp()));

class Controller extends GetxController {
  var username = 'jie'.obs; //出纳
  var gsiname = 'HY商贸'.obs; //公司简称
  var gsinameall = 'ABCD市HY商贸有限责任公司'.obs; //公司全称
}

class RunMyApp extends StatelessWidget {
  late final Invoice invoice;

  @override
  Widget build(context) {
    return const MaterialApp(
      // title: '鸿宇集团【分公司名字】收费专用',
      debugShowCheckedModeBanner: false,
      home: MyCustomForm(),
      //本地化
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('zh', 'CN'),
        Locale('en'), // English
      ],
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final TextEditingController _jine = TextEditingController();
  String displayText = '';
  late SingleValueDropDownController _fklx;
  late SingleValueDropDownController _fkfs;

  final TextEditingController _sjhm = TextEditingController();
  final TextEditingController _fkdw = TextEditingController();
  final TextEditingController _fkzy = TextEditingController();

  late Invoice invoice;
  final Controller c = Get.put(Controller());
  @override
  void initState() {
    _fklx = SingleValueDropDownController();
    _fkfs = SingleValueDropDownController();

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _jine.dispose();
    _fklx.dispose();
    _fkfs.dispose();
    super.dispose();
  }

  selectChange(value) {
    print("值改变了：$value");
  }

  @override
  Widget build(context) {
    final String currentDate =
        DateFormat('yyyy年MM月dd日').format(DateTime.now()).toUpperCase();
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    // 使用Get.put()实例化你的类，使其对当下的所有子路由可用。

    return Scaffold(
      // appBar: AppBar(
      //   title: const Center(
      //     child: Text('鸿宇集团【${c.gsiname}】收费专用'),
      //   ),
      // ),
      appBar: AppBar(
          title: Obx(() => Center(child: Text("鸿宇集团【 ${c.gsiname}】收费专用")))),
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
                child: DropDownTextField(
                  controller: _fklx,
                  clearOption: true, //是否有清除按钮
                  enableSearch: true, //是否过过滤
                  clearIconProperty: IconProperty(color: Colors.green),
                  searchDecoration: const InputDecoration(hintText: "在这输入过滤文字"),
                  dropDownItemCount: 6, //显示多少过滤选项
                  dropDownList: const [
                    DropDownValueModel(name: '安装费', value: "value1"),
                    DropDownValueModel(name: '装修保证金', value: "cocashu"),
                    DropDownValueModel(name: '微信支付手续费', value: "value3"),
                    DropDownValueModel(name: '租金', value: "value4"),
                    DropDownValueModel(name: '储值卡', value: "value5"),
                    DropDownValueModel(name: '管理服务费', value: "value6"),
                    DropDownValueModel(name: '物业费', value: "value7"),
                    DropDownValueModel(name: '保证金', value: "value8"),
                  ],
                  onChanged: (val) {
                    selectChange(val.name.toString());
                    _sjhm.text = val.value.toString();
                    // print(_fklx.dropDownValue!.name.toString());
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
                        displayText = value;
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
                child: DropDownTextField(
                  controller: _fkfs,
                  // textFieldDecoration: '',
                  clearOption: true, //是否有清除按钮
                  enableSearch: false, //是否过过滤
                  clearIconProperty: IconProperty(color: Colors.green),
                  searchDecoration: const InputDecoration(hintText: "在这输入过滤文字"),
                  dropDownItemCount: 6, //显示多少过滤选项
                  dropDownList: const [
                    DropDownValueModel(name: '微信支付', value: "wxpay"),
                    DropDownValueModel(name: '支付宝', value: "alipay"),
                    DropDownValueModel(name: '银行卡', value: "unpay"),
                    DropDownValueModel(name: '现金', value: "xianjin"),
                    // DropDownValueModel(name: 'name5', value: "value5"),
                    // DropDownValueModel(name: 'name6', value: "value6"),
                    // DropDownValueModel(name: 'name7', value: "value7"),
                    // DropDownValueModel(name: 'name8', value: "value8"),
                  ],
                  onChanged: (val) {
                    // selectChange(val.value.toString());
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
                    convertToChineseMoney(displayText),
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
                    // 按钮的点击事件处理逻辑
                  },
                  child: const Text('增加'),
                ),
              ),
              SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // 按钮的点击事件处理逻辑InvoicePage
                  },
                  child: const Text('保存'),
                ),
              ),
              SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InvoicePage()), // 导航到 PrintPage
                    );
                  },
                  child: const Text('列表'),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_fkdw.text.isNotEmpty == true &&
              _fkzy.text.isNotEmpty == true &&
              _fklx.dropDownValue != null &&
              _jine.text != null &&
              double.tryParse(_jine.text)! > 0.00 &&
              _fkfs.dropDownValue != null) {
            print(_fkdw.text + '此处可以增加保存数据的过程');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfPreviewPage(
                  invoice: Invoice(
                    fkdw: _fkdw.text,
                    fkzy: _fkzy.text,
                    fklx: _fklx.dropDownValue!.name.toString(),
                    fkje: double.parse(_jine.text) ?? 0,
                    fksj: DateTime.now().toString(),
                    zffs: _fkfs.dropDownValue!.name.toString(),
                    sjhm: _sjhm.text,
                  ),
                ),
              ),
            );
          } else {
            // 处理变量为空的情况
            // 或者显示错误提示
            if (_fklx.dropDownValue == null) {
              print('付款类型未选择');
            }
            if (_fkdw.text?.isNotEmpty != true) {
              print('付款单位未填写');
            }
            if (_fkzy.text?.isNotEmpty != true) {
              print('付款摘要未填写');
            }
            if (_fkfs.dropDownValue == null) {
              print('付款方式未选择');
            }
            if (_jine.text?.isNotEmpty != true ||
                double.tryParse(_jine.text)! <= 0.00) {
              print('金额填写错误');
            }
          }
        },
        // tooltip: '打印按钮',
        child: const Icon(Icons.print),
      ),
    );
  }
}
