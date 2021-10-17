import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatify_app/common/widget/platform_sensitive_widget.dart';

// ignore: must_be_immutable
class PlatformSensitiveAlertDialog extends PlatformSensitiveWidget {
  final String header;
  final String content;
  final String baseButtonText;
  String? cancelButtonText;

  PlatformSensitiveAlertDialog(
      {required this.header,
      required this.content,
      required this.baseButtonText,
      this.cancelButtonText});

  Future<bool?> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context, builder: (context) => this)
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(header),
      content: Text(content),
      actions: _dialogButonsSettings(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(header),
      content: Text(content),
      actions: _dialogButonsSettings(context),
    );
  }

  List<Widget> _dialogButonsSettings(BuildContext context) {
    final allButtons = <Widget>[];

    if (Platform.isIOS) {
      if (cancelButtonText != null) {
        allButtons.add(
          CupertinoDialogAction(
            child: Text(cancelButtonText ?? ""),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      allButtons.add(
        CupertinoDialogAction(
          child: Text(baseButtonText),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    } else {
      if (cancelButtonText != null) {
        allButtons.add(
          TextButton(
            child: Text(cancelButtonText ?? ""),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      allButtons.add(
        TextButton(
          child: Text("Tamam"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    }

    return allButtons;
  }
}
