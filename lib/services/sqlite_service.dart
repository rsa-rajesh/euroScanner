import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/dbModels/projects.dart';

class SqliteService {
  Future<Database> initializeDB() async {
    // String path = await getDatabasesPath();

    var a = await getApplicationDocumentsDirectory();
    String path = a.path;

    return openDatabase(
      join(path, 'euro_scanner_db' 'euro_scanner.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE QrCodes(id INTEGER PRIMARY KEY AUTOINCREMENT,qr_code TEXT NOT NULL,status TEXT NOT NULL,last_scan_date TEXT NOT NULL,last_scan_by TEXT,last_verified_dealer TEXT,last_batch INTEGER NOT NULL,dispatched_count INTEGER NOT NULL,verified_count INTEGER NOT NULL,scan_count INTEGER NOT NULL,total_points FLOAT NOT NULL,total_cash FLOAT NOT NULL,is_deleted INTEGER DEFAULT 0)",
        );
        await database.execute(
          "CREATE TABLE Logs(id INTEGER PRIMARY KEY AUTOINCREMENT,qr_code TEXT NOT NULL,scan_date_time TEXT ,status TEXT ,remarks TEXT ,scan_by TEXT ,scan_for_dealer TEXT NOT NULL,batch_no INTEGER NOT NULL)",
        );
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        // await database.execute(
        //   "CREATE TABLE Projects(id INTEGER PRIMARY KEY AUTOINCREMENT,project_name TEXT NOT NULL)",
        // );
      },
      version: 1,
    );
  }

  Future<int> createQrCode(QrCodes qrCodes) async {
    int result = 0;
    final Database db = await initializeDB();
    try {
      final List<Map<String, Object?>> queryResult = await db.query('QrCodes',
          orderBy: 'id Desc',
          where: 'qr_code is ?',
          whereArgs: [qrCodes.qrCode]);
      var a = queryResult.map((e) => QrCodes.fromMap(e)).toList();
      int id = 0;
      String status = "error";
      if (a.isEmpty) {
        id = await db.insert('QrCodes', qrCodes.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
        status = "success";
      } else {
        if (a[0].status != "dispatch") {
          qrCodes.lastBatch = 2;
          qrCodes.totalPoints = a[0].totalPoints;
          qrCodes.totalCash = a[0].totalCash;
          qrCodes.verifiedCount = a[0].verifiedCount;
          qrCodes.dispatchedCount = a[0].dispatchedCount + 1;
          qrCodes.scanCount = a[0].scanCount + 1;
          await db.update('QrCodes', qrCodes.toMap(),
              where: "id is ?", whereArgs: [a[0].id]);
          status = "success";
        } else {
          status = "already dispatched can't dispatch again with out verifying";
        }
      }
      Logs logs = Logs(
          qrCode: qrCodes.qrCode,
          scanDateTime: qrCodes.lastScanDate,
          status: qrCodes.status,
          remarks: status,
          scanBy: "-",
          scanFor: "-",
          batchNo: qrCodes.lastBatch);
      // print(logs.toMap());
      await db.insert('Logs', logs.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return id;
    } catch (e) {
      return result;
    }
  }

  Future<List<QrCodes>> getQrCodeData(String string) async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('QrCodes',
        orderBy: "id DESC", where: "status='dispatch'");
    return queryResult.map((e) => QrCodes.fromMap(e)).toList();
  }

  Future<List<QrCodes>> getVerifiedQrCodeData(String string) async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
    await db.query('QrCodes', orderBy: "id DESC", where: "status='verify'");
    return queryResult.map((e) => QrCodes.fromMap(e)).toList();
  }

  // verifyQrCode(QrCodes qrCodes) {}

  Future<int> verifyQrCode(QrCodes qrCodes) async {
    int result = 0;
    final Database db = await initializeDB();
    try {
      final List<Map<String, Object?>> queryResult = await db.query('QrCodes',
          orderBy: 'id Desc',
          where: 'qr_code is ?',
          whereArgs: [qrCodes.qrCode]);
      var a = queryResult.map((e) => QrCodes.fromMap(e)).toList();
      int id = 0;
      String status = "error";
      if (a.isEmpty) {
        return 0;
      } else {
        if (a[0].status == "dispatch") {
          double cash = 0;
          double point = 0;
          if (qrCodes.qrCode.split("-")[1].contains("CC")) {
            cash = double.parse(
                qrCodes.qrCode.split("-")[1].replaceAll(RegExp(r'[^0-9]'), ''));
          } else if (qrCodes.qrCode.split("-")[1].contains("PC")) {
            point = double.parse(
                qrCodes.qrCode.split("-")[1].replaceAll(RegExp(r'[^0-9]'), ''));
          }
          qrCodes.lastBatch = 2;
          qrCodes.totalPoints = a[0].totalPoints + point;
          qrCodes.totalCash = a[0].totalCash + cash;
          qrCodes.verifiedCount = a[0].verifiedCount + 1;
          qrCodes.dispatchedCount = a[0].dispatchedCount;
          // qrCodes.status = s;
          qrCodes.scanCount = a[0].scanCount + 1;
          await db.update('QrCodes', qrCodes.toMap(),
              where: "id is ?", whereArgs: [a[0].id]);
          status = "success";
        } else {
          status = "this QR is already verified and never dispatched again";
        }
      }
      Logs logs = Logs(
          qrCode: qrCodes.qrCode,
          scanDateTime: qrCodes.lastScanDate,
          status: qrCodes.status,
          remarks: status,
          scanBy: "-",
          scanFor: "-",
          batchNo: qrCodes.lastBatch);
      // print(logs.toMap());
      await db.insert('Logs', logs.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return id;
    } catch (e) {
      return result;
    }
  }

  Future<List<Logs>> getLogsDate(String string) async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Logs',
        orderBy: "id DESC");
    return queryResult.map((e) => Logs.fromMap(e)).toList();
  }

  Future<List<QrCodes>> getAllQrCodeData(String string) async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('QrCodes',
        orderBy: "id DESC");
    return queryResult.map((e) => QrCodes.fromMap(e)).toList();
  }

  Future<bool> isAddable(qrCode) async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query(
        'QrCodes', where: "qr_code='$qrCode'");
    if (queryResult.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
