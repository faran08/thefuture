// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:select_card/select_card.dart';
import 'package:thefuture/globals.dart';

import '../LoginFiles/StateControllers/StudentNameController.dart';

class TakeExam extends StatelessWidget {
  String defineID = '';
  String designID = '';
  DateTime examDate;
  TakeExam({
    Key? key,
    required this.defineID,
    required this.designID,
    required this.examDate,
  }) : super(key: key);

  CollectionReference examEntries =
      FirebaseFirestore.instance.collection('Exams');
  CollectionReference examResults =
      FirebaseFirestore.instance.collection('ExamResults');
  StudentNameController studentNameController =
      Get.put(StudentNameController());
  String examResultID = '';
  bool dataLoaded = false;
  int _start = 0;
  Timer _timer = Timer.periodic(
    Duration(seconds: 1),
    (Timer timer) {},
  );
  late QuerySnapshot<Object?> allQuestions;
  List<String> answersToQuestions = [];

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          saveResults();
        } else {
          _start--;
          studentNameController.update();
        }
      },
    );
  }

  void savePreExamResults() {
    examResults.add({
      'studentID': globalUserName,
      'defineID': defineID,
      'designID': designID,
      'examDate': examDate,
      'correctAnswers': 'xxxNotAttemptedxxx'
    }).then((value) => examResultID = value.id);
  }

  void saveResults() {
    List<Map> saveQuestionsMap = [];
    int totalMarks = 0;
    for (var i = 0; i < allQuestions.docs.length; i++) {
      saveQuestionsMap.add({
        'questionID': allQuestions.docs[i].id,
        'correctAnswer': allQuestions.docs[i]['correctAnswer'],
        'userAnswer': answersToQuestions[i],
        'tags': allQuestions.docs[i]['tags']
      });
      if (allQuestions.docs[i]['correctAnswer'] == answersToQuestions[i]) {
        totalMarks++;
      }
    }
    EasyLoading.show();
    examResults.doc(examResultID).update({
      'resultData': saveQuestionsMap,
      'correctAnswers': totalMarks.toString()
    }).then((value) {
      EasyLoading.dismiss();
      Get.close(2);
      Get.bottomSheet(
          BottomSheet(
              enableDrag: false,
              onClosing: () {},
              builder: (context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: Scaffold(
                    backgroundColor: backGroundColor,
                    appBar: AppBar(
                      backgroundColor: backGroundColor,
                      leading: Container(),
                      leadingWidth: 0,
                      elevation: 0,
                      centerTitle: true,
                      title: Text(
                        'Result',
                        style: TextStyle(color: Colors.red, fontSize: 25),
                      ),
                    ),
                    body: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Text(
                                'You have scored',
                                style: GoogleFonts.openSans(
                                  color: textColor,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text(
                                  totalMarks.toString() +
                                      ' / ' +
                                      allQuestions.docs.length.toString(),
                                  style: GoogleFonts.openSans(
                                      color: textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: buttonColor,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    shadowColor: backGroundColor,
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 10, 10)),
                                onPressed: () {
                                  Get.close(1);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Icon(
                                        Icons.done_outline_rounded,
                                        color: Colors.green,
                                        size: 30,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child: AutoSizeText(
                                        'OK',
                                        minFontSize: 20,
                                        style: GoogleFonts.poppins(
                                            color: textColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          isScrollControlled: true);
    });
  }

  void getExamQuestions() {
    examEntries
        .where('defineURL', isEqualTo: defineID)
        .where('dateForWhichURL',
            isGreaterThanOrEqualTo:
                DateTime(examDate.year, examDate.month, examDate.day, 0))
        .where('dateForWhichURL',
            isLessThanOrEqualTo:
                DateTime(examDate.year, examDate.month, examDate.day, 24))
        .get()
        .then((value) {
      allQuestions = value;
      dataLoaded = true;
      savePreExamResults();
      print('No of questions ${value.docs.length}');
      _start = 0;
      _timer.cancel();

      for (var element in value.docs) {
        try {
          print(((element.data() as Map)['timeForQuestion']).toString());
          _start = _start +
              ((element.data() as Map)['timeForQuestion'] as double).toInt();
          answersToQuestions.add('notSelected');
        } catch (e) {}
      }
      if (!_timer.isActive) {
        startTimer();
      }

      studentNameController.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    getExamQuestions();
    // startTimer();
    return WillPopScope(
        child: Scaffold(
          backgroundColor: backGroundColor,
          appBar: AppBar(
            leading: Container(),
            elevation: 0,
            leadingWidth: 0,
            backgroundColor: backGroundColor,
            actions: [
              IconButton(
                  onPressed: () {
                    Get.bottomSheet(
                        BottomSheet(
                            enableDrag: false,
                            onClosing: () {},
                            builder: (context) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.95,
                                child: Scaffold(
                                  backgroundColor: backGroundColor,
                                  appBar: AppBar(
                                    backgroundColor: backGroundColor,
                                    leading: Container(),
                                    leadingWidth: 0,
                                    elevation: 0,
                                    centerTitle: true,
                                    title: Text(
                                      'Warning',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 25),
                                    ),
                                  ),
                                  body: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Are you sure?',
                                              style: GoogleFonts.openSans(
                                                color: textColor,
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 10, 0, 0),
                                              child: Text(
                                                'Be sure about all your answers. You cannot re-attempt the test.',
                                                style: GoogleFonts.openSans(
                                                    color: textColor,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 20, 0, 0),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor: buttonColor,
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  shadowColor: backGroundColor,
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 10)),
                                              onPressed: () {
                                                Get.close(1);
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 0, 0),
                                                    child: Icon(
                                                      Icons
                                                          .done_outline_rounded,
                                                      color: Colors.green,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 0, 20, 0),
                                                    child: AutoSizeText(
                                                      'Continue with Exam',
                                                      minFontSize: 20,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: textColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 20, 0, 0),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor: buttonColor,
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  shadowColor: backGroundColor,
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 10)),
                                              onPressed: () {
                                                saveResults();
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 0, 0),
                                                    child: Icon(
                                                      Icons.cancel,
                                                      color: Colors.red,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 0, 20, 0),
                                                    child: AutoSizeText(
                                                      'Submit',
                                                      minFontSize: 20,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: textColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  )
                                                ],
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                        isScrollControlled: true);
                  },
                  icon: Icon(
                    Icons.done_outline_rounded,
                    color: Colors.black,
                    size: 30,
                  ))
            ],
            title: GetBuilder<StudentNameController>(builder: (_) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timelapse_rounded,
                        color: textColor,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          _start.toString() + ' Secs Remaining',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          body: GetBuilder<StudentNameController>(builder: (_) {
            return dataLoaded
                ? ListView.builder(
                    itemCount: allQuestions.docs.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              allQuestions.docs[index]['questionStatement'],
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: SelectGroupCard(context, titles: [
                                allQuestions.docs[index]['optionOne'],
                                allQuestions.docs[index]['optionTwo'],
                                allQuestions.docs[index]['optionThree'],
                                allQuestions.docs[index]['optionFour']
                              ], onTap: (title) {
                                debugPrint(title);
                                answersToQuestions[index] = title;
                              }),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Divider(
                                thickness: 2,
                              ),
                            )
                          ],
                        ),
                      );
                    }))
                : Text('Loading');
          }),
        ),
        onWillPop: () async {
          Get.bottomSheet(
              BottomSheet(
                  enableDrag: false,
                  onClosing: () {},
                  builder: (context) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.95,
                      child: Scaffold(
                        backgroundColor: backGroundColor,
                        appBar: AppBar(
                          backgroundColor: backGroundColor,
                          leading: Container(),
                          leadingWidth: 0,
                          elevation: 0,
                          centerTitle: true,
                          title: Text(
                            'Warning',
                            style: TextStyle(color: Colors.red, fontSize: 25),
                          ),
                        ),
                        body: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Please carefully read below before exiting',
                                    style: GoogleFonts.openSans(
                                      color: textColor,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Text(
                                      'You have not completed you exam yet. If you exit right now you will be marked ZERO.',
                                      style: GoogleFonts.openSans(
                                          color: textColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: buttonColor,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        shadowColor: backGroundColor,
                                        padding: EdgeInsets.fromLTRB(
                                            10, 10, 10, 10)),
                                    onPressed: () {
                                      Get.close(1);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Icon(
                                            Icons.done_outline_rounded,
                                            color: Colors.green,
                                            size: 30,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 20, 0),
                                          child: AutoSizeText(
                                            'Continue with Exam',
                                            minFontSize: 20,
                                            style: GoogleFonts.poppins(
                                                color: textColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: buttonColor,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        shadowColor: backGroundColor,
                                        padding: EdgeInsets.fromLTRB(
                                            10, 10, 10, 10)),
                                    onPressed: () {
                                      Get.close(2);
                                      Fluttertoast.showToast(
                                          msg: 'You have been marked zero.',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.black,
                                          fontSize: 16.0);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 20, 0),
                                          child: AutoSizeText(
                                            'Exit & Fail',
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
                      ),
                    );
                  }),
              isScrollControlled: true);
          return false;
        });
  }
}
