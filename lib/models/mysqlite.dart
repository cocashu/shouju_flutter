import 'dart:ffi';

import 'package:get/get.dart';
import 'package:hy_shouju/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'invoice.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

final Controller c = Get.put(Controller());

//MD5
String generateMd5(String input) {
  var bytes = utf8.encode(input); // 将字符串转换为字节数组
  var digest = md5.convert(bytes); // 进行MD5加密
  return digest.toString(); // 将加密结果转换为字符串
}

// 打开数据库
Future<Database> openDatabaseConnection() async {
  String databasePath = await getDatabasesPath();
  String databaseFile = join(databasePath, 'my_database.db');
  return openDatabase(databaseFile);
}

// 判断zt表中是否有数据
Future<bool> isExistData(String tableName) async {
  Database database = await openDatabaseConnection();
  List<Map<String, dynamic>> result = await database.rawQuery(
    'SELECT * FROM $tableName',
  );
  await database.close();
  if (result.isNotEmpty) {
    return false;
  } else {
    return true;
  }
}

//查询账套表
Future<List<Map<String, dynamic>>> queryZtTable() async {
  Database database = await openDatabaseConnection();
  List<Map<String, dynamic>> result =
      await database.query('zt', columns: ['id', 'zhangtao', 'gsname']);
  await database.close();
  return result;
}

//保存收据
Future<void> insertDataToTable(Invoice invoice) async {
  Database database = await openDatabaseConnection();
  await database.insert(
    'fkmx',
    {
      'jflx_id': invoice.fklx_id,
      'zffs_id': invoice.zffs_id,
      'user_id': invoice.user_id,
      'fkzy': invoice.fkzy,
      'fkdw': invoice.fkdw,
      'jine': invoice.fkje,
      'uptime': invoice.fksj,
      'sjhm': invoice.sjhm,
      'zhangtao_id': invoice.ztid, //默认账套
      'zf_jine': 0, //默认作废金额0
    },
  );
  await database.close();
}

//查询某类型收据最大编号
Future<String> queryBysjhm(int id, int zhangTao) async {
  Database database = await openDatabaseConnection();
  List<Map<String, dynamic>> result = await database.rawQuery(
    'SELECT sjhm FROM fkmx WHERE jflx_id = ? AND zhangtao_id = ?',
    [id, zhangTao],
  );
  await database.close();

  if (result.isNotEmpty) {
    return result.first['sjhm'];
  } else {
    return '0';
  }
}

//返回指定id 的类型名称
Future<String> queryById(int id, String tableName, String zhangTao) async {
  Database database = await openDatabaseConnection();
  List<Map<String, dynamic>> result = await database.rawQuery(
    'SELECT $tableName FROM $tableName WHERE id = ? AND zhangTao = ?',
    [id, zhangTao],
  );
  await database.close();

  if (result.isNotEmpty) {
    return result.first['$tableName'];
  } else {
    return '未找到指定项目';
  }
}

//用于判断用户密码
Future<String> queryBypass(String user) async {
  Database database = await openDatabaseConnection();
  List<Map<String, dynamic>> result = await database.rawQuery(
    'SELECT password FROM user WHERE user = ?',
    [user],
  );
  await database.close();

  if (result.isNotEmpty) {
    return result.first['password'];
  } else {
    return '0';
  }
}

// 用于判断用户名是否重复
Future<bool> checkUsernameDuplicate(String username) async {
  Database database = await openDatabaseConnection();
  String tableName = "user";
  List<Map<String, dynamic>> result = await database.query(
    tableName,
    where: 'user = ?',
    whereArgs: [username],
  );
  await database.close();

  return result.isNotEmpty;
}

//查询user 表中ID为1 的密码
Future<String> queryPassword(int id) async {
  Database database = await openDatabaseConnection();
  String tableName = "user";
  var result = await database.query(tableName, where: 'id =?', whereArgs: [id]);
  if (result.isNotEmpty) {
    return result.first['password'].toString();
  } else {
    return '无';
  }
}

//验证密码是否正确

Future<bool> verifyOldPassword(
    int id, String oldPassword, String zhangtao) async {
  Database database = await openDatabaseConnection();
  List<Map<String, dynamic>> result = await database.rawQuery(
    'SELECT password FROM user WHERE id = ? AND zhangTao = ?',
    [id, zhangtao],
  );
  await database.close();

  return generateMd5(oldPassword) == result.first['password'];
}
// 查询用户id

Future<int> getUserIdByUsername(String username) async {
  Database database = await openDatabaseConnection();
  List<Map<String, dynamic>> result = await database.query('user',
      columns: ['id'], where: 'user = ?', whereArgs: [username]);
  await database.close();

  if (result.isNotEmpty) {
    return result[0]['id'];
  } else {
    return -1; // 返回一个负数表示未找到用户
  }
}

// 修改数据
Future<void> performUpdate(int id, String newpass) async {
  // 在这里执行实际的更新操作
  // 使用传入的id和newJflx参数更新数据库中的数据
  Database database = await openDatabaseConnection();
  String tableName = "user";

  Map<String, dynamic> updatedData = {
    "password": generateMd5(newpass),
  };
  await database.update(
    tableName,
    updatedData,
    where: 'id = ?',
    whereArgs: [id],
  );

  // // 重新获取数据并更新UI
  // setState(() {
  //   fetchData();
  // });
  await database.close();
}

// 作废收据
void modifyData(int fklxid, String sjhm) async {
  Database database = await openDatabaseConnection();
  // 执行数据库更新操作
  await database.execute('''
    UPDATE fkmx
    SET zf_jine = jine, jine = 0.00
    WHERE jflx_id = $fklxid AND sjhm = '$sjhm'
  ''');
  // 关闭数据库连接
  await database.close();
}

void unmodifyData(int fklxid, String sjhm) async {
  Database database = await openDatabaseConnection();
  // 执行数据库更新操作
  await database.execute('''
    UPDATE fkmx
    SET jine = zf_jine, zf_jine = 0.00
    WHERE jflx_id = $fklxid AND sjhm = '$sjhm'
  ''');
  // 关闭数据库连接
  await database.close();
}

//保存配置到数据库
Future<void> updateSettings() async {
  Database database = await openDatabaseConnection();

  try {
    await database.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE setting SET value = ? WHERE name = ?',
        [c.topMargin.value.toStringAsFixed(2), 'topMargin'],
      );
      await txn.rawUpdate(
        'UPDATE setting SET value = ? WHERE name = ?',
        [c.leftMargin.value.toStringAsFixed(2), 'leftMargin'],
      );
      await txn.rawUpdate(
        'UPDATE setting SET value = ? WHERE name = ?',
        [c.rightMargin.value.toStringAsFixed(2), 'rightMargin'],
      );
    });
  } catch (e) {
    print('错误: $e');
  } finally {
    await database.close();
  }
}

//读取配置到数据库
Future<List<Map<String, dynamic>>> readFromSettingsTable() async {
  Database database = await openDatabaseConnection();
  // 执行数据库查询操作
  List<Map<String, dynamic>> results = await database.query('setting');
  // 关闭数据库连接
  await database.close();
  // 返回查询结果
  return results;
}
