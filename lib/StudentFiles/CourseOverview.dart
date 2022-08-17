// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thefuture/StudentFiles/DayView.dart';
import 'package:thefuture/StudentFiles/StudentController.dart';
import 'package:timelines/timelines.dart';

import '../globals.dart';

class CourseOverView extends StatelessWidget {
  String designID = '';
  String parentID = '';
  String defineID = '';
  CourseOverView(
      {Key? key,
      required this.designID,
      required this.parentID,
      required this.defineID})
      : super(key: key);
  CollectionReference entries =
      FirebaseFirestore.instance.collection('Entries');
  StudentController studentController = Get.put(StudentController());
  ScrollController scrollController = ScrollController();
  bool checkIfExam(DateTime inputDate) {
    int articleURL = 0;
    int audioURL = 0;
    int videoURL = 0;
    int examQuestions = 0;

    for (var element in studentController.courseOverView_DesignCourse.docs) {
      if (DateTime.fromMillisecondsSinceEpoch(
                  ((element.data() as Map)['dateForWhichURL'] as Timestamp)
                      .millisecondsSinceEpoch)
              .day ==
          inputDate.day) {
        if ((element.data() as Map)['entryType'] == 'Article') {
          articleURL++;
        } else if (((element.data() as Map)['entryType'] == 'Video')) {
          videoURL++;
        } else if (((element.data() as Map)['entryType'] == 'Audio')) {
          audioURL++;
        } else if (((element.data() as Map)['entryType'] == 'Exam')) {
          examQuestions++;
        }
      }
    }
    if (examQuestions > 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget getContentData(DateTime inputDate) {
    int articleURL = 0;
    int audioURL = 0;
    int videoURL = 0;
    int examQuestions = 0;

    for (var element in studentController.courseOverView_DesignCourse.docs) {
      if (DateTime.fromMillisecondsSinceEpoch(
                  ((element.data() as Map)['dateForWhichURL'] as Timestamp)
                      .millisecondsSinceEpoch)
              .day ==
          inputDate.day) {
        if ((element.data() as Map)['entryType'] == 'Article') {
          articleURL++;
        } else if (((element.data() as Map)['entryType'] == 'Video')) {
          videoURL++;
        } else if (((element.data() as Map)['entryType'] == 'Audio')) {
          audioURL++;
        } else if (((element.data() as Map)['entryType'] == 'Exam')) {
          examQuestions++;
        }
      }
    }
    if (examQuestions > 0) {
      return Row(
        children: [
          Icon(
            Icons.tungsten_outlined,
            color: textColor,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Text(
              'Take Exam',
              style: GoogleFonts.poppins(
                  color: textColor, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Icon(
                Icons.article_rounded,
                color: textColor,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text('$articleURL',
                    style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
          Column(
            children: [
              Icon(
                Icons.audio_file_rounded,
                color: Colors.blue.shade800,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text('$audioURL',
                    style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
          Column(
            children: [
              Icon(
                Icons.video_collection_rounded,
                color: Colors.green.shade800,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text('$videoURL',
                    style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ],
      );
      //  'Articles : $articleURL\nAudios  : $audioURL\nVideos  : $videoURL';
    }
  }

  @override
  Widget build(BuildContext context) {
    studentController.getCourseDetails(designID, defineID);

    return SafeArea(
        child: Scaffold(
            backgroundColor: backGroundColor,
            appBar: AppBar(
                leadingWidth: 0,
                leading: Container(),
                centerTitle: true,
                elevation: 0,
                backgroundColor: backGroundColor,
                title: GetBuilder<StudentController>(builder: (_) {
                  return studentController
                          .courseOverView_DesignCourse_initialized
                      ? Text(
                          (studentController.courseOverView_DefineCourse.data()
                              as Map)['courseName'],
                          style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )
                      : const Text('Loading...');
                })),
            body: GetBuilder<StudentController>(builder: (_) {
              return studentController.courseOverView_DesignCourse_initialized
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: GetBuilder<StudentController>(builder: (_) {
                        return Timeline.tileBuilder(
                          controller: scrollController,
                          theme: TimelineThemeData(
                            color: textColor,
                          ),
                          builder: TimelineTileBuilder.fromStyle(
                            oppositeContentsBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DateTime.fromMillisecondsSinceEpoch(
                                                  (((studentController
                                                              .courseOverView_DefineCourse
                                                              .data() as Map)[
                                                          'startDate']) as Timestamp)
                                                      .millisecondsSinceEpoch)
                                              .add(Duration(days: index))
                                              .day <=
                                          DateTime.now().day
                                      ? Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              if (checkIfExam(DateTime.fromMillisecondsSinceEpoch(
                                                          (((studentController
                                                                          .courseOverView_DefineCourse
                                                                          .data()
                                                                      as Map)['startDate'])
                                                                  as Timestamp)
                                                              .millisecondsSinceEpoch)
                                                      .add(Duration(
                                                          days: index))) ==
                                                  true) {
                                                // Get.to(TakeExam());
                                              } else {
                                                Get.to(DayView(
                                                  heading: DateTime.fromMillisecondsSinceEpoch(
                                                          (((studentController
                                                                          .courseOverView_DefineCourse
                                                                          .data()
                                                                      as Map)['startDate'])
                                                                  as Timestamp)
                                                              .millisecondsSinceEpoch)
                                                      .add(Duration(
                                                          days: index)),
                                                  inputDocument: studentController
                                                      .courseOverView_DesignCourse,
                                                ));
                                              }
                                              ;
                                            },
                                            splashColor: Colors.grey.shade200,
                                            child: getContentData(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        (((studentController
                                                                            .courseOverView_DefineCourse
                                                                            .data()
                                                                        as Map)[
                                                                    'startDate'])
                                                                as Timestamp)
                                                            .millisecondsSinceEpoch)
                                                .add(Duration(days: index))),
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            Icon(
                                              Icons.visibility_off_rounded,
                                              color: textColor,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              child: Text('Unavailable'),
                                            )
                                          ],
                                        ),
                                ),
                              );
                              //Check Tomorrow
                              // if (DateTime.fromMillisecondsSinceEpoch(
                              //         (((studentController.courseOverView_DefineCourse.data()
                              //                 as Map)['startDate']) as Timestamp)
                              //             .millisecondsSinceEpoch)
                              //     .add(Duration(days: index))
                              //     .day
                              //     .isEqual((DateTime.fromMillisecondsSinceEpoch(
                              //             (((studentController.courseOverView_DefineCourse
                              //                         .data() as Map)['firstSessionalDate'])
                              //                     as Timestamp)
                              //                 .millisecondsSinceEpoch))
                              //         .day)) {
                              //   return Padding(
                              //     padding: EdgeInsets.all(24.0),
                              //     child: Container(
                              //       padding: EdgeInsets.all(10),
                              //       decoration: BoxDecoration(
                              //           color: Colors.white,
                              //           borderRadius: BorderRadius.circular(10)),
                              //       child: Text(
                              //         'Take Exam',
                              //         style: GoogleFonts.poppins(
                              //             color: textColor,
                              //             fontSize: 18,
                              //             fontWeight: FontWeight.bold),
                              //       ),
                              //     ),
                              //   );
                              // } else {

                              // }
                            },
                            indicatorStyle: IndicatorStyle.outlined,
                            contentsAlign: ContentsAlign.alternating,
                            contentsBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Text(
                                    DateFormat('dd MMM yyyy').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                                (((studentController
                                                            .courseOverView_DefineCourse
                                                            .data() as Map)[
                                                        'startDate']) as Timestamp)
                                                    .millisecondsSinceEpoch)
                                            .add(Duration(days: index))),
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ));
                            },
                            itemCount: DateTime.fromMillisecondsSinceEpoch(
                                        (((studentController
                                                    .courseOverView_DefineCourse
                                                    .data() as Map)[
                                                'finalExamDate']) as Timestamp)
                                            .millisecondsSinceEpoch)
                                    .difference(DateTime.fromMillisecondsSinceEpoch(
                                        (((studentController
                                                    .courseOverView_DefineCourse
                                                    .data() as Map)[
                                                'startDate']) as Timestamp)
                                            .millisecondsSinceEpoch))
                                    .inDays +
                                2,
                          ),
                        );
                      }),
                    )
                  : Text('Loading');
            })));
  }
}
