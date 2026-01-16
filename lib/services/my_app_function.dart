import 'package:e_shop/services/app_manager.dart';
import 'package:e_shop/widgets/subtitle_text_widget.dart';
import 'package:e_shop/widgets/titles_text_widget.dart';
import 'package:flutter/material.dart';

class MyAppFunctions {
  static Future<void> showErrorOrWarningDialog({
    required BuildContext context,
    required Function fct,
    required String subtitle,
    bool isError = true,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isError ? AssetsManager.error : AssetsManager.warning,
                height: 60,
                width: 60,
              ),
              const SizedBox(height: 16),

              Flexible(
                child: SingleChildScrollView(
                  child: SubtitleTextWidget(
                    label: subtitle,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!isError)
                    TextButton(
                      onPressed: () {
                        fct();
                        Navigator.pop(context);
                      },
                      child:  SubtitleTextWidget(label: "ok", fontWeight: FontWeight.bold,),
                    ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: SubtitleTextWidget(
                      label: "Cancel",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFCT,
    required galleryFCT,
    required removeFCT,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: TitlesTextWidget(label: "Choose an option")),

          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextButton.icon(
                  onPressed: () {
                    cameraFCT();

                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.camera),
                  label: Text("Camera"),
                ),

                TextButton.icon(
                  onPressed: () {
                    galleryFCT();

                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.browse_gallery),
                  label: Text("gallery"),
                ),

                TextButton.icon(
                  onPressed: () {
                    removeFCT();

                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.remove),
                  label: Text("remove"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
