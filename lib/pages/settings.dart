import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hy_shouju/main.dart';
import 'package:hy_shouju/models/mysqlite.dart';

class MarginSettingsPage extends StatefulWidget {
  @override
  _MarginSettingsPageState createState() => _MarginSettingsPageState();
}

class _MarginSettingsPageState extends State<MarginSettingsPage> {
  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    AppBar(title: Text('设置'));
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              title: Text('上边距:${c.topMargin.value.toStringAsFixed(2)}'),
              subtitle: Slider(
                value: c.topMargin.value,
                min: 0.0,
                max: 100.0,
                onChanged: (value) {
                  setState(() {
                    c.topMargin.value = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('左边距:${c.leftMargin.value.toStringAsFixed(2)}'),
              subtitle: Slider(
                value: c.leftMargin.value,
                min: 0.0,
                max: 100.0,
                onChanged: (value) {
                  setState(() {
                    c.leftMargin.value = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('右边距:${c.rightMargin.value.toStringAsFixed(2)}'),
              subtitle: Slider(
                value: c.rightMargin.value,
                min: 0.0,
                max: 100.0,
                onChanged: (value) {
                  setState(() {
                    c.rightMargin.value = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 在这里保存页边距设置
          // 可以使用这里的 topMargin、leftMargin 和 rightMargin 值
          // ...
          updateSettings();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
