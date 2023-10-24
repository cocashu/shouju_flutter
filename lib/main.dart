import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'numbertochinese.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './pages/shouju_list.dart';
import 'package:hy_shouju/pages/pdfexport/pdfpreview.dart';
import 'package:hy_shouju/models/invoice.dart';

void main() => runApp(RunMyApp());

class RunMyApp extends StatelessWidget {
  late final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '鸿宇集团【分公司名字】收费专用',
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
  final TextEditingController myController = TextEditingController();
  String displayText = '';
  late SingleValueDropDownController _cnt;

  @override
  void initState() {
    _cnt = SingleValueDropDownController();

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    _cnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String currentDate =
        DateFormat('yyyy年MM月dd日').format(DateTime.now()).toUpperCase();
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    final invoice = Invoice(
        fkdw: '打印测试',
        fkzy: '房屋租金2020年10月1日至2022年10月1 日',
        fklx: '房屋租金',
        fkje: 999999999.99,
        fksj: currentDate,
        zffs: '支付宝',
        sjhm: '1234567890');

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('鸿宇集团【分公司名字】收费专用'),
        ),
      ),
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
                  child: const TextField(
                    decoration: InputDecoration(
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
                  controller: _cnt,
                  // textFieldDecoration: '',
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
                    // selectChange(val.value.toString());
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
                  child: const TextField(
                    decoration: InputDecoration(
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
                  child: const TextField(
                    decoration: InputDecoration(
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
                    controller: myController,
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
                  controller: _cnt,
                  // textFieldDecoration: '',
                  clearOption: true, //是否有清除按钮
                  enableSearch: false, //是否过过滤
                  clearIconProperty: IconProperty(color: Colors.green),
                  searchDecoration: const InputDecoration(hintText: "在这输入过滤文字"),
                  dropDownItemCount: 6, //显示多少过滤选项
                  dropDownList: const [
                    DropDownValueModel(name: '微信支付', value: "wxpay"),
                    DropDownValueModel(name: '支付宝', value: "alipay"),
                    DropDownValueModel(name: '银行卡', value: "value3"),
                    DropDownValueModel(name: '现金', value: "value4"),
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
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PdfPreviewPage(invoice: invoice)), // 导航到 PrintPage
          );
        },
        // tooltip: '打印按钮',
        child: const Icon(Icons.print),
      ),
    );
  }
}
