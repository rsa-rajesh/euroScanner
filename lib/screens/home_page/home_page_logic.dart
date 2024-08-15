import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:excel_facility/excel_facility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotkey_system/hotkey_system.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:euro_scanner/services/side_menu/side_menu_controller.dart';
import 'package:window_manager/window_manager.dart';
import '../../models/dbModels/projects.dart';
import '../../services/barcode_scanner_listener.dart';
import '../../services/excel_to_json.dart';
import '../../services/logss_data_row.dart';
import '../../services/qr_codes_data_row.dart';
import '../../services/sqlite_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HomePageLogic extends GetxController {
  var searchFieldController = TextEditingController();
  late SqliteService _sqliteService;
  DateTime timerTime = DateTime.now();
  int selectedIndex = 0;
  final storage = GetStorage();
  var isQuitDialogueOpen = false;
  RxBool startAnimation = false.obs;
  final listKey = GlobalKey<AnimatedListState>();
  var controller = SideMenuController();
  String defaultHotKeyQuitApp =
      "{\"keyCode\": \"keyA\",\"modifiers\": [\"meta\"],\"identifier\":\"quit-hot-key\",\"scope\": \"inapp\"}";
  String defaultHotKeyMinMax =
      "{\"keyCode\": \"keyQ\",\"modifiers\": [\"control\"],\"identifier\":\"min-max-hot-key\",\"scope\": \"system\"}";
  String scanningMode = "dispatch";
  late BarcodeScannerListener barcodeScannerListener;

  List<QrCodes> qrCodes = [];
  List<QrCodes> verifiedQrCodes = [];
  List<Logs> logs = [];
  double xValue = 0;
  double yValue = 0;
  double qrSize = 20;
  bool labelEnabled = false;
  bool countEnabled = false;
  List<String> validQr = [];
  List<String> invalidQr = [];

  // bool sort = true;
  // List<QrCodes>? filterData;
  late var qrCodesRowSource;
  late var qrCodesRowSourceVerified;
  late var logsRowSource;

  bool isDispatchDataLoaded = false;
  bool isQrListLoaded = false;
  bool isVerifiedDataLoaded = false;
  bool isLogsLoaded = false;
  bool sortAscending = true;
  int? sortColumnIndex;

  final TextEditingController level2xAxisController = TextEditingController();
  final TextEditingController level2yAxisController = TextEditingController();
  final TextEditingController level2sizeController = TextEditingController();
  final TextEditingController level1xAxisController = TextEditingController();
  final TextEditingController level1yAxisController = TextEditingController();
  final TextEditingController level1sizeController = TextEditingController();

  late SingleValueDropDownController typeController =
      SingleValueDropDownController();
  late SingleValueDropDownController qtyController =
      SingleValueDropDownController();

  final TextEditingController couponValueController = TextEditingController();
  final TextEditingController productCodeController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  List<DropDownValueModel> types = [
    const DropDownValueModel(name: 'Cash Coupon', value: "CC"),
    const DropDownValueModel(name: 'Point Coupon', value: "PC"),
  ];

  List<DropDownValueModel> qty = [
    const DropDownValueModel(name: '1 liter', value: "1L"),
    const DropDownValueModel(name: '4 liter', value: "4L"),
    const DropDownValueModel(name: '10 liter', value: "10L"),
    const DropDownValueModel(name: '20 liter', value: "20L"),
  ];

  @override
  void onInit() {
    _sqliteService = SqliteService();
    _sqliteService.initializeDB().whenComplete(() async {
      String path = await getDatabasesPath();
      print(path);
    });

    barcodeScannerListener = BarcodeScannerListener(
        bufferDuration: const Duration(milliseconds: 200),
        onBarcodeScanned: (result) {
          print(result.toString().trim());
          if (result.trim().isNotEmpty) {
            insertData(result);
          }
        },
        useKeyDownEvent: true,
        caseSensitive: true);
    update();

    super.onInit();
  }

  void sort<T>(
    Comparable<T> Function(QrCodes d) getField,
    int columnIndex,
    bool ascending,
  ) {
    if (selectedIndex == 1 || selectedIndex == 4) {
      qrCodesRowSource.sort<T>(getField, ascending);
    } else if (selectedIndex == 2) {
      qrCodesRowSourceVerified.sort<T>(getField, ascending);
    }
    // else if(selectedIndex==4){
    //   qrCodeListsRowSource.sort<T>(getField, ascending);
    // }
    sortColumnIndex = columnIndex;
    sortAscending = ascending;
    update();
  }

  void sortLog<T>(
    Comparable<T> Function(Logs d) getField,
    int columnIndex,
    bool ascending,
  ) {
    logsRowSource.sort<T>(getField, ascending);
    sortColumnIndex = columnIndex;
    sortAscending = ascending;
    update();
  }

  Future<void> insertData(String value) async {
    if (scanningMode == "dispatch") {
      int result = 0;
      var dateTime = DateTime.now();
      result = await _sqliteService.createQrCode(QrCodes(
          qrCode: value.trim(),
          status: scanningMode,
          lastScanDate: dateTime.toString(),
          lastScanBy: "-",
          lastVerifiedDealer: "-",
          lastBatch: 1,
          dispatchedCount: 1,
          verifiedCount: 0,
          scanCount: 1,
          totalCash: 0,
          isDeleted: 0,
          totalPoints: 0));
      print("Enter pressed: $value");

      getQrData();
      // getVerifiedQrCodeData();
      update();
    } else {
      int result = 0;
      var dateTime = DateTime.now();
      result = await _sqliteService.verifyQrCode(QrCodes(
          qrCode: value.trim(),
          status: scanningMode,
          lastScanDate: dateTime.toString(),
          lastScanBy: "-",
          lastVerifiedDealer: "-",
          lastBatch: 1,
          dispatchedCount: 0,
          verifiedCount: 1,
          scanCount: 1,
          totalCash: 0,
          isDeleted: 0,
          totalPoints: 0));
      print("Enter pressed: $value");

      // getQrData();
      getVerifiedQrCodeData();
      update();
    }
  }

  Future<void> getQrData() async {
    var dateTime = DateTime.now();
    final data = await _sqliteService.getQrCodeData(dateTime.toString());

    // print("Enter pressed: $value");
    qrCodes = data;
    isDispatchDataLoaded = true;
    qrCodesRowSource = QrCodesRowSource(
      myData: qrCodes,
      count: qrCodes.length,
    );
    update();
  }

  Future<void> getVerifiedQrCodeData() async {
    var dateTime = DateTime.now();
    final data =
        await _sqliteService.getVerifiedQrCodeData(dateTime.toString());

    // print("Enter pressed: $value");
    verifiedQrCodes = data;
    isVerifiedDataLoaded = true;
    qrCodesRowSourceVerified = QrCodesRowSource(
      myData: verifiedQrCodes,
      count: verifiedQrCodes.length,
    );
    update();
  }

  getMinMaxKey() {
    try {
      return HotKey.fromJson(jsonDecode(storage.read("min_max_key")));
    } catch (e) {
      return HotKey.fromJson(jsonDecode(defaultHotKeyMinMax.toString()));
    }
  }

  void saveMinMaxKey(String jsonEncode) {
    storage.write("min_max_key", jsonEncode);
    activeHotkeys();
  }

  void saveQuitKey(String jsonEncode) {
    storage.write("quit_key", jsonEncode);
    activeHotkeys();
  }

  HotKey getQuitKey() {
    try {
      return HotKey.fromJson(jsonDecode(storage.read("quit_key")));
    } catch (e) {
      return HotKey.fromJson(jsonDecode(defaultHotKeyQuitApp.toString()));
    }
  }

  void activeHotkeys() {
    HotKey _hotKeyMinMax = getMinMaxKey();
    HotKey _hotKeyQuit = getQuitKey();

    hotKeySystem.register(
      _hotKeyMinMax,
      keyDownHandler: (hotKey) async {
        if (kDebugMode) {
          print('minMax onKeyDown+${hotKey.toJson()}');
        }
        if (await windowManager.isMinimized()) {
          windowManager.show();
        } else {
          windowManager.minimize();
        }
      },
      // Only works on macOS.
      keyUpHandler: (hotKey) {
        if (kDebugMode) {
          print('onKeyUp+${hotKey.toJson()}');
        }
      },
    );

    hotKeySystem.register(
      _hotKeyQuit,
      keyDownHandler: (hotKey) async {
        if (kDebugMode) {
          print('exit onKeyDown+${hotKey.toJson()}');
        }
        _showQuitConfirmationDialog(Get.context!);
      },
      // Only works on macOS.
      keyUpHandler: (hotKey) {
        if (kDebugMode) {
          print('onKeyUp+${hotKey.toJson()}');
        }
      },
    );
  }

  void _showQuitConfirmationDialog(
    BuildContext context,
  ) {
    isQuitDialogueOpen = true;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quit App'),
          content: const Text('Are you sure you want to quit the app?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Quit'),
            ),
          ],
        );
      },
    ).then((_) => isQuitDialogueOpen = false);
  }

  Future<void> getLogsDate() async {
    var dateTime = DateTime.now();
    final data = await _sqliteService.getLogsDate(dateTime.toString());

    // print("Enter pressed: $value");
    logs = data;
    isLogsLoaded = true;
    logsRowSource = LogsRowSource(
      myData: logs,
      count: logs.length,
    );
    update();
  }

  Future<void> createPdf(pw.Document doc) async {
    // var a = QrImageView(data: data) ;
    // final image = await decodeImageFromList(await toQrImageData("rajesh dai"));

    final image = await pw.MemoryImage(await toQrImageData("rajesh dai"));

    doc.addPage(pw.Page(
        // pageFormat:
        // const PdfPageFormat(76.2 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
        pageFormat:
            const PdfPageFormat(50 * PdfPageFormat.mm, 60 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return pw.Stack(children: [
          //   pw.Positioned(
          //     left: level1xAxisController.text.isNotEmpty
          //         ? double.parse(level1xAxisController.text)
          //         : 0,
          //     top: level1yAxisController.text.isNotEmpty
          //         ? double.parse(level1yAxisController.text)
          //         : 0,
          //     // left: 24 * PdfPageFormat.mm,
          //     // top: 24 * PdfPageFormat.mm,
          //     child: pw.Text('Point Coupon',
          //         style: pw.TextStyle(
          //             fontSize: level1sizeController.text.isNotEmpty
          //                 ? double.parse(level1sizeController.text)
          //                 : 11)),
          //   ),
          //   pw.Positioned(
          //     left: level2xAxisController.text.isNotEmpty
          //         ? double.parse(level2xAxisController.text)
          //         : 0,
          //     top: level2yAxisController.text.isNotEmpty
          //         ? double.parse(level2yAxisController.text)
          //         : 0,
          //     child: pw.Text('500',
          //         style: pw.TextStyle(
          //             fontSize: level2sizeController.text.isNotEmpty
          //                 ? double.parse(level2sizeController.text)
          //                 : 11)),
          //   ),
            // pw.Positioned(
            //   left: (xValue * PdfPageFormat.mm) + 10,
            //   top: (yValue * PdfPageFormat.mm) + 10,
            //   child: pw.Image(image,
            //       height: (qrSize * PdfPageFormat.mm) - 20,
            //       width: (qrSize * PdfPageFormat.mm) - 20),
            // ),

            pw.Positioned(
              left: (xValue * PdfPageFormat.mm) + 10,
              top: (yValue * PdfPageFormat.mm) + 10,
              child: pw.Image(image,
                  height: (qrSize * PdfPageFormat.mm) - 20,
                  width: (qrSize * PdfPageFormat.mm) - 20),
            )
          ]);
        })); // Page// Page

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/sample-rajesh.pdf');
    await file.writeAsBytes(await doc.save());
  }

  Future<void> printPdf() async {
    final doc = pw.Document();
    await createPdf(doc);
    await Printing.layoutPdf(
      outputType: OutputType.photo,
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  Future<void> getAllQrList() async {
    var dateTime = DateTime.now();
    final data = await _sqliteService.getAllQrCodeData(dateTime.toString());

    // print("Enter pressed: $value");
    qrCodes = data;
    isQrListLoaded = true;
    qrCodesRowSource = QrCodesRowSource(
      myData: qrCodes,
      count: qrCodes.length,
    );
    update();
  }

  Future<Uint8List> toQrImageData(String text) async {
    try {
      final image = await QrPainter(
        data: text,
        version: QrVersions.auto,
        gapless: false,
      ).toImage(300);
      final a = await image.toByteData(format: ImageByteFormat.png);
      return a!.buffer.asUint8List();
    } catch (e) {
      throw e;
    }
  }

  String? excel;

  Future<void> chooseFile() async {
    excel = await ExcelToJson().convert();
    update();
  }

  void savePrintSetting() {
    storage.write("printSetting_qrXaxis", xValue);
    storage.write("printSetting_qrYaxis", yValue);
    storage.write("printSetting_qrSize", qrSize);
    storage.write(
        "printSetting_lavel1Xaxis",
        level1xAxisController.text.isNotEmpty
            ? double.parse(level1xAxisController.text)
            : 0);
    storage.write(
        "printSetting_lavel1Yaxis",
        level1yAxisController.text.isNotEmpty
            ? double.parse(level1yAxisController.text)
            : 0);
    storage.write(
        "printSetting_lavel1FontSize",
        level1sizeController.text.isNotEmpty
            ? double.parse(level1sizeController.text)
            : 11);
    storage.write(
        "printSetting_lavel2Xaxis",
        level2xAxisController.text.isNotEmpty
            ? double.parse(level2xAxisController.text)
            : 0);
    storage.write(
        "printSetting_lavel2Yaxis",
        level2yAxisController.text.isNotEmpty
            ? double.parse(level2yAxisController.text)
            : 0);
    storage.write(
        "printSetting_lavel2FontSize",
        level2sizeController.text.isNotEmpty
            ? double.parse(level2sizeController.text)
            : 11);
  }

  Future<void> generateTempQr() async {
    NepaliDateTime currentTime = NepaliDateTime.now();
    int year = currentTime.year;
    int month = currentTime.month;
    int day = currentTime.day;
    int from =
        fromController.text.isNotEmpty ? int.parse(fromController.text) : 1;
    int to = toController.text.isNotEmpty ? int.parse(toController.text) : 10;
    validQr.clear();
    invalidQr.clear();

    for (int i = from; i <= to; i++) {
      String qr =
          "${year.toString().substring(1, 4)}${month.toString().padLeft(2, '0')}${day.toString().padLeft(2, '0')}-${typeController.dropDownValue?.value}${couponValueController.text}-${productCodeController.text}${qtyController.dropDownValue?.value}$i";

      bool addable = await _sqliteService.isAddable(qr);
      addable ? validQr.add(qr) : invalidQr.add(qr);
    }

    print(validQr.toString());
    print(invalidQr.toString());
    update();
  }

  void saveAndPrintGeneratedQr() {
    printPdfV2();
  }

  Future<void> createPdfV2(pw.Document doc) async {
    double xValue = storage.read("printSetting_qrXaxis") ?? 40;
    double yValue = storage.read("printSetting_qrYaxis") ?? 20;
    double qrSize = storage.read("printSetting_qrSize") ?? 30;
    double lavel1Xaxis = storage.read("printSetting_lavel1Xaxis") ?? 10;
    double lavel1Yaxis = storage.read("printSetting_lavel1Yaxis") ?? 30;
    double lavel1FontSize = storage.read("printSetting_lavel1FontSize") ?? 14;
    double lavel2Xaxis = storage.read("printSetting_lavel2Xaxis") ?? 30;
    double lavel2Yaxis = storage.read("printSetting_lavel2Yaxis") ?? 50;
    double lavel2FontSize = storage.read("printSetting_lavel2FontSize") ?? 32;

    for (var a in validQr) {
      final image = await pw.MemoryImage(await toQrImageData(a));
      doc.addPage(pw.Page(
        pageFormat: const PdfPageFormat(
            60 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
          // pageFormat: const PdfPageFormat(76.2 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
          build: (pw.Context context) {
            return pw.Stack(children: [
              pw.Positioned(
                left: lavel1Xaxis.toDouble(),
                top: lavel1Yaxis.toDouble(),
                child: pw.Text(
                    validQr[0].split("-")[1].toLowerCase().contains("cc")
                        ? "Cash Coupon"
                        : "Point Coupon",
                    style: pw.TextStyle(fontSize: lavel1FontSize.toDouble())),
              ),
              pw.Positioned(
                left: lavel2Xaxis.toDouble(),
                top: lavel2Yaxis.toDouble(),
                child: pw.Text(
                    validQr[0].split("-")[1].replaceAll(RegExp(r'[^0-9]'), ''),
                    style: pw.TextStyle(fontSize: lavel2FontSize.toDouble())),
              ),
              pw.Positioned(
                left: (xValue * PdfPageFormat.mm) + 10,
                top: (yValue * PdfPageFormat.mm) + 10,
                child: pw.Image(image,
                    height: (qrSize * PdfPageFormat.mm) - 20,
                    width: (qrSize * PdfPageFormat.mm) - 20),
              ),
            ]);
          }));
    }

    NepaliDateTime nepaliDateTime = NepaliDateTime.now();

    final output = await getTemporaryDirectory();
    final file =
        File('${output.path}/${nepaliDateTime.toString().split(".")[0]}.pdf');
    try {
      await file.writeAsBytes(await doc.save());
    } catch (e) {
      print(e);
    }
  }

  Future<void> printPdfV2() async {
    final doc = pw.Document();

    await createPdfV2(doc);
    var printers = Printing.listPrinters();
    bool a = await Printing.layoutPdf(
        format:
            const PdfPageFormat(76.2 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  Future<void> exportDbToExcel() async {
    var excel = Excel.createExcel();

    Sheet sheetObject = excel['Sheet1'];
    CellStyle cellStyle = CellStyle();
    cellStyle.isBold = true;
    var cell = sheetObject.cell(CellIndex.indexByString('A1'));
    // cell.value = ('Some Text');
    cell.value = "Parts";
    cell.cellStyle = cellStyle;
    // sheetObject.insertColumn(0);

    for (var i = 2; i < 12; i++) {
      var cells = sheetObject.cell(CellIndex.indexByString('A$i'));
      cells.value = "test";
    }
    var file = excel.save(fileName: 'test.xlsx');

    var directory = await getDownloadsDirectory();
    File(join('$directory/test2.xlsx'))
      ..createSync(recursive: true)
      ..writeAsBytesSync(file!);
  }
}
