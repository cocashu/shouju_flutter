import 'dart:typed_data';

import 'package:hy_shouju/main.dart';
import 'package:hy_shouju/models/invoice.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';
import 'package:hy_shouju/pages/pdfexport/pdf/zifuchuan_utils.dart';
import 'package:hy_shouju/numbertochinese.dart';
import 'package:get/get.dart';

Future<Uint8List> makePdf(Invoice invoice) async {
  final pdf = Document();
  final Controller c = Get.put(Controller());
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/logo.png')).buffer.asUint8List());
  final ttf =
      await fontFromAssetBundle('fonts/NotoSansSC-VariableFont_wght.ttf');
  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  width: 150,
                  child: Image(imageLogo),
                ),
                Column(
                  children: [
                    Text(
                      "    收    据   ",
                      style: TextStyle(font: ttf, fontSize: 30),
                    ),
                    Text(
                        '                ${DateFormat('yyyy年MM月dd日').format(DateTime.parse(invoice.fksj))}',
                        style: TextStyle(font: ttf, fontSize: 10)),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                          // bottomLeft: Radius.circular(30)
                        )),
                    height: 50,
                    width: 120,
                    child: Wrap(
                      spacing: 8.0, // 子小部件之间的水平间距
                      runSpacing: 8.0, // 子小部件之间的垂直间距
                      children: <Widget>[
                        Text(
                          '加密区:${invoice.fksj}+${invoice.fklx}+${invoice.fkje} \n${invoice.sjhm}',
                          style: TextStyle(font: ttf, fontSize: 7),
                        ),

                        // 添加更多子小部件...
                      ],
                    )
                    // Text(
                    //   "加密区 \n hellohellohellohelloh hellohellohellohelloh hellohellohellohelloh\n  ${invoice.sjhm}",
                    //   style: TextStyle(font: ttf, fontSize: 7),
                    // ),
                    ),
              ],
            ),
            Container(height: 5),
            Container(
              width: 600,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Column(children: [
                SizedBox(
                  height: 8,
                ),
                Row(children: [
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    '今收到${invoice.fkdw}',
                    style: TextStyle(font: ttf, fontSize: 12),
                  ),
                  Container(
                      width: 310 -
                          (calculateStringWidth(
                              invoice.fkdw, 12))), //计算字符串长度，以保证相对位置稳定
                  Text(
                    '收费类型:${invoice.fklx}',
                    style: TextStyle(font: ttf, fontSize: 12),
                  ),
                ]),
                Divider(
                  //虚线
                  height: 1,
                  borderStyle: BorderStyle.dashed,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Text(
                    ' 摘由:${invoice.fkzy}',
                    style: TextStyle(font: ttf, fontSize: 12),
                  ),
                  Container(
                      width: 350 -
                          (calculateStringWidth(
                              invoice.fkzy, 12))), //计算字符串长度，以保证相对位置稳定
                  Text(
                    '支付方式:${invoice.zffs}',
                    style: TextStyle(font: ttf, fontSize: 12),
                  ),
                ]),
                Divider(
                  //虚线
                  height: 1,
                  borderStyle: BorderStyle.dashed,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Text(
                    ' 人民币:${convertToChineseMoney(invoice.fkje.toStringAsFixed(2))}',
                    style: TextStyle(font: ttf, fontSize: 12),
                  ),
                  Container(
                      width: 320 -
                          (calculateStringWidth(
                              convertToChineseMoney(
                                  invoice.fkje.toStringAsFixed(2)),
                              12))), //计算字符串长度，以保证相对位置稳定
                  Text(
                    '(小写：${invoice.fkje.toStringAsFixed(2)})',
                    style: TextStyle(font: ttf, fontSize: 12),
                  ),
                ]),
                Divider(
                  //虚线
                  height: 1,
                  borderStyle: BorderStyle.dashed,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Text(
                    ' 单位盖章：${c.gsinameall}',
                    style: TextStyle(font: ttf, fontSize: 10),
                  ),
                ]),
                Row(children: [
                  SizedBox(
                    width: 300,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    ' 交款人签字：',
                    style: TextStyle(font: ttf, fontSize: 10),
                  ),
                ]),
              ]),
            ),
            Row(children: [
              Text(
                ' 负责人:',
                style: TextStyle(font: ttf, fontSize: 10),
              ),
              SizedBox(
                width: 100,
              ),
              Text(
                ' 会计:',
                style: TextStyle(font: ttf, fontSize: 10),
              ),
              SizedBox(
                width: 100,
              ),
              Text(
                ' 出纳:${c.username}',
                style: TextStyle(font: ttf, fontSize: 10),
              ),
              SizedBox(
                width: 100,
              ),
              Text(
                ' 记账:',
                style: TextStyle(font: ttf, fontSize: 10),
              ),
            ]),
          ],
        );
      },
    ),
  );
  return pdf.save();
}

// ignore: non_constant_identifier_names
Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );
