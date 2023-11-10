import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hy_shouju/models/mysqlite.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:file_picker/file_picker.dart' as file_picker;

class MybakHomePage extends StatelessWidget {
  final String databaseName = 'my_database.db';
  final String backupName = 'backup.db';

  //备份数据库到指定位置

  Future<void> backupDatabase(BuildContext context) async {
    final databasePath = await getDatabasesPath();
    final databaseFile = join(databasePath, databaseName);
    final backupPath = await getApplicationDocumentsDirectory();

    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd_HH-mm-ss');
    final backupFileName = 'backup_${formatter.format(now)}.db';
    final backupFilePath = join(backupPath.path, backupFileName);

    final database = await openDatabase(databaseFile);
    await database.close();

    final backupFile = await File(databaseFile).copy(backupFilePath);
    final backupMessage = '数据备份成功，已保存至: ${backupFile.path}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(backupMessage)),
    );
  }

  Future<void> restoreDatabase(BuildContext context) async {
    final databasePath = await getDatabasesPath();
    final databaseFile = join(databasePath, databaseName);
    final backupFiles = await file_picker.FilePicker.platform.pickFiles(
      type: file_picker.FileType.custom,
      allowedExtensions: ['db'],
      allowMultiple: false,
    );
    if (backupFiles != null && backupFiles.files.isNotEmpty) {
      final backupFilePath = backupFiles.files.single.path!;
      await File(backupFilePath).copy(databaseFile);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('恢复备份文件的路径为: $backupFilePath,恢复成功！')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('没有选择需要恢复的文件')),
      );
    }
  }

  //升级更新数据库
  Future<void> xuanzeupgradefile(BuildContext context) async {
    final backupFiles = await file_picker.FilePicker.platform.pickFiles(
      type: file_picker.FileType.custom,
      allowedExtensions: ['sql'],
      allowMultiple: false,
    );
    if (backupFiles != null && backupFiles.files.isNotEmpty) {
      final backupFilePath = backupFiles.files.single.path!;
      final databaseFile = File(backupFilePath);

      String fileContent = await databaseFile.readAsString();
      List<String> upgradeCommands = fileContent.split('\n');
      print(upgradeCommands);
      // 执行数据库升级
      await upgradeDatabase(upgradeCommands);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('升级文件的路径为: $backupFilePath,升级成功！')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('没有选择升级的文件')),
      );
    }
  }

  Future<void> upgradeDatabase(List<String> upgradeCommands) async {
    Database database = await openDatabaseConnection();
    Batch batch = database.batch();
    for (String command in upgradeCommands) {
      batch.execute(command);
    }
    await batch.commit();
  }

  void checkUserRole(BuildContext context) {
    if (c.username == 'admin') {
      xuanzeupgradefile(context);
    } else {
      showUserNotAdminAlert(context); // 当前用户不是admin，弹出提示
    }
  }

  void showUserNotAdminAlert(BuildContext context) {
    // 在此处弹出提示，告知用户不是admin
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('管理员提示'),
          content: const Text('您不是管理员，不能使用升级功能'),
          actions: [
            ElevatedButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () =>
                    checkUserRole(context), //xuanzeupgradefile(context),
                child: const Text('数据升级'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () => backupDatabase(context),
                child: const Text('备份数据'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () => restoreDatabase(context),
                child: const Text('恢复数据'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
