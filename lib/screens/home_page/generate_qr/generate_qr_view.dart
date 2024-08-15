import 'dart:io';

import 'package:euro_scanner/widgets/custom_track_shape.dart';
import 'package:excel_facility/excel_facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:euro_scanner/screens/home_page/home_page_logic.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/app_managers/color_manager.dart';
import '../../../widgets/arrow_clip.dart';
import 'package:pdf/pdf.dart';

class GenerateQRPage extends StatefulWidget {
  const GenerateQRPage({super.key});

  @override
  State<GenerateQRPage> createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage> {
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
            const Gap(22),
            ClipPath(
              clipper: ArrowClipReversed(8),
              child: Container(
                color: Colors.red,
                child: const Padding(
                  padding:
                      EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 20),
                  child: Text(
                    "Print Setting",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const Gap(32),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: SizedBox(
                        width: (50 + 2) * PdfPageFormat.mm,

                        // width: (76.2 + 2) * PdfPageFormat.mm,
                        height: 12,
                        child: SliderTheme(
                          data: const SliderThemeData(
                            thumbShape: CustomSliderThumbShape(),
                            trackShape: CustomSliderTrackShape(),
                            overlayShape: CustomSliderOverlayShape(),
                          ),
                          child: Slider(
                            min: 0.0,
                            // max: 76.2 - 20,
                            max: 50 - 20,
                            value: logic.xValue,
                            onChanged: (value) {
                              setState(() {
                                logic.xValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 0),
                      child: Row(
                        children: [
                          Container(
                            // height: 50 * PdfPageFormat.mm,
                            // width: 76.2 * PdfPageFormat.mm,
                            height: 60 * PdfPageFormat.mm,
                            width: 50 * PdfPageFormat.mm,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),

                              color: Colors.white,
                              // image: DecorationImage(image: AssetImage(AssetManager.paintCoupenBackground)),
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              // color: Colors.grey.shade200,
                            ),
                            child: Stack(children: [
                              Positioned(
                                left: logic.xValue * PdfPageFormat.mm,
                                top: logic.yValue * PdfPageFormat.mm,
                                child: QrImageView(
                                  data: 'test',
                                  size: logic.qrSize * PdfPageFormat.mm,
                                ),
                              ),
                              Positioned(
                                left: double.parse(
                                    logic.level1xAxisController.text.isNotEmpty
                                        ? logic.level1xAxisController.text
                                        : "0"),
                                top: double.parse(
                                    logic.level1yAxisController.text.isNotEmpty
                                        ? logic.level1yAxisController.text
                                        : "0"),
                                child: Text(
                                  "Point Coupon",
                                  style: TextStyle(
                                      fontSize: double.parse(
                                          logic.level1sizeController.text.isNotEmpty
                                              ? logic.level1sizeController.text
                                              : "11")),
                                ),
                              ),
                              Positioned(
                                left: double.parse(
                                    logic.level2xAxisController.text.isNotEmpty
                                        ? logic.level2xAxisController.text
                                        : "0"),
                                top: double.parse(
                                    logic.level2yAxisController.text.isNotEmpty
                                        ? logic.level2yAxisController.text
                                        : "0"),
                                child: Text(
                                  "500",
                                  style: TextStyle(
                                      fontSize: double.parse(
                                          logic.level2sizeController.text.isNotEmpty
                                              ? logic.level2sizeController.text
                                              : "11")),
                                ),
                              )
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: SizedBox(
                                width: (60 + 0) * PdfPageFormat.mm,
                                height: 32,
                                child: SliderTheme(
                                  data: const SliderThemeData(
                                    thumbShape: CustomSliderThumbShape(),
                                    trackShape: CustomSliderTrackShape(),
                                    overlayShape: CustomSliderOverlayShape(),
                                  ),
                                  child: Slider(
                                    min: 0.0,
                                    max: 76.2 - 20,
                                    value: logic.yValue,
                                    onChanged: (value) {
                                      setState(() {
                                        logic.yValue = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: SizedBox(
                        // width: (76.2 + 0) * PdfPageFormat.mm,
                        width: (50 + 2) * PdfPageFormat.mm,

                        height: 12,
                        child: SliderTheme(
                          data: const SliderThemeData(
                            thumbShape: CustomSliderThumbShape(),
                            trackShape: CustomSliderTrackShape(),
                            overlayShape: CustomSliderOverlayShape(),
                          ),
                          child: Slider(
                            min: 20,
                            max: 40,
                            value: logic.qrSize,
                            onChanged: (value) {
                              setState(() {
                                logic.qrSize = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],

                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            value: logic.labelEnabled,
                            onChanged: (value) {
                              value:
                              logic.labelEnabled = value!;
                              setState(() {
                                // falsevalue = value;
                              });
                            }),
                        Text("Enable Label"),
                        const Gap(12),
                        SizedBox(
                            width: 100,
                            height: 60,
                            child: _buildPassEmailFormField(
                                mainController: logic,
                                onChanged: () {
                                  setState(() {});
                                },
                                hintText: "x-Axis",
                                controller: logic.level1xAxisController)),
                        SizedBox(
                            width: 100,
                            height: 60,
                            child: _buildPassEmailFormField(
                                onChanged: () {
                                  setState(() {});
                                },
                                mainController: logic,
                                hintText: "y-Axis",
                                controller: logic.level1yAxisController)),
                        SizedBox(
                            width: 100,
                            height: 60,
                            child: _buildPassEmailFormField(
                                onChanged: () {
                                  setState(() {});
                                },
                                mainController: logic,
                                hintText: "size",
                                controller: logic.level1sizeController)),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: logic.countEnabled,
                            onChanged: (value) {
                              logic.countEnabled = value!;
                              setState(() {});
                            }),
                        const Text("Enable count"),
                        const Gap(12),
                        SizedBox(
                            width: 100,
                            height: 60,
                            child: _buildPassEmailFormField(
                                mainController: logic,
                                onChanged: () {
                                  setState(() {});
                                },
                                hintText: "x-Axis",
                                controller: logic.level2xAxisController)),
                        SizedBox(
                            width: 100,
                            height: 60,
                            child: _buildPassEmailFormField(
                                onChanged: () {
                                  setState(() {});
                                },
                                mainController: logic,
                                hintText: "y-Axis",
                                controller: logic.level2yAxisController)),
                        SizedBox(
                            width: 100,
                            height: 60,
                            child: _buildPassEmailFormField(
                                onChanged: () {
                                  setState(() {});
                                },
                                mainController: logic,
                                hintText: "size",
                                controller: logic.level2sizeController)),
                      ],
                    ),
                  ],
                )
              ],
            ),


            Visibility(
              visible: false,
              child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.green.shade700),
                  onPressed: () async {
                    // logic.chooseFile();
                    var excel = Excel.createExcel();

                    Sheet sheetObject = excel['Sheet1'];
                    CellStyle cellStyle = CellStyle();
                    cellStyle.isBold = true;
                    var cell = sheetObject.cell(CellIndex.indexByString('A1'));
                    cell.value = ('Some Text');
                    cell.value = "Parts";
                    cell.cellStyle = cellStyle;
                    // sheetObject.insertColumn(0);

                    for (var i = 2; i < 12; i++) {
                      var cells =
                          sheetObject.cell(CellIndex.indexByString('A$i'));
                      cells.value = "test";
                    }
                    var file = excel.save(fileName: 'test.xlsx');

                    var directory = await getDownloadsDirectory();
                    File(join('$directory/test2.xlsx'))
                      ..createSync(recursive: true)
                      ..writeAsBytesSync(file!);
                    // logic.printPdf();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(children: [
                      Text("test excel"),
                      // const PdfPageFormat(76.2 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
                    ]),
                  )),
            ),
            const Gap(22),
            Row(
              children: [
                FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.green.shade700),
                    onPressed: () async {
                      logic.savePrintSetting();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(children: [
                        Icon(Icons.save_outlined),
                        Gap(12),
                        Text("save print setting"),
                        // const PdfPageFormat(76.2 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
                      ]),
                    )),
                Gap(22),
                FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue.shade700),
                    onPressed: () {
                      logic.printPdf();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(children: [
                        Text("test print"),
                        // const PdfPageFormat(76.2 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
                      ]),
                    )),
              ],
            ),
            const Gap(32),
            ClipPath(
              clipper: ArrowClipReversed(8),
              child: Container(
                color: Colors.red,
                child: const Padding(
                  padding:
                      EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 20),
                  child: Text(
                    "Backup And Import/Export",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Gap(22),
            Row(
              children: [
                FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue.shade700),
                    onPressed: () async {},
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(children: [
                        Icon(Symbols.file_save),
                        Gap(12),
                        Text("Import from Excel"),
                        // const PdfPageFormat(76.2 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
                      ]),
                    )),
                const Gap(12),
                FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue.shade700),
                    onPressed: () async {
                      logic.exportDbToExcel();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(children: [
                        Icon(Symbols.upload_file),
                        Gap(12),
                        Text("Export to Excel"),
                        // const PdfPageFormat(76.2 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
                      ]),
                    )),
                const Gap(12),
                FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.green.shade700),
                    onPressed: () async {},
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(children: [
                        Icon(Symbols.database),
                        Gap(12),
                        Text("Backup Database"),
                        // const PdfPageFormat(76.2 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
                      ]),
                    )),
                const Gap(12),
                FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.red.shade700),
                    onPressed: () async {},
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(children: [
                        Icon(Symbols.database),
                        Gap(12),
                        Text("Restore Database"),
                        // const PdfPageFormat(76.2 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
                      ]),
                    )),
              ],
            ),
            Text(logic.excel ?? ""),
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
    String? hintText,
    VoidCallback? onChanged,
    required HomePageLogic mainController,
  }) {
    return TextFormField(
        inputFormatters: <TextInputFormatter>[
          // for below version 2 use this
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: controller,
        onChanged: (a) {
          onChanged!();
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: inputType ?? TextInputType.emailAddress,
        validator: (String? value) {
          return null;
        },
        maxLength: maxLength ?? 36,
        focusNode: focusNode,
        // obscureText: controller == mainController.passwordController ||controller == mainController.newPasswordController ||controller == mainController.confirmPasswordController||controller == mainController.confirmNewPasswordController,
        decoration: InputDecoration(
          fillColor: ColorManager.white,
          filled: true,
          label: Text(hintText ?? ""),
          counterText: '',
          contentPadding: const EdgeInsets.all(16),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.textDark,
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
}

// void _handelKeyDown(RawKeyEvent value) {
//   if (value is RawKeyDownEvent) {
//     final HomePageLogic logic = Get.find();
//     print(value.toString());
//     // navigator?.pop();
//   }
// }
