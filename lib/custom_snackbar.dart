import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  CustomSnackbar._();
  static showCusotmSnackBar({@required String message, String title}) {
  Get.rawSnackbar(
    titleText: title ==  null ? Container() : Text(
      title,
      style: Get.textTheme.headline6.copyWith(color: Get.theme.primaryColor),
    ),
    messageText: Text(message, style: Get.textTheme.bodyText2.copyWith(color: Colors.white),),
    backgroundColor: Get.theme.accentColor,
  );
}
}
