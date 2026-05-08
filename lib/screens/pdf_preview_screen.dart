import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/core/services/file_service.dart';

class PdfPreviewScreen extends StatelessWidget {
  final Uint8List pdfBytes;
  final String invoiceNumber;
  final FileService _fileService = FileService();

  PdfPreviewScreen({
    super.key,
    required this.pdfBytes,
    required this.invoiceNumber,
  });

  Future<void> _saveToDevice(BuildContext context) async {
    try {
      final path = await _fileService.savePdf(pdfBytes, '$invoiceNumber.pdf');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved to $path')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
  }

  Future<void> _sharePdf(BuildContext context) async {
    try {
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: '$invoiceNumber.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Preview'),
      ),
      body: PdfPreview(
        build: (format) => pdfBytes,
        allowPrinting: true,
        allowSharing: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppTheme.space16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _saveToDevice(context),
                child: const Text('Save to Device'),
              ),
            ),
            const SizedBox(width: AppTheme.space12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _sharePdf(context),
                child: const Text('Share'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
