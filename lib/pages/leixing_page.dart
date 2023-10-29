import 'package:flutter/material.dart';
import 'package:hy_shouju/main.dart';

class Type {
  final String name;
  final String description;
  Type(this.name, this.description);
}

class TypeManagementPage extends StatefulWidget {
  @override
  _TypeManagementPageState createState() => _TypeManagementPageState();
}

class _TypeManagementPageState extends State<TypeManagementPage> {
  final TextEditingController _jiaofeileixing = TextEditingController();
  List<Type> types = [
    Type('类型1', '这是类型1的描述'),
    Type('类型2', '这是类型2的描述'),
    Type('类型3', '这是类型3的描述'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('类型管理'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 3,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final leftWidth = constraints.maxWidth / 2;
                return Container(
                  width: leftWidth,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Text(
                        '增加缴费类型',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: leftWidth,
                        child: const TextField(
                          // controller: _jiaofeileixing,
                          decoration: InputDecoration(
                            // hintText: '文本框',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: leftWidth,
                        child: ElevatedButton(
                          onPressed: () {
                            // 按钮点击事件处理逻辑
                            // controller.addToDatabase('缴费类型 4');
                          },
                          child: const Text('增加'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 7,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final leftWidth = constraints.maxWidth / 2;
                return Container(
                  width: leftWidth,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Text(
                        '当前缴费类型(点击项目可修改-待处理)',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        flex: 7,
                        child: ListView.builder(
                          itemCount: types.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(types[index].name),
                              subtitle: Text(types[index].description),
                              onTap: () {
                                // 处理点击事件
                                // 可以在这里进行类型编辑、删除等操作
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
