
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class ReceiptService {
  static Future<void> generateInwardReceipt({
    required Map<String, dynamic> entryData,
    required String storageName,
    required String userName,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        build: (pw.Context context) {
          return _buildReceiptLayout(
            title: 'INWARD RECEIPT',
            color: PdfColors.green,
            data: entryData,
            storageName: storageName,
            userName: userName,
            font: font,
            isInward: true,
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Inward_Receipt_${entryData['receipt_number'] ?? 'Draft'}.pdf',
    );
  }

  static Future<void> generateOutwardReceipt({
    required Map<String, dynamic> entryData,
    required String storageName,
    required String userName,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        build: (pw.Context context) {
          return _buildReceiptLayout(
            title: 'OUTWARD RECEIPT',
            color: PdfColors.orange,
            data: entryData,
            storageName: storageName,
            userName: userName,
            font: font,
            isInward: false,
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Outward_Receipt_${entryData['receipt_number'] ?? 'Draft'}.pdf',
    );
  }

  static pw.Widget _buildReceiptLayout({
    required String title,
    required PdfColor color,
    required Map<String, dynamic> data,
    required String storageName,
    required String userName,
    required pw.Font font,
    required bool isInward,
  }) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final date = DateTime.now();

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 2),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header
          pw.Center(
            child: pw.Text(
              storageName.toUpperCase(),
              style: pw.TextStyle(
                font: font,
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.Divider(color: PdfColors.grey400),
          pw.SizedBox(height: 5),
          
          // Receipt Title & ID
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(title, style: pw.TextStyle(font: font, color: color, fontWeight: pw.FontWeight.bold)),
              pw.Text('#${data['receipt_number'] ?? '---'}', style: pw.TextStyle(font: font)),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Text('Date: ${dateFormat.format(date)}', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700)),
          pw.SizedBox(height: 10),

          // Party Details
          pw.Container(
            padding: const pw.EdgeInsets.all(5),
            color: PdfColors.grey100,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Party Details:', style: pw.TextStyle(font: font, fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 2),
                pw.Text('Name: ${data['party_name'] ?? 'N/A'}', style: pw.TextStyle(font: font, fontSize: 10)),
                pw.Text('Phone: ${data['party_phone'] ?? 'N/A'}', style: pw.TextStyle(font: font, fontSize: 10)),
              ],
            ),
          ),
          pw.SizedBox(height: 10),

          // Crop Details
          pw.Text('Item Details:', style: pw.TextStyle(font: font, fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              pw.TableRow(children: [
                _tableCell('Crop', font, isHeader: true),
                _tableCell('Qty', font, isHeader: true),
                _tableCell('Room', font, isHeader: true),
              ]),
              pw.TableRow(children: [
                _tableCell(data['crop_name'] ?? '', font),
                _tableCell('${data['quantity']} ${data['unit'] ?? ''}', font),
                _tableCell(data['room'] ?? '', font),
              ]),
            ],
          ),
          
          pw.SizedBox(height: 10),
          if (isInward) ...[
             pw.Text('Variety: ${data['variety'] ?? '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
             pw.Text('Grade: ${data['grade'] ?? '-'}', style: pw.TextStyle(font: font, fontSize: 10)),
          ],

          pw.Spacer(),
          pw.Divider(color: PdfColors.grey400),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Authorized Sig.', style: pw.TextStyle(font: font, fontSize: 8)),
              pw.Text('Operator: $userName', style: pw.TextStyle(font: font, fontSize: 8)),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _tableCell(String text, pw.Font font, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
