import 'package:euro_scanner/screens/home_page/all_qr_list/all_qr_screen.dart';
import 'package:euro_scanner/screens/home_page/dispatcher_screen/dispatcher_screen.dart';
import 'package:euro_scanner/screens/home_page/generate_qr/generate_qr_and_print_view.dart';
import 'package:euro_scanner/screens/home_page/generate_qr/generate_qr_view.dart';
import 'package:euro_scanner/screens/home_page/history_screen/history_screen.dart';
import 'package:euro_scanner/screens/home_page/home_screen/home_screen.dart';
import 'package:euro_scanner/screens/home_page/verifier_screen/verifier_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:get/get.dart';
import '../../services/side_menu/side_menu.dart' as sideMenu;
import 'home_page_logic.dart';

class HomePagePage extends StatefulWidget {
  const HomePagePage({super.key});

  @override
  State<HomePagePage> createState() => _HomePagePageState();
}

class _HomePagePageState extends State<HomePagePage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HomePageLogic logicc = Get.find();
    logicc.activeHotkeys();
    return GetBuilder<HomePageLogic>(
      assignId: true,
      builder: (logic) {
        return Scaffold(
          body: Row(
            children: [
              sideMenu.SideMenu(
                controller: logic.controller,
                hasResizer: false,
                hasResizerToggle: false,
                maxWidth: 200,
                builder: (data) => SideMenuData(
                  header: Row(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, right: 12),
                        child: GestureDetector(
                            onTap: () {
                              logic.controller.toggle.call();
                            },
                            child: Icon(logic.controller.isOpen
                                ? Icons.arrow_back_ios
                                : Icons.menu)),
                      )
                    ],
                  ),
                  items: [
                    const SideMenuItemDataDivider(divider: Divider()),
                    SideMenuItemDataTile(
                        isSelected: logic.selectedIndex == 0,
                        onTap: () {
                          logic.selectedIndex = 0;
                          // logic.refreshProjects();
                          setState(() {});
                        },
                        hasSelectedLine: false,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        title: 'Home',
                        icon: const Icon(Icons.home)),
                    SideMenuItemDataTile(
                        isSelected: logic.selectedIndex == 1,
                        onTap: () {
                          if (logic.barcodeScannerListener.isListening()) {
                            logic.barcodeScannerListener.stopListener();
                          }
                          logic.selectedIndex = 1;
                          logic.getQrData();
                          setState(() {});
                        },
                        hasSelectedLine: false,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        title: 'Dispatcher',
                        icon: const Icon(Icons.logout_outlined)),
                    SideMenuItemDataTile(
                        isSelected: logic.selectedIndex == 2,
                        onTap: () {
                          if (logic.barcodeScannerListener.isListening()) {
                            logic.barcodeScannerListener.stopListener();
                          }
                          logic.selectedIndex = 2;
                          logic.getVerifiedQrCodeData();

                          // logic.refreshCompleteProjects();
                          setState(() {});
                        },
                        hasSelectedLine: false,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        title: 'Verifier',
                        icon: const Icon(Icons.login_outlined)),
                    SideMenuItemDataTile(
                        isSelected: logic.selectedIndex == 3,
                        onTap: () {
                          if (logic.barcodeScannerListener.isListening()) {
                            logic.barcodeScannerListener.stopListener();
                          }
                          logic.selectedIndex = 3;
                          logic.getLogsDate();

                          // logic.refreshCompleteProjects();
                          setState(() {});
                        },
                        hasSelectedLine: false,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        title: 'History',
                        icon: const Icon(Icons.history)),
                    SideMenuItemDataTile(
                        isSelected: logic.selectedIndex == 4,
                        onTap: () {
                          if (logic.barcodeScannerListener.isListening()) {
                            logic.barcodeScannerListener.stopListener();
                          }
                          logic.selectedIndex = 4;
                          logic.getAllQrList();
                          // logic.refreshCompleteProjects();
                          setState(() {});
                        },
                        hasSelectedLine: false,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        title: 'QR List',
                        icon: const Icon(Icons.qr_code)),
                    SideMenuItemDataTile(
                        isSelected: logic.selectedIndex == 5,
                        onTap: () {
                          logic.selectedIndex = 5;
                          // logic.refreshCompleteProjects();
                          setState(() {});
                        },
                        hasSelectedLine: false,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(12)),
                        title: 'Generate QR',
                        icon: const Icon(Icons.qr_code_2)),

                    SideMenuItemDataTile(
                        isSelected: logic.selectedIndex == 6,
                        onTap: () {
                          logic.selectedIndex = 6;
                          // logic.refreshCompleteProjects();
                          setState(() {});
                        },
                        hasSelectedLine: false,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        title: 'Help And Setting',
                        icon: const Icon(Icons.help_outline))
                  ],
                ),
              ),
              Expanded(
                child: logic.selectedIndex == 0
                    ? const HomeScreenPage()
                    : logic.selectedIndex == 1
                        ? const DispatcherPage()
                        : logic.selectedIndex == 2
                            ? const VerifierPage()
                            : logic.selectedIndex == 3
                                ? const HistoryPage()
                                : logic.selectedIndex == 4
                                    ? const QrListPage()
                                    : logic.selectedIndex == 5
                                        ? const GenerateQRAndPrintPage()
                                        : GenerateQRPage(),
              )
              // Your app screen body
            ],
          ),
        );
      },
    );
  }
}
