import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:little_invoice/core/services/file_service.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';

class ImagePickerWidget extends StatelessWidget {
  final String label;
  final String? currentPath;
  final Function(String path) onImageSelected;
  final FileService _fileService = FileService();
  final ImagePicker _picker = ImagePicker();

  ImagePickerWidget({
    super.key,
    required this.label,
    this.currentPath,
    required this.onImageSelected,
  });

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final savedPath = await _fileService.saveImage(File(pickedFile.path));
        onImageSelected(savedPath);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load image: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            ),
          ),
        );
      }
    }
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: AppTheme.space8),
        InkWell(
          onTap: () => _showPickerOptions(context),
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.outline,
                style: BorderStyle.solid,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            ),
            child: currentPath != null && File(currentPath!).existsSync()
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                    child: Image.file(
                      File(currentPath!),
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      size: 40,
                      color: AppColors.outline,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
