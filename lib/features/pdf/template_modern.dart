import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:invoice_app/models/buyer.dart';
import 'package:invoice_app/models/invoice.dart';
import 'package:invoice_app/models/invoice_item.dart';
import 'package:invoice_app/models/seller_profile.dart';
import 'package:intl/intl.dart';

class TemplateModern {
  static void buildPdf({
    required pw.Document pdf,
    required Invoice invoice,
    required SellerProfile seller,
    required Buyer buyer,
    required List<InvoiceItem> items,
    pw.MemoryImage? logoImage,
    pw.MemoryImage? stampImage,
    pw.MemoryImage? signatureImage,
  }) {
    final primaryColor = PdfColor.fromHex('#1A2B45');
    final accentColor = PdfColor.fromHex('#E67E22');
    final grayColor = PdfColor.fromHex('#F5F5F5');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.copyWith(
          marginTop: 0,
          marginBottom: 36,
          marginLeft: 36,
          marginRight: 36,
        ),
        build: (context) => [
          _buildHeaderBand(seller, primaryColor, logoImage),
          pw.SizedBox(height: 20),
          _buildInvoiceMeta(invoice, accentColor),
          pw.SizedBox(height: 20),
          _buildBuyerInfo(buyer),
          pw.SizedBox(height: 20),
          _buildItemTable(items, primaryColor, grayColor),
          pw.SizedBox(height: 10),
          _buildCalculationSummary(invoice),
          if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            pw.Text('Notes:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
            pw.Text(invoice.notes!, style: const pw.TextStyle(fontSize: 10)),
          ],
          pw.SizedBox(height: 40),
          _buildSignatureBlock(seller, invoice, stampImage, signatureImage),
        ],
      ),
    );
  }

  static pw.Widget _buildHeaderBand(SellerProfile seller, PdfColor primaryColor, pw.MemoryImage? logoImage) {
    return pw.Container(
      color: primaryColor,
      padding: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 24),
      margin: const pw.EdgeInsets.only(left: -36, right: -36), // Full bleed
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(seller.name, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                pw.SizedBox(height: 4),
                pw.Text(seller.address, style: const pw.TextStyle(fontSize: 10, color: PdfColors.white)),
                pw.Text('Phone: ${seller.phone}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.white)),
                pw.Text('Email: ${seller.email}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.white)),
                pw.Text('Bank: ${seller.bank}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.white)),
              ],
            ),
          ),
          if (logoImage != null) pw.Image(logoImage, width: 60, height: 60),
        ],
      ),
    );
  }

  static pw.Widget _buildInvoiceMeta(Invoice invoice, PdfColor accentColor) {
    final dateFormat = DateFormat('dd MMM yyyy');
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text('INVOICE', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: accentColor)),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('No: ${invoice.invoiceNumber}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: accentColor)),
            pw.Text('Date: ${invoice.cityDate}', style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Due Date: ${dateFormat.format(invoice.dueDate)}', style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildBuyerInfo(Buyer buyer) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Bill To:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        pw.Text(buyer.name, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.Text(buyer.address, style: const pw.TextStyle(fontSize: 10)),
        pw.Text('Phone: ${buyer.phone}', style: const pw.TextStyle(fontSize: 10)),
        pw.Text('Email: ${buyer.email}', style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  static pw.Widget _buildItemTable(List<InvoiceItem> items, PdfColor primaryColor, PdfColor grayColor) {
    final tableHeaders = ['No.', 'Description', 'Qty', 'Unit Price', 'Total'];
    final tableData = items.asMap().entries.map((e) {
      final idx = e.key + 1;
      final item = e.value;
      return [
        idx.toString(),
        item.description,
        item.quantity.toString(),
        item.price.toStringAsFixed(2),
        item.lineTotal.toStringAsFixed(2),
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: tableHeaders,
      data: tableData,
      border: null,
      headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: pw.BoxDecoration(color: primaryColor),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: grayColor)),
      ),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget _buildCalculationSummary(Invoice invoice) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 200,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildSummaryRow('Subtotal', invoice.subtotal.toStringAsFixed(2)),
              _buildSummaryRow('Discount (${invoice.discount.toStringAsFixed(1)}%)', '– ${ (invoice.subtotal * invoice.discount / 100).toStringAsFixed(2) }'),
              _buildSummaryRow('Tax (${invoice.tax.toStringAsFixed(1)}%)', '+ ${ ((invoice.subtotal - (invoice.subtotal * invoice.discount / 100)) * invoice.tax / 100).toStringAsFixed(2) }'),
              _buildSummaryRow('Down Payment', '– ${invoice.dp.toStringAsFixed(2)}'),
              pw.Divider(),
              _buildSummaryRow('Total', invoice.total.toStringAsFixed(2), isBold: true),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: isBold ? pw.FontWeight.bold : null)),
          pw.Text(value, style: pw.TextStyle(fontSize: 10, fontWeight: isBold ? pw.FontWeight.bold : null)),
        ],
      ),
    );
  }

  static pw.Widget _buildSignatureBlock(SellerProfile seller, Invoice invoice, pw.MemoryImage? stampImage, pw.MemoryImage? signatureImage) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        // Stamp on the left
        if (stampImage != null)
          pw.Image(stampImage, width: 80, height: 80)
        else
          pw.SizedBox(width: 80, height: 80),
        
        // Signature on the right
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(invoice.cityDate, style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 8),
            if (signatureImage != null)
              pw.Image(signatureImage, height: 80)
            else
              pw.SizedBox(height: 80),
            pw.SizedBox(height: 8),
            pw.Text(
              seller.name,
              style: pw.TextStyle(fontSize: 10, decoration: pw.TextDecoration.underline),
            ),
          ],
        ),
      ],
    );
  }
}
