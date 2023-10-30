import 'package:flutter/material.dart';
import 'package:hy_shouju/models/invoice.dart';
import 'package:hy_shouju/pages/pdfexport/pdfpreview.dart';

class InvoicePage extends StatelessWidget {
  InvoicePage({Key? key}) : super(key: key);

  final invoices = <Invoice>[
    Invoice(
        fkdw: 'David Thomas',
        fkzy: '11Fake St\r\nBermuda Triangle',
        fklx: 'software package',
        fkje: 1000.00,
        fksj: '2023-10-21',
        zffs: 'Credit Card',
        sjhm: '1234567890'),
    Invoice(
        fkdw: '打发士大夫',
        fkzy: '房屋租金2020年10月1日至2022年10月1 日',
        fklx: '房屋租金',
        fkje: 999999999.99,
        fksj: '2023-10-22',
        zffs: '微信支付',
        sjhm: '1234567890'),
    Invoice(
        fkdw: 'David',
        fkzy: '33 Fake St\r\nBermuda Triangle',
        fklx: 'software package',
        fkje: 123.456,
        fksj: '2023-10-23',
        zffs: 'Credit Card',
        sjhm: '1234567890'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('收据列表'),
      // ),
      body: ListView(
        children: [
          ...invoices.map(
            (e) => ListTile(
              title: Text(e.fkdw),
              subtitle: Text(e.fkzy),
              trailing: Text('\$${e.fkje.toStringAsFixed(2)}'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (builder) => PdfPreviewPage(invoice: e),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
