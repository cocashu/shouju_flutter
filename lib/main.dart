import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hy_shouju/pages/login.dart';

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
        user TEXT,
        password TEXT,
        zhangtao TEXT
      )
    ''');
    await db.execute('''
  INSERT INTO user (user,password, zhangtao)
  VALUES ('admin','202cb962ac59075b964b07152d234b70', '默认账套')
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
        fkzy TEXT,
        fkdw TEXT,
        jine REAL,
        zf_jine REAL,
        uptime DATETIME,
        zhangtao_id int,
        sjhm        TEXT
      )
    ''');
    // 创建 "设置" 表
    await db.execute('''
      CREATE TABLE setting (
        id INTEGER PRIMARY KEY,
        name TEXT,
        value TEXT
      )
    ''');
    await db.execute('''
  INSERT INTO setting (name, value)
  VALUES ('topMargin', '10')
''');
    await db.execute('''
  INSERT INTO setting (name, value)
  VALUES ('leftMargin', '50')
''');
    await db.execute('''
  INSERT INTO setting (name, value)
  VALUES ('rightMargin', '50')
''');
  });

  runApp(const GetMaterialApp(home: RunMyApp()));
}

class Controller extends GetxController {
  var userid = 0.obs; //出纳ID
  var username = ''.obs; //出纳
  var gsname = ''.obs; //公司简称
  var gsnameall = ''.obs; //公司全称
  var zhangtaoid = 0.obs;
  var topMargin = 10.0.obs;
  var leftMargin = 50.0.obs;
  var rightMargin = 50.0.obs;
}

class RunMyApp extends StatelessWidget {
  const RunMyApp({super.key});

  @override
  Widget build(context) {
    return const MaterialApp(
      // title: '鸿宇集团【分公司名字】收费专用',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      //本地化
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh'),
        const Locale('ar'),
        const Locale('ja'),
      ],
      locale: const Locale('zh'),
    );
  }
}
