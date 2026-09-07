import 'dart:js_interop';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:web/web.dart' as web;

class ExcelExportService {
  static void exportCustomers(
    List<Map<String, dynamic>> customers, {
    required String filename,
  }) {
    final excel = Excel.createExcel();
    final sheet = excel['Customers'];
    excel.delete('Sheet1');

    sheet.appendRow([
      TextCellValue('Customer ID'),
      TextCellValue('Name'),
      TextCellValue('Account Number'),
      TextCellValue('Loan Status'),
      TextCellValue('Date'),
    ]);

    for (final customer in customers) {
      final date = customer['parsedDate'] as DateTime;
      sheet.appendRow([
        TextCellValue(customer['customer_id'] as String),
        TextCellValue(customer['name'] as String),
        TextCellValue(customer['account_number'] as String),
        TextCellValue(customer['loan_status'] as String),
        TextCellValue(_formatDate(date)),
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) {
      return;
    }

    final uint8Bytes = Uint8List.fromList(bytes); // ← the fix
    final blobParts = [uint8Bytes.toJS].toJS;
    final blob = web.Blob(
      blobParts,
      web.BlobPropertyBag(
        type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      ),
    );

    final url = web.URL.createObjectURL(blob);
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..style.display = 'none'
      ..download = filename;

    web.document.body!.appendChild(anchor);
    anchor.click();
    web.document.body!.removeChild(anchor);
    web.URL.revokeObjectURL(url);
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}