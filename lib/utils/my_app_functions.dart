import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyAppFunctions {
  // Image picker dialog
  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function(ImageSource) onImageSourceSelected,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  onImageSourceSelected(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () {
                  onImageSourceSelected(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Format price
  static String formatPrice(double price) {
    return '\$$price';
  }

  // Show snackbar
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
