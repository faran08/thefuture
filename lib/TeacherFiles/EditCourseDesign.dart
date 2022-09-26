// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thefuture/TeacherFiles/EntryDefinition.dart';
import 'package:thefuture/TeacherFiles/ExamEntries.dart';
import 'package:thefuture/globals.dart';

import 'HomePageController.dart';

class EditDesignCourse extends StatelessWidget {
  QueryDocumentSnapshot<Object?> documentData;
  EditDesignCourse({Key? key, required this.documentData}) : super(key: key);
  final TeacherHomePageController teacherHomePageController =
      Get.put(TeacherHomePageController());
  CollectionReference designedCourses =
      FirebaseFirestore.instance.collection('designedCourses');
  CollectionReference definedCourses =
      FirebaseFirestore.instance.collection('definedCourses');
  CollectionReference entries =
      FirebaseFirestore.instance.collection('Entries');
  Map definedCourseData = {};
  List<int> recordAvailable = [];
  List<Map> customDefinedData = [];

  int getNumberOfDays() {
    DateTime finalExamDate =
        ((documentData.data() as Map)['finalExamDate'] as Timestamp).toDate();
    DateTime startDate =
        ((documentData.data() as Map)['startDate'] as Timestamp).toDate();
    return DateTime(finalExamDate.year, finalExamDate.month, finalExamDate.day)
        .difference(DateTime(startDate.year, startDate.month, startDate.day))
        .inDays;
  }

  void getDefinationData() async {
    Map temp = documentData.data() as Map;
    definedCourses.doc(temp['fatherID']).get().then((value) {
      definedCourseData = value.data() as Map;
      definedCourseData['ID'] = value.id;
      teacherHomePageController.update();
    });
  }

  int getNumberOfRecordAvailable(DateTime date) {
    int returnCount = 0;
    for (var element in customDefinedData) {
      if ((element['data']['dateForWhichURL'] as Timestamp)
              .toDate()
              .isAfter(DateTime(date.year, date.month, date.day, 0)) &&
          (element['data']['dateForWhichURL'] as Timestamp)
              .toDate()
              .isBefore(DateTime(date.year, date.month, date.day, 23, 59))) {
        returnCount++;
      }
    }
    return returnCount;
  }

  // Map getAllDocumentsOfSpecificDate(int date)
  // {

  // }

  void getCustomDefinationData() async {
    recordAvailable.clear();
    customDefinedData.clear();
    entries.where('designURL', isEqualTo: documentData.id).get().then((value) {
      for (var element in value.docs) {
        customDefinedData.add({'data': element.data(), 'id': element.id});
        recordAvailable.add(DateTime.fromMillisecondsSinceEpoch(
                ((element.data() as Map)['dateForWhichURL'] as Timestamp)
                    .millisecondsSinceEpoch)
            .day);
      }
      teacherHomePageController.update();
    });
  }

  bool checkInBetweenDates(DateTime checkDate, DateTime currentDate) {
    if (checkDate.isAfter(DateTime(
            currentDate.year, currentDate.month, currentDate.day, 0)) &&
        checkDate.isBefore(DateTime(
            currentDate.year, currentDate.month, currentDate.day, 23, 59))) {
      return true;
    } else {
      return false;
    }
  }

  String getCurrentDayActivity(DateTime date) {
    if (definedCourseData.isNotEmpty) {
      Map temp = definedCourseData;
      DateTime firstSessionalDate =
          (temp['firstSessionalDate'] as Timestamp).toDate();
      DateTime startDate = (temp['startDate'] as Timestamp).toDate();
      DateTime midTermDate = (temp['midTermDate'] as Timestamp).toDate();
      DateTime secondSessionalDate =
          (temp['secondSessionalDate'] as Timestamp).toDate();
      DateTime finalExamDate = (temp['finalExamDate'] as Timestamp).toDate();
      if (checkInBetweenDates(date, firstSessionalDate)) {
        return 'First Sessional';
      } else if (checkInBetweenDates(date, startDate)) {
        return 'Course Start';
      } else if (checkInBetweenDates(date, midTermDate)) {
        return 'Mid Term';
      } else if (checkInBetweenDates(date, secondSessionalDate)) {
        return 'Second Sessional';
      } else if (checkInBetweenDates(date, finalExamDate)) {
        return 'Final Exam';
      } else if (recordAvailable.contains(date.day)) {
        return 'Data Entry';
      } else {
        return 'Empty';
      }
    } else {
      return '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    getDefinationData();
    getCustomDefinationData();

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        actions: [
          (documentData.data() as Map).containsKey('publishStatus')
              ? (documentData.data() as Map)['publishStatus'] == false
                  ? TextButton(
                      onPressed: () {
                        Get.dialog(Center(
                          child: Container(
                            margin: EdgeInsets.all(30),
                            padding: EdgeInsets.all(20),
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: BoxDecoration(
                                color: backGroundColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Warning',
                                      style: TextStyle(
                                          color: textColor, fontSize: 25),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      child: Text(
                                        'Are you sure you want to publish? You will be able to edit data but this course will be available to students.\nDo not publish if data is incomplete.',
                                        style: TextStyle(
                                            color: textColor, fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: textColor),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          EasyLoading.show();
                                          designedCourses
                                              .doc(documentData.id)
                                              .update({
                                            'publishStatus': true
                                          }).then((value) {
                                            EasyLoading.dismiss();
                                            teacherHomePageController
                                                .getJoinedCourses();
                                            teacherHomePageController.update();
                                            Get.close(2);
                                          }).onError((error, stackTrace) {
                                            EasyLoading.dismiss();
                                            Fluttertoast.showToast(
                                                msg: 'Error: ' +
                                                    error.toString(),
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.grey,
                                                textColor: Colors.black,
                                                fontSize: 16.0);
                                          });
                                        },
                                        child: Text(
                                          'I am sure',
                                          style: TextStyle(color: textColor),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.save,
                            color: textColor,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Publish',
                              style: TextStyle(color: textColor),
                            ),
                          )
                        ],
                      ))
                  : Center(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(
                            Icons.done_outline_rounded,
                            size: 25,
                            color: Colors.green.shade800,
                          )),
                    )
              : TextButton(
                  onPressed: () {
                    Get.dialog(Center(
                      child: Container(
                        margin: EdgeInsets.all(30),
                        padding: EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                            color: backGroundColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Warning',
                                  style:
                                      TextStyle(color: textColor, fontSize: 25),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Text(
                                    'Are you sure you want to publish? You will be able to edit data but this course will be available to students.\nDo not publish if data is incomplete.',
                                    style: TextStyle(
                                        color: textColor, fontSize: 20),
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
                                      'Cancel',
                                      style: TextStyle(color: textColor),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      EasyLoading.show();
                                      designedCourses
                                          .doc(documentData.id)
                                          .update({'publishStatus': true}).then(
                                              (value) {
                                        EasyLoading.dismiss();
                                        Get.close(2);
                                      }).onError((error, stackTrace) {
                                        EasyLoading.dismiss();
                                        Fluttertoast.showToast(
                                            msg: 'Error: ' + error.toString(),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.grey,
                                            textColor: Colors.black,
                                            fontSize: 16.0);
                                      });
                                    },
                                    child: Text(
                                      'I am sure',
                                      style: TextStyle(color: textColor),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.save,
                        color: textColor,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          'Publish',
                          style: TextStyle(color: textColor),
                        ),
                      )
                    ],
                  ))
        ],
        elevation: 0,
        backgroundColor: backGroundColor,
        title: Text(
          (documentData.data()! as Map)['courseName'] as String,
          style: GoogleFonts.poppins(
              color: textColor, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: backGroundColor,
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
        child: GridView.builder(
          itemCount: getNumberOfDays() + 2,
          itemBuilder: (BuildContext context, int index) {
            return GetBuilder<TeacherHomePageController>(builder: (_) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      ((documentData.data() as Map)['startDate'] as Timestamp)
                              .toDate()
                              .add(Duration(days: index))
                              .isBefore(DateTime.now())
                          ? Colors.red.shade300
                          : Colors.white,
                ),
                padding: EdgeInsets.all(10),
                child: InkWell(
                  splashColor: textColor,
                  enableFeedback: false,
                  onTap: () {
                    if (DateTime.fromMillisecondsSinceEpoch(
                            ((documentData.data() as Map)['startDate']
                                    as Timestamp)
                                .millisecondsSinceEpoch)
                        .add(Duration(days: index))
                        .isAfter(DateTime.now().subtract(Duration(days: 1)))) {
                      if (getCurrentDayActivity(DateTime.fromMillisecondsSinceEpoch(
                                      ((documentData.data() as Map)['startDate'] as Timestamp)
                                          .millisecondsSinceEpoch)
                                  .add(Duration(days: index))) ==
                              'Data Entry' ||
                          getCurrentDayActivity(DateTime.fromMillisecondsSinceEpoch(
                                      ((documentData.data() as Map)['startDate'] as Timestamp)
                                          .millisecondsSinceEpoch)
                                  .add(Duration(days: index))) ==
                              'Empty' ||
                          getCurrentDayActivity(
                                  DateTime.fromMillisecondsSinceEpoch(((documentData.data() as Map)['startDate'] as Timestamp).millisecondsSinceEpoch)
                                      .add(Duration(days: index))) ==
                              'Course Start') {
                        Get.to(EntryDefinition(
                                originalDocument: documentData,
                                defineDocument: definedCourseData,
                                currentDate:
                                    DateTime.fromMillisecondsSinceEpoch(
                                            ((documentData.data()
                                                        as Map)['startDate']
                                                    as Timestamp)
                                                .millisecondsSinceEpoch)
                                        .add(Duration(days: index))))!
                            .whenComplete(() {
                          getDefinationData();
                          getCustomDefinationData();
                        });
                      } else {
                        Get.to(ExamEntries(
                                originalDocument: documentData,
                                defineDocument: definedCourseData,
                                currentDate:
                                    DateTime.fromMillisecondsSinceEpoch(
                                            ((documentData.data()
                                                        as Map)['startDate']
                                                    as Timestamp)
                                                .millisecondsSinceEpoch)
                                        .add(Duration(days: index))))!
                            .whenComplete(() {
                          getDefinationData();
                          getCustomDefinationData();
                        });
                      }
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd MMM').format(((documentData.data()
                                    as Map)['startDate'] as Timestamp)
                                .toDate()
                                .add(Duration(days: index))),
                            style: GoogleFonts.poppins(
                                color: textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade300),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              getNumberOfRecordAvailable(((documentData.data()
                                          as Map)['startDate'] as Timestamp)
                                      .toDate()
                                      .add(Duration(days: index)))
                                  .toString(),
                              style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      !(getCurrentDayActivity(((documentData.data()
                                              as Map)['startDate'] as Timestamp)
                                          .toDate()
                                          .add(Duration(days: index)))
                                      .toString() ==
                                  'Data Entry' ||
                              getCurrentDayActivity(
                                          DateTime.fromMillisecondsSinceEpoch(
                                                  ((documentData.data() as Map)[
                                                              'startDate']
                                                          as Timestamp)
                                                      .millisecondsSinceEpoch)
                                              .add(Duration(days: index)))
                                      .toString() ==
                                  'Empty')
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade300),
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              child: AutoSizeText(
                                getCurrentDayActivity(
                                        DateTime.fromMillisecondsSinceEpoch(
                                                ((documentData.data()
                                                            as Map)['startDate']
                                                        as Timestamp)
                                                    .millisecondsSinceEpoch)
                                            .add(Duration(days: index)))
                                    .toString(),
                                maxLines: 1,
                                style: GoogleFonts.poppins(
                                    color: textColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              );
            });
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: MediaQuery.of(context).size.height * 0.18),
        ),
      ),
    ));
  }
}
