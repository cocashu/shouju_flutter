import 'dart:io';
import 'package:flutter/material.dart';
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
    final backupMessage = '数据备份至: ${backupFile.path}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(backupMessage)),
    );
  }

  Future<void> restoreDatabase(BuildContext context) async {
    final databasePath = await getDatabasesPath();
    final databaseFile = join(databasePath, databaseName);
    final backupPath = await getApplicationDocumentsDirectory();
    final backupFiles = await file_picker.FilePicker.platform.pickFiles(
      type: file_picker.FileType.custom,
      allowedExtensions: ['db'],
      allowMultiple: false,
    );

    if (backupFiles != null && backupFiles.files.isNotEmpty) {
      final backupFilePath = backupFiles.files.single.path!;
      await File(backupFilePath).copy(databaseFile);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('回复文件的路径为: $backupFilePath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('没有选择恢复的文件')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => backupDatabase(context),
              child: Text('备份数据'),
            ),
            ElevatedButton(
              onPressed: () => restoreDatabase(context),
              child: Text('恢复数据'),
            ),
          ],
        ),
      ),
    );
  }
}
