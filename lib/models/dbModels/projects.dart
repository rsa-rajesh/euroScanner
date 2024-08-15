class QrCodes {
  int? id;
  String qrCode;
  String status;
  String lastScanDate;
  String lastScanBy;
  String lastVerifiedDealer;
  int lastBatch;
  int dispatchedCount;
  int verifiedCount;
  int scanCount;
  double totalCash;
  double totalPoints;
  int isDeleted;

  QrCodes({
    this.id,
    required this.qrCode,
    required this.status,
    required this.lastScanDate,
    required this.lastScanBy,
    required this.lastVerifiedDealer,
    required this.lastBatch,
    required this.dispatchedCount,
    required this.verifiedCount,
    required this.scanCount,
    required this.totalCash,
    required this.isDeleted,
    required this.totalPoints,
  });

  QrCodes.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        qrCode = item["qr_code"],
        status = item["status"],
        lastScanDate = item["last_scan_date"],
        lastScanBy = item["last_scan_by"],
        lastVerifiedDealer = item["last_verified_dealer"],
        lastBatch = item["last_batch"],
        dispatchedCount = item["dispatched_count"],
        verifiedCount = item["verified_count"],
        scanCount = item["scan_count"],
        totalCash = item["total_cash"],
        isDeleted = item["is_deleted"],
        totalPoints = item["total_points"];

  Map<String, Object?> toMap() {
    return {
      'qr_code': qrCode,
      'status': status,
      'last_scan_date': lastScanDate,
      'last_scan_by': lastScanBy,
      'last_verified_dealer': lastVerifiedDealer,
      'last_batch': lastBatch,
      'dispatched_count': dispatchedCount,
      'verified_count': verifiedCount,
      'scan_count': scanCount,
      'total_cash': totalCash,
      'is_deleted': isDeleted,
      'total_points': totalPoints,
    };
  }
}

class Logs {
  int? id;
  String qrCode;
  String scanDateTime;
  String status;
  String remarks;
  String scanBy;
  String scanFor;
  int batchNo;

  Logs({
    this.id,
    required this.qrCode,
    required this.scanDateTime,
    required this.status,
    required this.remarks,
    required this.scanBy,
    required this.scanFor,
    required this.batchNo,
  });

  Logs.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        qrCode = item["qr_code"],
        scanDateTime = item["scan_date_time"],
        status = item["status"],
        remarks = item["remarks"],
        scanBy = item["scan_by"],
        scanFor = item["scan_for_dealer"],
        batchNo = item["batch_no"];

  Map<String, Object?> toMap() {
    return {
      'qr_code': qrCode,
      'scan_date_time': scanDateTime,
      'status': status,
      'remarks': remarks,
      'scan_by': scanBy,
      'scan_for_dealer': scanFor,
      'batch_no': batchNo,
    };
  }
}
