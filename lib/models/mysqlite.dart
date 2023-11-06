import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'invoice.dart';

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
