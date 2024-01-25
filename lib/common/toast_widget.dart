import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toastWidget(String message, Color color) {
  return Fluttertoast.showToast(
    msg: message,
    backgroundColor: color,
    gravity: ToastGravity.CENTER,
    fontSize: 15,
  );
}
