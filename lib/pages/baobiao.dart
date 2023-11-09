import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart' as picker;
import 'package:hy_shouju/models/mysqlite.dart';
import 'package:hy_shouju/models/riqi.dart';

class MyAppbiaobiaoPage extends StatefulWidget {
  const MyAppbiaobiaoPage({Key? key}) : super(key: key); //嵌套模式
  @override
  _MyAppbiaobiaoPageState createState() => _MyAppbiaobiaoPageState();
}

class _MyAppbiaobiaoPageState extends State<MyAppbiaobiaoPage> {
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> zffsdataList = [];
  List<DataGridRow> _dataGridRows = [];
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

  // 刷新数据
  Future<void> fetchData() async {
    Database database = await openDatabaseConnection();
    String tableName = "jflx";
    List<Map<String, dynamic>> result = await database.query(tableName);
    setState(() {
      dataList = result;
    });
    await database.close();
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
    });
  }

  Future<void> zffsData() async {
    Database database = await openDatabaseConnection();
    String tableName = "zffs";
    List<Map<String, dynamic>> result = await database.query(tableName);
    setState(() {
      zffsdataList = result;
    });
    await database.close();
  }

  Future<void> fetchDataFromDatabase(String bblx,
      {DateTime? datastart, DateTime? dataend}) async {
    List<Map<String, dynamic>> databaseData = [];
    List<Map<String, dynamic>> result =
        await querySummaryData(bblx, datastart, dataend);
    databaseData = result;
    _dataGridRows = databaseData.map((data) {
      return DataGridRow(cells: [
        DataGridCell<int>(
          columnName: 'id',
          value: data['id'],
        ),
        DataGridCell<String>(columnName: 'name', value: data['name']),
        DataGridCell<double>(
          columnName: 'jine',
          value: data['jine'],
        ),
        DataGridCell<double>(columnName: 'zfjine', value: data['zfjine']),
      ]);
    }).toList();

    // 更新表格数据
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    zffsData();
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
                      const SizedBox(height: 50),
                      const Text(
                        '点击项目查看报表',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        // flex: 2,
                        child: ListView.builder(
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // 显示固定的标题
                              return ListTile(
                                title: const Text('按缴费类型汇总'),
                                onTap: () {
                                  // 处理点击事件
                                  fetchDataFromDatabase('jflx',
                                      datastart: _startDate,
                                      dataend: _endDate.add(const Duration(
                                          days: 1))); //  // 结束日期加一
                                },
                              );
                            } else if (index == 1) {
                              // 显示固定的标题
                              return ListTile(
                                title: const Text('按支付方式汇总'),
                                onTap: () {
                                  // 处理点击事件
                                  fetchDataFromDatabase('zffs',
                                      datastart: _startDate,
                                      dataend: _endDate.add(
                                          const Duration(days: 1))); // 结束日期加一
                                },
                              );
                            }
                          },
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
            flex: 6,
            child: SfDataGrid(
              source: _MyCustomDataSource(dataGridRows: _dataGridRows),
              tableSummaryRows: [
                GridTableSummaryRow(
                    showSummaryInRow: true,
                    title: '金额合计: {jine}元，作废金额{zfjine} ',
                    // showSummaryInRow: false,
                    columns: [
                      const GridSummaryColumn(
                          name: 'jine',
                          columnName: 'jine',
                          summaryType: GridSummaryType.sum),
                      const GridSummaryColumn(
                          name: 'zfjine',
                          columnName: 'zfjine',
                          summaryType: GridSummaryType.sum),
                    ],
                    position: GridTableSummaryRowPosition.bottom)
              ],
              columns: [
                GridColumn(
                    columnName: 'id',
                    width: (GetPlatform.isDesktop && GetPlatform.isMobile) ||
                            !GetPlatform.isDesktop
                        ? 120.0
                        : double.nan,
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'ID',
                        ))),
                GridColumn(
                    columnName: 'name',
                    width: (GetPlatform.isDesktop && GetPlatform.isMobile) ||
                            !GetPlatform.isDesktop
                        ? 120.0
                        : double.nan,
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text(
                          '名称',
                        ))),
                GridColumn(
                    columnName: 'jine',
                    width: (GetPlatform.isDesktop && GetPlatform.isMobile) ||
                            !GetPlatform.isDesktop
                        ? 120.0
                        : double.nan,
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text(
                          '金额',
                        ))),
                GridColumn(
                    columnName: 'zfjine',
                    width: (GetPlatform.isDesktop && GetPlatform.isMobile) ||
                            !GetPlatform.isDesktop
                        ? 120.0
                        : double.nan,
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text(
                          '作废金额',
                          // overflow: TextOverflow.ellipsis,
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyCustomDataSource extends DataGridSource {
  _MyCustomDataSource({required List<DataGridRow> dataGridRows}) {
    _dataGridRows = dataGridRows;
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;
  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Text(summaryValue),
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
