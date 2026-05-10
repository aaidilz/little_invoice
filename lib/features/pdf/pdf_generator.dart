import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:little_invoice/core/services/file_service.dart';
import 'package:little_invoice/models/buyer.dart';
import 'package:little_invoice/models/invoice.dart';
import 'package:little_invoice/models/invoice_item.dart';
import 'package:little_invoice/models/seller_profile.dart';
import 'package:little_invoice/features/pdf/template_classic.dart';
import 'package:little_invoice/features/pdf/template_modern.dart';

class PdfGenerator {
  final FileService fileService;

  PdfGenerator(this.fileService);

  Future<Uint8List> generate({
    required Invoice invoice,
    required SellerProfile seller,
    required Buyer buyer,
    required List<InvoiceItem> items,
    int templateIndex = 0,
  }) async {
    final pdf = pw.Document();

    pw.MemoryImage? logoImage;
    if (seller.logoPath != null && await File(seller.logoPath!).exists()) {
      logoImage = pw.MemoryImage(await File(seller.logoPath!).readAsBytes());
    }

    pw.MemoryImage? stampImage;
    if (seller.stampPath != null && await File(seller.stampPath!).exists()) {
      stampImage = pw.MemoryImage(await File(seller.stampPath!).readAsBytes());
    }

    pw.MemoryImage? signatureImage;
    if (seller.signaturePath != null &&
        await File(seller.signaturePath!).exists()) {
      signatureImage =
          pw.MemoryImage(await File(seller.signaturePath!).readAsBytes());
    }

    if (templateIndex == 0) {
      TemplateClassic.buildPdf(
        pdf: pdf,
        invoice: invoice,
        seller: seller,
        buyer: buyer,
        items: items,
        logoImage: logoImage,
        stampImage: stampImage,
        signatureImage: signatureImage,
      );
    } else {
      TemplateModern.buildPdf(
        pdf: pdf,
        invoice: invoice,
        seller: seller,
        buyer: buyer,
        items: items,
        logoImage: logoImage,
        stampImage: stampImage,
        signatureImage: signatureImage,
      );
    }

    return pdf.save();
  }
}
