// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefuture/AdminFiles/StateControllers.dart';

import '../globals.dart';

class PrepareExam extends StatelessWidget {
  String examType = '';
  DateTime inputDate;
  String defineURL = '';
  PrepareExam(
      {Key? key,
      required this.examType,
      required this.inputDate,
      required this.defineURL})
      : super(key: key);
  double sliderValue = 1.0;
  CollectionReference entries =
      FirebaseFirestore.instance.collection('Entries');
  CollectionReference exams = FirebaseFirestore.instance.collection('Exams');
  List<QueryDocumentSnapshot<Object?>> examQuestions = [];
  AdminStateControllers adminStateControllers =
      Get.put(AdminStateControllers());
  void getAllQuestions() {
    entries
        .where('defineURL', isEqualTo: defineURL)
        .where('dateForWhichURL',
            isGreaterThanOrEqualTo:
                DateTime(inputDate.year, inputDate.month, inputDate.day))
        .where('dateForWhichURL',
            isLessThanOrEqualTo:
                DateTime(inputDate.year, inputDate.month, inputDate.day, 24))
        .get()
        .then((value) {
      examQuestions = value.docs;
      adminStateControllers.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    getAllQuestions();
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Get.bottomSheet(BottomSheet(
                  onClosing: () {},
                  builder: (_) {
                    return Container(
                      color: backGroundColor,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text(
                                'Select number of questions',
                                style: GoogleFonts.poppins(
                                    color: textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            GetBuilder<AdminStateControllers>(builder: (_) {
                              return Slider(
                                  min: 1.0,
                                  max: 100,
                                  activeColor: textColor,
                                  value: sliderValue,
                                  onChanged: ((value) {
                                    sliderValue = (value).ceil().toDouble();
                                    adminStateControllers.update();
                                  }));
                            }),
                            GetBuilder<AdminStateControllers>(builder: (_) {
                              return Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Center(
                                    child: Text(sliderValue.toString(),
                                        style: GoogleFonts.poppins(
                                            color: textColor,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold)),
                                  ));
                            }),
                            Center(
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: buttonColor,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      shadowColor: backGroundColor,
                                      padding:
                                          EdgeInsets.fromLTRB(10, 20, 10, 20)),
                                  onPressed: () {
                                    if (examQuestions.length > sliderValue) {
                                      List<int> questionsList = [];
                                      int maxLimit = 0;
                                      while (
                                          questionsList.length < sliderValue &&
                                              maxLimit < 100) {
                                        maxLimit++;
                                        int number = Random()
                                            .nextInt(sliderValue.toInt());
                                        if (!questionsList.contains(number)) {
                                          questionsList.add(number);
                                        }
                                        print(questionsList);
                                      }
                                      for (var element in questionsList) {
                                        exams
                                            .add(examQuestions[element].data());
                                      }
                                      Get.close(2);
                                    } else {
                                      Get.close(1);
                                      var fToast = FToast();
                                      fToast.init(context);
                                      fToast.showToast(
                                          child: getToast(
                                              JelloIn(child: Icon(Icons.error)),
                                              'Ask Teachers to add more questions'));
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Icon(
                                          Icons.scale_rounded,
                                          color: textColor,
                                          size: 25,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        child: AutoSizeText(
                                          'Done',
                                          minFontSize: 20,
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    );
                  }));
            },
            backgroundColor: Colors.white,
            label: Row(
              children: [
                Icon(
                  Icons.precision_manufacturing,
                  color: textColor,
                ),
                Text('Prepare')
              ],
            )),
        backgroundColor: backGroundColor,
        appBar: AppBar(
          title: Text(
            'Available Questions',
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: backGroundColor,
        ),
        body: GetBuilder<AdminStateControllers>(builder: (_) {
          return examQuestions.isNotEmpty
              ? ListView.builder(
                  itemCount: examQuestions.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: Text(
                        (examQuestions[index].data()
                            as Map)['questionStatement'],
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          'Prepared By: ${(examQuestions[index].data() as Map)['userID']}'),
                    );
                  }))
              : Center(
                  child: Text(
                    'No Questions Available',
                    style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                );
        }));
  }
}
