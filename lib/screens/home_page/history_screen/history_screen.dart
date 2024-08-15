import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:euro_scanner/screens/home_page/home_page_logic.dart';
import '../../../core/app_managers/color_manager.dart';
import '../../../services/custom_pager.dart';
import '../../../services/nav_helper.dart';
import '../../../widgets/arrow_clip.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
    PaginatorController? controller;
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
                    "History / Logs",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: Row(
                children: [
                  const Spacer(),
                  SizedBox(
                      width: 300,
                      child: _buildPassEmailFormField(
                          mainController: HomePageLogic())),
                ],
              ),
            ),
            logic.isLogsLoaded
                ? Expanded(
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: PaginatedDataTable2(
                  // 100 Won't be shown since it is smaller than total records
                    availableRowsPerPage: const [5, 10, 15],
                    horizontalMargin: 20,
                    columnSpacing: 22,
                    wrapInCard: true,
                    renderEmptyRowsInTheEnd: false,
                    headingRowColor: WidgetStateColor.resolveWith(
                            (states) => Colors.grey[200]!),
                    rowsPerPage: rowsPerPage,
                    autoRowsToHeight:
                    getCurrentRouteOption(context) == autoRows,
                    minWidth: 100,
                    fit: FlexFit.tight,
                    border: TableBorder(
                        top: BorderSide(color: Colors.grey[300]!),
                        bottom: BorderSide(color: Colors.grey[300]!),
                        left: BorderSide(color: Colors.grey[300]!),
                        right: BorderSide(color: Colors.grey[300]!),
                        verticalInside:
                        BorderSide(color: Colors.grey[300]!),
                        horizontalInside: const BorderSide(
                            color: Colors.grey, width: 1)),
                    onRowsPerPageChanged: (value) {
                      // No need to wrap into setState, it will be called inside the widget
                      // and trigger rebuild
                      //setState(() {
                      rowsPerPage = value!;
                      print(rowsPerPage);
                      //});
                    },
                    initialFirstRowIndex: 0,
                    onPageChanged: (rowIndex) {
                      print(rowIndex / rowsPerPage);
                    },
                    sortColumnIndex: logic.sortColumnIndex,
                    sortAscending: logic.sortAscending,
                    sortArrowAlwaysVisible: true,
                    sortArrowIcon: Icons.keyboard_arrow_up,
                    // custom arrow
                    sortArrowAnimationDuration:
                    const Duration(milliseconds: 0),
                    // custom animation duration
                    controller:
                    getCurrentRouteOption(context) == custPager
                        ? controller
                        : null,
                    hidePaginator:
                    getCurrentRouteOption(context) == custPager,
                    columns: [
                      DataColumn2(
                        onSort: (columnIndex, ascending) =>
                            logic.sortLog<num>(
                                    (d) => d.id!, columnIndex, ascending),
                        size: ColumnSize.S,
                        fixedWidth: 60,
                        label: const Text(
                          "id",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      DataColumn2(
                        onSort: (columnIndex, ascending) =>
                            logic.sortLog<String>(
                                    (d) => d.qrCode, columnIndex, ascending),
                        size: ColumnSize.L,
                        label: const Text(
                          "Qr Code",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      DataColumn2(
                        onSort: (columnIndex, ascending) =>
                            logic.sortLog<String>(
                                    (d) => d.scanDateTime, columnIndex, ascending),
                        size: ColumnSize.S,
                        label: const Text(
                          "Date",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      DataColumn2(
                        onSort: (columnIndex, ascending) =>
                            logic.sortLog<String>(
                                    (d) => d.status, columnIndex, ascending),
                        size: ColumnSize.S,
                        label: const Text(
                          "Status",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      DataColumn2(
                        onSort: (columnIndex, ascending) =>
                            logic.sortLog<String>(
                                    (d) => d.remarks, columnIndex, ascending),
                        size: ColumnSize.L,
                        label: const Text(
                          "Remarks",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      DataColumn2(
                        onSort: (columnIndex, ascending) =>
                            logic.sortLog<String>(
                                    (d) => d.scanBy, columnIndex, ascending),
                        size: ColumnSize.S,
                        label: const Text(
                          "Scan By",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      DataColumn2(
                        onSort: (columnIndex, ascending) =>
                            logic.sortLog<String>(
                                    (d) => d.scanFor, columnIndex, ascending),
                        size: ColumnSize.S,
                        label: const Text(
                          "Scan for",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      // DataColumn2(
                      //   onSort: (columnIndex, ascending) =>
                      //       logic.sort<String>(
                      //               (d) => d.qrCode, columnIndex, ascending),
                      //   size: ColumnSize.M,
                      //   label: const Text(
                      //     "Last Scan Date",
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.w600, fontSize: 14),
                      //   ),
                      // ),
                    ],
                    empty: Center(
                        child: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.grey[200],
                            child: const Text('No data'))),
                    source: logic.logsRowSource),
              ),
            )
                : const Center(
              child: Text("loading Data.."),
            ),
            if (getCurrentRouteOption(context) == custPager)
              Positioned(bottom: 16, child: CustomPager(controller!))
          ],
        );
      },
    );
  }

  Widget _buildPassEmailFormField({
    TextEditingController? controller,
    TextInputType? inputType,
    FocusNode? focusNode,
    int? maxLength,
    int? minLines,
    int? maxLines,
    String? hintText,
    VoidCallback? onChanged,
    required HomePageLogic mainController,
  }) {
    return TextFormField(
        minLines: minLines ?? 1,
        maxLines: maxLines ?? 1,
        controller: controller,
        onChanged: (a) {
          onChanged!();
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: inputType ?? TextInputType.emailAddress,
        validator: (String? value) {
          // if (controller == mainController.productTitleController) {
          //   return InputValidators.simpleValidation(value);
          // }
          return null;
        },
        style: const TextStyle(color: Colors.black),
        maxLength: maxLength ?? 36,
        focusNode: focusNode,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Padding(
            padding:
            const EdgeInsets.only(left: 1, right: 6, bottom: 1, top: 1),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  color: Colors.grey.shade200),
              width: 48,
              height: 48,
              child: const Icon(Icons.search_rounded),
            ),
          ),
          fillColor: ColorManager.white,
          filled: true,
          counterText: '',
          contentPadding: const EdgeInsets.all(16),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(10)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.errorOpacity50,
              ),
              borderRadius: BorderRadius.circular(10)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.errorOpacity50,
              ),
              borderRadius: BorderRadius.circular(10)),
          hintText: hintText ?? "",
          hintStyle: TextStyle(
            color: ColorManager.hintColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        onFieldSubmitted: (String val) {});
  }

// void _handelKeyDown(RawKeyEvent value) {
//   if (value is RawKeyDownEvent) {
//     final HomePageLogic logic = Get.find();
//     print(value.toString());
//     // navigator?.pop();
//   }
}