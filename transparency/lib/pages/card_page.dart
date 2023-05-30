import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transparency/templates/modal_template.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // For the back button/gesture in Android
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          // Animated is for iOS only.
          // The modal template has its own call to the system navigator that
          // triggers when the user touches the modal's background.
          SystemNavigator.pop(animated: true);
        }
        return false;
      },
      child: ModalTemplate(
        title: "Card",
        mode: ModalTemplateMode.bottomCard,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _paragraph("Modal in a window that should be transparent."),
              _paragraph(
                  "Tapping on the background calls SystemNavigator.pop()."),
              _paragraph("This must render in a transparent activity or view."),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}
