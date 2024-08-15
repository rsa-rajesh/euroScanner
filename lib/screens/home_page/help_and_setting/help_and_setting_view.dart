import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hotkey_system/hotkey_system.dart';
import 'package:euro_scanner/core/helper/app_dialogs.dart';
import 'package:euro_scanner/screens/home_page/home_page_logic.dart';
import '../../../widgets/arrow_clip.dart';

class HelpAndSettingPage extends StatefulWidget {
  const HelpAndSettingPage({super.key});

  @override
  State<HelpAndSettingPage> createState() => _HelpAndSettingPageState();
}

class _HelpAndSettingPageState extends State<HelpAndSettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageLogic>(
      builder: (logic) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(32),
            ClipPath(
              clipper: ArrowClipReversed(8),
              child: Container(
                color: Colors.red,
                child: const Padding(
                  padding:
                      EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 20),
                  child: Text(
                    "Hotkey Setting",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("HotKey to quit app"),
                  Container(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                showHotKeyDialog(context,
                                    type: 1,
                                    hotKey: logic.getQuitKey(),
                                    title: "Change Hotkey to Quit App",
                                    onSaved: (hotKey) {
                                  var a = hotKey.toJson();
                                  print(a.toString());
                                  logic.saveQuitKey(jsonEncode(a));
                                  setState(() {});
                                  return null;
                                }, onChanged: () {
                                  setState(() {});
                                });
                              },
                              child: HotKeyVirtualView(
                                hotKey: logic.getQuitKey(),
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                              onTap: () async {},
                              child: Text(
                                "Default",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.green[900]),
                              )),
                        ],
                      ),
                    ),
                  ),
                  const Gap(12),
                  const Text("HotKey to minimize And Maximize App"),
                  Container(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showHotKeyDialog(context,
                                  hotKey: logic.getMinMaxKey(),
                                  type: 2,
                                  title:
                                      "Change Hotkey to minimize And Maximize App",
                                  onSaved: (hotKey) {
                                var a = hotKey.toJson();
                                print(a.toString());
                                logic.saveMinMaxKey(jsonEncode(a));
                                setState(() {});
                                return null;
                              }, onChanged: () {
                                setState(() {});
                              });
                            },
                            child:
                                HotKeyVirtualView(hotKey: logic.getMinMaxKey()),
                          ),
                          const Spacer(),
                          GestureDetector(
                              onTap: () async {},
                              child: Text(
                                "Default",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.green[900]),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(22),
            ClipPath(
              clipper: ArrowClipReversed(8),
              child: Container(
                color: Colors.red,
                child: const Padding(
                  padding:
                      EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 20),
                  child: Text(
                    "Help",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Linux Requirement for Hot key"),
                  Row(
                    children: [
                      const Gap(42),
                      const Text(
                        "•",
                        style: TextStyle(fontSize: 32),
                      ),
                      const Gap(12),
                      Container(
                          color: Colors.grey[100],
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text("keybinder-3.0"),
                          )),
                    ],
                  ),
                  const Text("Run the following command"),
                  Container(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          const Text("sudo apt-get install keybinder-3.0"),
                          const Spacer(),
                          GestureDetector(
                              onTap: () async {
                                await Clipboard.setData(const ClipboardData(
                                    text:
                                        "sudo apt-get install keybinder-3.0"));
                              },
                              child: Text(
                                "Copy",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.green[900]),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// void _handelKeyDown(RawKeyEvent value) {
//   if (value is RawKeyDownEvent) {
//     final HomePageLogic logic = Get.find();
//     print(value.toString());
//     // navigator?.pop();
//   }
// }
