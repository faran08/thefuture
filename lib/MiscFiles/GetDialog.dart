import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../globals.dart';

void getDialog(
    BuildContext context,
    void Function() onPressed,
    String cancelText,
    String okText,
    String warningText,
    String messageText,
    void Function() onCancelPressed) {
  Get.dialog(Center(
    child: SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
            color: backGroundColor, borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  // IconButton(
                  //     onPressed: () {
                  //       Get.close(1);
                  //     },
                  //     icon: const Icon(
                  //       Icons.remove_circle_outline,
                  //       color: Colors.red,
                  //     )),
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
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => onCancelPressed(),
                        child: Text(
                          cancelText,
                          style: TextStyle(
                              color: textColor, fontWeight: FontWeight.bold),
                        )),
                    TextButton(
                        onPressed: () => onPressed(),
                        child: Text(
                          okText,
                          style: TextStyle(
                              color: textColor, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  ));
}
