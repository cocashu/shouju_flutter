String convertToChineseMoney(String amount) {
  double num = double.tryParse(amount) ?? 0.0;
  String numText = num.toStringAsFixed(2);

  List<String> numdx = ['零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖'];
  List<String> danwei = [
    '分',
    '角',
    '元',
    '拾',
    '佰',
    '仟',
    '万',
    '拾',
    '佰',
    '仟',
    '亿',
    '拾亿',
    '百亿',
    '千亿',
    '万亿'
  ];

  String temptext = '零';
  int tempid = 0;

  for (int i = numText.length - 1; i >= 0; i--) {
    String char = numText[i];
    if (char != '.') {
      if (int.parse(char) == 0) {
        if (danwei[tempid] == '元' || danwei[tempid] == '万') {
          temptext = danwei[tempid] + temptext;
        } else if (temptext[0] != '零' &&
            temptext[0] != '元' &&
            temptext[0] != '万') {
          temptext = '零' + temptext;
        }
      } else {
        temptext = numdx[int.parse(char)] + danwei[tempid] + temptext;
      }
      tempid++;
    }
  }

  temptext = temptext.substring(0, temptext.length - 1);
  if (temptext.contains('亿万')) {
    temptext = temptext.replaceAll('亿万', '亿');
  }

  return temptext;
}
