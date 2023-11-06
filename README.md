# 收据for flutter

一个使用flutter重写的收据软件

## 已完成
收据列表（待完成：按类型+做分页）

收据打印

收据分享

收据登录

收据增加

收据保存

支付方式管理（需要判断不重复）

缴费类型管理（需要判断不重复）

用户管理（已判断不重复）


## 待完成

报表分析

原软件的数据导入（python测试完成）

### 数据删除逻辑(待处理)
#### 用户部分

1.删除用户需要填写原始密码，正确后删除

2.修改用户密码判断原始密码，正确后修改

#### 支付方式/缴费类型

1.修改和删除需要判断缴费明细中是否存在该类型的收据，如果没有可以删除（无需判断是否管理员）



## 引用包
```
dependencies:
  flutter:
    sdk: flutter
#本地化
  flutter_localizations:
    sdk: flutter  
  cupertino_icons: ^1.0.2
  intl: ^0.18.1
  dropdown_textfield: ^1.0.8
  printing: ^5.11.0
  get: ^4.6.6
  sqflite_common_ffi: ^2.3.0+2
  path: ^1.8.3
  easy_sidemenu: ^0.5.0
  crypto: ^3.0.3
  encrypt: ^5.0.1
  pdf: ^3.10.4
  path_provider: ^2.1.1
  file_picker: ^6.0.0
```
by:2023-10-24
