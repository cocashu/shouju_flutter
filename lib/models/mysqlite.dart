import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'invoice.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

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
      'zhangtao_id': 1, //默认账套
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
Future<String> queryBypass(String user, String zhangTao) async {
  Database database = await openDatabaseConnection();
  List<Map<String, dynamic>> result = await database.rawQuery(
    'SELECT password FROM user WHERE user = ? AND zhangTao = ?',
    [user, zhangTao],
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
Future<String> queryPassword() async {
  Database database = await openDatabaseConnection();
  String tableName = "user";
  var result = await database.query(tableName, where: 'id =?', whereArgs: [1]);
  if (result.isNotEmpty) {
    return result.first['password'].toString();
  } else {
    return '无';
  }
}

// 验证密码是否正确
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
