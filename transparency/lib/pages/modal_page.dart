import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transparency/templates/modal_template.dart';

class ModalPage extends StatelessWidget {
  const ModalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          SystemNavigator.pop();
        }
        return false;
      },
      child: const ModalTemplate(
        title: "Modal",
        child: Column(
          children: [
            Text("MODAL"),
          ],
        ),
      ),
    );
  }
}
