import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hy_shouju/pages/zhifu_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'numbertochinese.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './pages/shouju_list.dart';
import 'package:hy_shouju/pages/pdfexport/pdfpreview.dart';
import 'package:hy_shouju/models/invoice.dart';
import 'package:get/get.dart';
import './pages/leixing_page.dart';
import './pages/shouju.dart';
import 'package:path/path.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';

// void main() => runApp(GetMaterialApp(home: RunMyApp()));//s
void main() async {
  sqfliteFfiInit();
  WidgetsFlutterBinding.ensureInitialized();
  databaseFactory = databaseFactoryFfi;
  var databasesPath = await getDatabasesPath();
  var databasePath = join(databasesPath, 'my_database.db');
  var database = await openDatabase(databasePath, version: 1,
      onCreate: (db, version) async {
    // 创建 "jflx" 表
    await db.execute('''
        CREATE TABLE jflx (
        id INTEGER PRIMARY KEY,
        jflx TEXT,
        zhangtao TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE zffs (
        id INTEGER PRIMARY KEY,
        zffs TEXT,
        zhangtao TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT,
        zhangtao TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE zt (
        id INTEGER PRIMARY KEY,
        zhangtao TEXT,
        gsname TEXT
      )
    ''');
    // 创建 "缴费明细" 表
    await db.execute('''
      CREATE TABLE fkmx (
        id INTEGER PRIMARY KEY,
        jflx_id int,
        zffs_id int,
        user_id int,
        jine REAL,
        zf_jine REAL,
        uptime DATETIME,
        zhangtao_id int
      )
    ''');
  });

  runApp(GetMaterialApp(home: RunMyApp()));
}

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
  final Controller c = Get.put(Controller());
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  final titlestr = ''.obs;
  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.

    super.dispose();
  }

  selectChange(value) {}

  @override
  Widget build(context) {
    titlestr.value = "鸿宇集团【 ${c.gsiname}】收费专用---开收据";

    return Scaffold(
      // titlestr.value="鸿宇集团【 ${c.gsiname}】收费专用",
      appBar: AppBar(title: Obx(() => Center(child: Text(titlestr.value)))),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              // showTooltip: false,
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: Colors.blue[100],
              selectedHoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(10)),
              // ),
              // backgroundColor: Colors.blueGrey[700]
            ),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    // maxHeight: 150,
                    maxWidth: 200,
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            footer: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: Text(
                    'CocaShu',
                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                  ),
                ),
              ),
            ),
            items: [
              SideMenuItem(
                title: '收据开具',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsiname}】收费专用---开收据";
                  // Get.to(shouju_page());
                },
                icon: const Icon(Icons.home),
                tooltipContent: "This is a tooltip for Dashboard item",
              ),
              SideMenuItem(
                title: '收据列表',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsiname}】收费专用---收据列表";
                },
                icon: const Icon(Icons.list),
                tooltipContent: "This is a tooltip for Dashboard item",
              ),
              SideMenuItem(
                title: '用户管理',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsiname}】收费专用---用户管理";
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                title: '数据备份',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsiname}】收费专用---数据备份";
                },
                icon: const Icon(Icons.file_copy_rounded),
                trailing: Container(
                    decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 3),
                      child: Text(
                        'New',
                        style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                      ),
                    )),
              ),
              SideMenuItem(
                title: '下载数据',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsiname}】收费专用---下载数据";
                },
                icon: const Icon(Icons.download),
              ),
              SideMenuItem(
                builder: (context, displayMode) {
                  return const Divider(
                    endIndent: 8,
                    indent: 8,
                  );
                },
              ),
              SideMenuItem(
                title: '缴费类型管理',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsiname}】收费专用---缴费类型管理";
                  // Get.to(TypeManagementPage());
                },
                icon: const Icon(Icons.settings),
              ),
              SideMenuItem(
                title: '支付方式管理',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsiname}】收费专用--支付方式管理";
                  // Get.to(zffs_TypeManagementPage());
                },
                icon: const Icon(Icons.settings),
              ),
              SideMenuItem(
                title: '软件设置',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsiname}】收费专用--软件设置";
                },
                icon: const Icon(Icons.settings),
              ),
              const SideMenuItem(
                title: '退出',
                icon: Icon(Icons.exit_to_app),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                Container(color: Colors.white, child: const shouju_page()),
                Container(color: Colors.white, child: InvoicePage()),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      '用户',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Files',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Download',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      '--',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: TypeManagementPage(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: zffs_TypeManagementPage(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
