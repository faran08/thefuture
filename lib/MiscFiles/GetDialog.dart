import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../globals.dart';

void getDialog(BuildContext context, void Function() onPressed,
    String cancelText, String okText, String warningText, String messageText) {
  Get.dialog(Center(
    child: Container(
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
          color: backGroundColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 50,
              ),
              Text(
                warningText,
                style: TextStyle(
                    color: textColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  messageText,
                  style: TextStyle(color: textColor, fontSize: 20),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    cancelText,
                    style: TextStyle(color: textColor),
                  )),
              TextButton(
                  onPressed: () => onPressed(),
                  child: Text(
                    okText,
                    style: TextStyle(color: textColor),
                  ))
            ],
          )
        ],
      ),
    ),
  ));
}
