import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hy_shouju/pages/login.dart';

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
        user TEXT,
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
        fkzy TEXT,
        fkdw TEXT,
        jine REAL,
        zf_jine REAL,
        uptime DATETIME,
        zhangtao_id int,
        sjhm        TEXT
      )
    ''');
  });

  runApp(const GetMaterialApp(home: RunMyApp()));
}

class Controller extends GetxController {
  var userid = 0.obs; //出纳
  var username = 'jie'.obs; //出纳
  var gsiname = 'HY商贸'.obs; //公司简称
  var gsinameall = 'ABCD市HY商贸有限责任公司'.obs; //公司全称
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
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('zh', 'CN'),
        Locale('en'), // English
      ],
    );
  }
}
