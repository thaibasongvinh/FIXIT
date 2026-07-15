import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class ExportUtils {
  static Future<void> exportToExcel({
    required String fileName,
    required List<String> headers,
    required List<List<dynamic>> rows,
    String sheetName = 'Report',
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel[sheetName];

    // Add headers
    for (var i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = TextCellValue(headers[i]);
    }

    // Add rows
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      for (var j = 0; j < row.length; j++) {
        final value = row[j];
        CellValue? cellValue;
        
        if (value is String) {
          cellValue = TextCellValue(value);
        } else if (value is int) {
          cellValue = IntCellValue(value);
        } else if (value is double) {
          cellValue = DoubleCellValue(value);
        } else if (value is bool) {
          cellValue = BoolCellValue(value);
        } else if (value != null) {
          cellValue = TextCellValue(value.toString());
        }

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1)).value = cellValue;
      }
    }

    // Save file
    final bytes = excel.save();
    if (bytes == null) return;

    final directory = await getTemporaryDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${directory.path}/${fileName}_$timestamp.xlsx');
    await file.writeAsBytes(bytes);

    // Share file
    await Share.shareXFiles([XFile(file.path)], text: 'FixIt Admin Report: $fileName');
  }
}
