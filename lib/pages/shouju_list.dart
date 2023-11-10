import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hy_shouju/main.dart';
import 'package:hy_shouju/models/invoice.dart';
import 'package:hy_shouju/pages/pdfexport/pdfpreview.dart';
import 'package:hy_shouju/models/mysqlite.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:hy_shouju/models/riqi.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart' as picker;

class InvoicePage extends StatefulWidget {
  InvoicePage({Key? key}) : super(key: key);

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final Controller c = Get.put(Controller());
  List<Map<String, dynamic>> dataList = [];
  int _value = 1;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  void _onSelectedDateChanged(DateTime date) {
    if (date == null || date == _startDate) {
      return;
    }

    setState(() {
      final Duration difference = _endDate.difference(_startDate);
      _startDate = DateTime(date.year, date.month, date.day);
      _endDate = _startDate.add(difference);
    });
  }

  void _onSelectedRangeChanged(picker.PickerDateRange dateRange) {
    final DateTime startDateValue = dateRange.startDate!;
    final DateTime endDateValue = dateRange.endDate ?? startDateValue;
    setState(() {
      if (startDateValue.isAfter(endDateValue)) {
        _startDate = endDateValue;
        _endDate = startDateValue;
      } else {
        _startDate = startDateValue;
        _endDate = endDateValue;
      }
      fetchseData(
          datastart: _startDate,
          dataend: _endDate.add(const Duration(days: 1))); // 结束日期加一
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

// 按日期区间查询
  Future<void> fetchseData({DateTime? datastart, DateTime? dataend}) async {
    Database database = await openDatabaseConnection();
    String query = 'SELECT * FROM fkmx WHERE 1=1';
    List<dynamic> params = [];
    if (datastart != null && dataend != null) {
      query += ' AND uptime >= ? AND uptime <= ?';
      params.addAll([datastart.toString(), dataend.toString()]);
    }
    List<Map<String, dynamic>> result = await database.rawQuery(query, params);
    await database.close();
    setState(() {
      dataList = result;
    });
    await database.close();
  }

// 加载收据列表
  Future<void> fetchData() async {
    Database database = await openDatabaseConnection();
    String tableName = "fkmx";
    List<Map<String, dynamic>> result = await database.query(tableName);
    setState(() {
      dataList = result;
    });
    await database.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: const Text(
                          '选择日期',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      Row(children: <Widget>[
                        Expanded(
                            flex: 5,
                            child: RawMaterialButton(
                                padding: const EdgeInsets.all(5),
                                onPressed: () async {
                                  if (_value == 0) {
                                    final DateTime? date =
                                        await showDialog<DateTime?>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DateRangePicker(
                                                _startDate,
                                                null,
                                                displayDate: _startDate,
                                                minDate: DateTime.now(),
                                              );
                                            });
                                    if (date != null) {
                                      _onSelectedDateChanged(date);
                                    }
                                  } else {
                                    final picker.PickerDateRange? range =
                                        await showDialog<
                                                picker.PickerDateRange?>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DateRangePicker(
                                                null,
                                                picker.PickerDateRange(
                                                  _startDate,
                                                  _endDate,
                                                ),
                                                displayDate: _startDate,
                                                maxDate: DateTime.now(),
                                              );
                                            });

                                    if (range != null) {
                                      _onSelectedRangeChanged(range);
                                    }
                                  }
                                },
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const Text('开始日期',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 5, 0),
                                          child: Text(
                                              DateFormat('yyyy MMM dd')
                                                  .format(_startDate),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ],
                                    )))),
                        Expanded(
                            flex: 5,
                            child: RawMaterialButton(
                                padding: const EdgeInsets.all(5),
                                onPressed: _value == 0
                                    ? null
                                    : () async {
                                        final picker.PickerDateRange? range =
                                            await showDialog<
                                                    picker.PickerDateRange>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DateRangePicker(
                                                    null,
                                                    picker.PickerDateRange(
                                                        _startDate, _endDate),
                                                    displayDate: _endDate,
                                                    maxDate: DateTime.now(),
                                                  );
                                                });

                                        if (range != null) {
                                          _onSelectedRangeChanged(range);
                                        }
                                      },
                                child: Container(
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _value == 0
                                          ? <Widget>[
                                              const Text('结束日期',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ]
                                          : <Widget>[
                                              const Text('结束日期',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10)),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 5, 5, 0),
                                                child: Text(
                                                    DateFormat('yyyy MMM dd')
                                                        .format(_endDate),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            ],
                                    ))))
                      ]),
                    ],
                  ),
                );
              },
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 6,
            child: dataList.isNotEmpty
                ? ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = dataList[index];
                      Invoice invoice = Invoice(
                        fklx_id: data['jflx_id'],
                        zffs_id: data['zffs_id'],
                        user_id: data['user_id'],
                        fkdw: data['fkdw'],
                        fkzy: data['fkzy'],
                        fkje: data['jine'],
                        fksj: data['uptime'],
                        sjhm: data['sjhm'], // 根据你的实际情况进行修改
                        ztid: data['zhangtao_id'],
                      );
                      return Dismissible(
                        key: Key(dataList[index].toString()),
                        onDismissed: (direction) async {
                          // 处理滑动操作的逻辑
                        },
                        background: Container(
                          color: Colors.red, // 左滑时显示的背景颜色
                          child: Icon(Icons.settings), // 左滑时显示的图标或其他内容
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart &&
                              data['zf_jine'] != 0.0) {
                            // 显示"作废"和"取消"选项
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('还原作废？'),
                                  content: const Text('您确定要还原这条数据吗？'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('取消'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        unmodifyData(
                                            invoice.fklx_id, invoice.sjhm);
                                        Navigator.of(context).pop(false);
                                        fetchData();
                                      },
                                      child: const Text('还原'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (direction == DismissDirection.endToStart &&
                              data['zf_jine'] == 0.0) {
                            // 显示"作废"和"取消"选项
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('无法操作'),
                                  content: const Text('不能操作该数据'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('确定'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (direction == DismissDirection.startToEnd &&
                              data['jine'] != 0.0) {
                            // 左滑操作
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('确认作废？'),
                                  content: const Text('您确定要作废这条数据吗？'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('取消'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        modifyData(
                                            invoice.fklx_id, invoice.sjhm);
                                        Navigator.of(context).pop(false);
                                        fetchData();
                                      },
                                      child: const Text('作废'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (direction == DismissDirection.startToEnd &&
                              data['jine'] == 0.0) {
                            // 显示"作废"和"取消"选项
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('无法操作'),
                                  content: const Text('不能操作该数据'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('确定'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          return true;
                        },
                        child: ListTile(
                          title: invoice.fkje == 0
                              ? Text(
                                  '${invoice.fklx_id}-${invoice.fkdw}【已作废】',
                                  // 设置颜色
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                )
                              : Text('${invoice.fklx_id}-${invoice.fkdw}'),
                          //待添加文字颜色
                          subtitle: Text(invoice.fkzy),
                          trailing:
                              Text('\￥${invoice.fkje.toStringAsFixed(2)}'),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (builder) =>
                                    PdfPreviewPage(invoice: invoice),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text('没有数据'),
                  ),
          ),
        ],
      ),
    );
  }
}
