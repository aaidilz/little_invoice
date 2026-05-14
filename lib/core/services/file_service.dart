import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class FileService {
  Future<String> saveImage(File sourceFile) async {
    if (kIsWeb) {
      throw UnsupportedError(
        'Saving images to the local file system is not supported on web.',
      );
    }

    final directory = await getApplicationDocumentsDirectory();
    final ext = p.extension(sourceFile.path);
    final fileName = '${const Uuid().v4()}$ext';
    final savedPath = p.join(directory.path, fileName);

    final savedFile = await sourceFile.copy(savedPath);
    return savedFile.path;
  }

  Future<File?> loadImage(String absolutePath) async {
    if (kIsWeb) {
      return null;
    }

    final file = File(absolutePath);
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  Future<void> deleteImage(String absolutePath) async {
    if (kIsWeb) {
      return;
    }

    final file = File(absolutePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<String> savePdf(Uint8List bytes, String fileName) async {
    if (kIsWeb) {
      throw UnsupportedError(
        'Saving PDFs to the local file system is not supported on web.',
      );
    }

    final directory = await getApplicationDocumentsDirectory();
    final savedPath = p.join(directory.path, fileName);

    final file = File(savedPath);
    await file.writeAsBytes(bytes);
    return savedPath;
  }
}
