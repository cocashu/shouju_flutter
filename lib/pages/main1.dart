import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hy_shouju/main.dart';
import 'package:hy_shouju/pages/settings.dart';
import 'package:hy_shouju/pages/zhifu_page.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:hy_shouju/pages/shouju_list.dart';
import 'package:hy_shouju/pages/user_page.dart';
import 'package:get/get.dart';
import 'package:hy_shouju/pages/leixing_page.dart';
import 'package:hy_shouju/pages/shouju.dart';
import 'package:hy_shouju/pages/shujubak.dart';
import 'package:hy_shouju/pages/baobiao.dart';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final Controller c = Get.put(Controller());
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  final titlestr = ''.obs;
  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  Future<void> exitApp() async {
    // 强制退出应用程序
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    exit(0);
  }

  @override
  Widget build(context) {
    titlestr.value = "鸿宇集团【 ${c.gsname}】收费专用---开具收据";

    return Scaffold(
      appBar: AppBar(title: Obx(() => Center(child: Text(titlestr.value)))),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              // showTooltip: false,
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: Colors.blue[100],
              selectedHoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(10)),
              // ),
              // backgroundColor: Colors.blueGrey[700]
            ),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    // maxHeight: 150,
                    maxWidth: 200,
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            footer: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: Text(
                    'CocaShu',
                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                  ),
                ),
              ),
            ),
            items: [
              SideMenuItem(
                title: '主页',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsname}】收费专用---开具收据";
                  // Get.to(shouju_page());
                },
                icon: const Icon(Icons.home),
                tooltipContent: "This is a tooltip for Dashboard item",
              ),
              SideMenuItem(
                title: '收据开具',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsname}】收费专用---开具收据";
                  // Get.to(shouju_page());
                },
                icon: const Icon(Icons.home),
                tooltipContent: "This is a tooltip for Dashboard item",
              ),
              SideMenuItem(
                title: '收据列表',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsname}】收费专用---收据列表";
                },
                icon: const Icon(Icons.list),
                tooltipContent: "This is a tooltip for Dashboard item",
              ),
              SideMenuItem(
                title: '收据报表',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsname}】收费专用---收据报表";
                },
                icon: const Icon(Icons.download),
              ),
              SideMenuItem(
                builder: (context, displayMode) {
                  return const Divider(
                    endIndent: 8,
                    indent: 8,
                  );
                },
              ),
              SideMenuItem(
                title: '用户管理',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsname}】收费专用---用户管理";
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                title: '缴费类型管理',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsname}】收费专用---缴费类型管理";
                  // Get.to(TypeManagementPage());
                },
                icon: const Icon(Icons.settings),
              ),
              SideMenuItem(
                title: '支付方式管理',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsname}】收费专用--支付方式管理";
                  // Get.to(zffs_TypeManagementPage());
                },
                icon: const Icon(Icons.settings),
              ),
              SideMenuItem(
                title: '软件设置',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsname}】收费专用--软件设置";
                },
                icon: const Icon(Icons.settings),
              ),
              SideMenuItem(
                title: '数据备份',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  titlestr.value = "鸿宇集团【 ${c.gsname}】收费专用---数据备份";
                },
                icon: const Icon(Icons.file_copy_rounded),
                trailing: Container(
                    decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 3),
                      child: Text(
                        'Bak',
                        style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                      ),
                    )),
              ),
              SideMenuItem(
                title: '退出',
                onTap: (index, _) {
                  // 退出应用程序
                  exitApp();
                },
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      c.gsname.toString(),
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Container(color: Colors.white, child: const shouju_page()),
                Container(color: Colors.white, child: InvoicePage()),
                Container(
                  color: Colors.white,
                  child: const MyAppbiaobiaoPage(),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      '--',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const user_TypeManagementPage(),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: TypeManagementPage(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: zffs_TypeManagementPage(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Center(child: MarginSettingsPage()),
                ),
                Container(
                  color: Colors.white,
                  child: MybakHomePage(),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'exit',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
