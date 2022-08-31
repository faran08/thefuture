// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thefuture/StudentFiles/DayView.dart';
import 'package:thefuture/StudentFiles/StudentController.dart';
import 'package:thefuture/StudentFiles/TakeExam.dart';
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
  CollectionReference definedCourses =
      FirebaseFirestore.instance.collection('definedCourses');
  CollectionReference examResults =
      FirebaseFirestore.instance.collection('ExamResults');
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

  DateTime getLastHourToday() {
    return DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 24);
  }

  DateTime getLastHourOfDate(DateTime input) {
    return DateTime(input.year, input.month, input.day, 24);
  }

  DateTime getFirstHourOfDate(DateTime input) {
    return DateTime(input.year, input.month, input.day, 0);
  }

  DateTime getFirstHourToday() {
    return DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0);
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
              'Exam',
              overflow: TextOverflow.ellipsis,
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
                return studentController.courseOverView_DesignCourse_initialized
                    ? Text(
                        (studentController.courseOverView_DefineCourse.data()
                            as Map)['courseName'],
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )
                    : const Text('Loading...');
              }),
              actions: [
                IconButton(
                    onPressed: () {
                      examResults
                          .where('studentID', isEqualTo: globalUserName)
                          .where('defineID', isEqualTo: defineID)
                          .get()
                          .then((value) {
                        Get.bottomSheet(
                            BottomSheet(
                                enableDrag: false,
                                clipBehavior: Clip.antiAlias,
                                onClosing: () {},
                                builder: ((BuildContext context) {
                                  return Container(
                                      decoration:
                                          BoxDecoration(color: backGroundColor),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.9,
                                      width: MediaQuery.of(context).size.width,
                                      child: Scaffold(
                                        appBar: AppBar(
                                          backgroundColor: backGroundColor,
                                          elevation: 0,
                                          title: Icon(
                                            Icons.linear_scale_outlined,
                                            color: textColor,
                                          ),
                                          centerTitle: true,
                                          leading: Container(),
                                        ),
                                        backgroundColor: backGroundColor,
                                        body: ListView.builder(
                                            itemCount: value.docs.length,
                                            itemBuilder: ((context, index) {
                                              return ListTile(
                                                title: Text(
                                                  'Marks Obtained:-     ${value.docs[index]['correctAnswers']} / ${value.docs[index]['resultData'].length}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Text(
                                                    'Exam conducted on ${(value.docs[index]['examDate'] as Timestamp).toDate()}'),
                                              );
                                            })),
                                      ));
                                })),
                            clipBehavior: Clip.antiAlias,
                            ignoreSafeArea: true,
                            isScrollControlled: true,
                            enableDrag: false);
                      });
                    },
                    icon: Icon(
                      Icons.school_rounded,
                      color: textColor,
                    )),
                IconButton(
                    onPressed: () {
                      definedCourses.doc(defineID).get().then((element) {
                        Get.bottomSheet(
                            BottomSheet(
                                enableDrag: false,
                                clipBehavior: Clip.antiAlias,
                                onClosing: () {},
                                builder: ((BuildContext context) {
                                  return Container(
                                      decoration:
                                          BoxDecoration(color: backGroundColor),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.9,
                                      width: MediaQuery.of(context).size.width,
                                      child: Scaffold(
                                        appBar: AppBar(
                                          backgroundColor: backGroundColor,
                                          elevation: 0,
                                          title: Icon(
                                            Icons.linear_scale_outlined,
                                            color: textColor,
                                          ),
                                          centerTitle: true,
                                          leading: Container(),
                                        ),
                                        backgroundColor: backGroundColor,
                                        body: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Icon(
                                                        Icons.book_outlined,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 0, 0),
                                                      child: Text(
                                                        'Course Details',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: textColor
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          40, 10, 0, 10),
                                                  child: Text(
                                                    (element.data()
                                                        as Map)['courseName'],
                                                    style: GoogleFonts.poppins(
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 22),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Icon(
                                                        Icons.person,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 0, 0),
                                                      child: Text(
                                                        'Created By',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: textColor
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          40, 0, 0, 10),
                                                  child: Text(
                                                    (element.data()
                                                        as Map)['createdBy'],
                                                    style: GoogleFonts.poppins(
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Icon(
                                                        Icons.start_rounded,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 0, 0),
                                                      child: Text(
                                                        'Course Start Date',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: textColor
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          40, 0, 0, 10),
                                                  child: Text(
                                                    DateFormat('dd MMM yyyy').format(
                                                        DateTime.fromMillisecondsSinceEpoch(((element
                                                                            .data()
                                                                        as Map)[
                                                                    'startDate']
                                                                as Timestamp)
                                                            .millisecondsSinceEpoch)),
                                                    style: GoogleFonts.poppins(
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Icon(
                                                        Icons.article_rounded,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 0, 0),
                                                      child: Text(
                                                        'First Sessional Date',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: textColor
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          40, 0, 0, 10),
                                                  child: Text(
                                                    DateFormat('dd MMM yyyy').format(
                                                        DateTime.fromMillisecondsSinceEpoch(((element
                                                                            .data()
                                                                        as Map)[
                                                                    'firstSessionalDate']
                                                                as Timestamp)
                                                            .millisecondsSinceEpoch)),
                                                    style: GoogleFonts.poppins(
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Icon(
                                                        Icons
                                                            .hourglass_bottom_rounded,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 0, 0),
                                                      child: Text(
                                                        'Mid Term Date',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: textColor
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          40, 0, 0, 10),
                                                  child: Text(
                                                    DateFormat('dd MMM yyyy').format(
                                                        DateTime.fromMillisecondsSinceEpoch(((element
                                                                            .data()
                                                                        as Map)[
                                                                    'midTermDate']
                                                                as Timestamp)
                                                            .millisecondsSinceEpoch)),
                                                    style: GoogleFonts.poppins(
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Icon(
                                                        Icons.article_rounded,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 0, 0),
                                                      child: Text(
                                                        'Second Sessional Date',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: textColor
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          40, 0, 0, 10),
                                                  child: Text(
                                                    DateFormat('dd MMM yyyy').format(
                                                        DateTime.fromMillisecondsSinceEpoch(((element
                                                                            .data()
                                                                        as Map)[
                                                                    'secondSessionalDate']
                                                                as Timestamp)
                                                            .millisecondsSinceEpoch)),
                                                    style: GoogleFonts.poppins(
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Icon(
                                                        Icons.done_all_rounded,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 0, 0),
                                                      child: Text(
                                                        'Final Exam',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: textColor
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          40, 0, 0, 10),
                                                  child: Text(
                                                    DateFormat('dd MMM yyyy').format(
                                                        DateTime.fromMillisecondsSinceEpoch(((element
                                                                            .data()
                                                                        as Map)[
                                                                    'finalExamDate']
                                                                as Timestamp)
                                                            .millisecondsSinceEpoch)),
                                                    style: GoogleFonts.poppins(
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Icon(
                                                        Icons.info,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 0, 0),
                                                      child: Text(
                                                        'Instructions',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: textColor
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          40, 0, 0, 10),
                                                  child: Text(
                                                    (element.data()
                                                        as Map)['instructions'],
                                                    style: GoogleFonts.poppins(
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                                })),
                            clipBehavior: Clip.antiAlias,
                            ignoreSafeArea: true,
                            isScrollControlled: true,
                            enableDrag: false);
                      });
                    },
                    icon: Icon(
                      Icons.info,
                      color: textColor,
                    )),
              ],
            ),
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
                                                Get.bottomSheet(
                                                    BottomSheet(
                                                        enableDrag: false,
                                                        onClosing: () {},
                                                        builder: (context) {
                                                          return SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.95,
                                                            child: Scaffold(
                                                              backgroundColor:
                                                                  backGroundColor,
                                                              appBar: AppBar(
                                                                backgroundColor:
                                                                    backGroundColor,
                                                                elevation: 0,
                                                                title: Text(
                                                                  'Warning',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          25),
                                                                ),
                                                              ),
                                                              body: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            10,
                                                                            10,
                                                                            10),
                                                                child: Column(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Text(
                                                                          'Please carefully read below before proceeding.',
                                                                          style:
                                                                              GoogleFonts.openSans(
                                                                            color:
                                                                                textColor,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                        ),
                                                                        Text(
                                                                          '1. You will not be able to quit once the exam has started.',
                                                                          style:
                                                                              GoogleFonts.openSans(
                                                                            color:
                                                                                textColor,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                        ),
                                                                        Text(
                                                                          '2. Make sure you have working internet connection. College will not entertain any follow up requests due to your lose connection.',
                                                                          style:
                                                                              GoogleFonts.openSans(
                                                                            color:
                                                                                textColor,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                        ),
                                                                        Text(
                                                                          '3. Make sure not to disconnect/ exit the app due to exam pressure, it will automatically result in zero marks.',
                                                                          style:
                                                                              GoogleFonts.openSans(
                                                                            color:
                                                                                textColor,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                        ),
                                                                        Text(
                                                                          '4. Start the exam at your own comfort, you have complete day to start its attemp.',
                                                                          style:
                                                                              GoogleFonts.openSans(
                                                                            color:
                                                                                textColor,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                        ),
                                                                        Text(
                                                                          '5. Remember to submit the exam. If not submitted it will result in zero marks.',
                                                                          style:
                                                                              GoogleFonts.openSans(
                                                                            color:
                                                                                textColor,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    TextButton(
                                                                        style: TextButton.styleFrom(
                                                                            backgroundColor:
                                                                                buttonColor,
                                                                            elevation:
                                                                                2,
                                                                            shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                    10)),
                                                                            shadowColor:
                                                                                backGroundColor,
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                10,
                                                                                10,
                                                                                10,
                                                                                10)),
                                                                        onPressed:
                                                                            () {
                                                                          EasyLoading
                                                                              .show();
                                                                          Get.close(
                                                                              1);
                                                                          if (!(((studentController.courseOverView_DefineCourse.data() as Map)['startDate']) as Timestamp)
                                                                              .toDate()
                                                                              .add(Duration(days: index))
                                                                              .isAfter(getLastHourToday())) {
                                                                            examResults.where('studentID', isEqualTo: globalUserName).where('defineID', isEqualTo: defineID).where('examDate', isGreaterThanOrEqualTo: getFirstHourOfDate((((studentController.courseOverView_DefineCourse.data() as Map)['startDate']) as Timestamp).toDate().add(Duration(days: index)))).where('examDate', isLessThanOrEqualTo: getLastHourOfDate((((studentController.courseOverView_DefineCourse.data() as Map)['startDate']) as Timestamp).toDate().add(Duration(days: index)))).get().then((value) {
                                                                              if (value.docs.isEmpty) {
                                                                                EasyLoading.dismiss();
                                                                                Get.to(TakeExam(
                                                                                  defineID: defineID,
                                                                                  designID: designID,
                                                                                  examDate: DateTime.fromMillisecondsSinceEpoch((((studentController.courseOverView_DefineCourse.data() as Map)['startDate']) as Timestamp).millisecondsSinceEpoch).add(
                                                                                    Duration(days: index),
                                                                                  ),
                                                                                ));
                                                                              } else {
                                                                                EasyLoading.dismiss();
                                                                                Fluttertoast.showToast(msg: 'Cannot attempt twice', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.grey, textColor: Colors.black, fontSize: 16.0);
                                                                                // var fToast = FToast();
                                                                                // fToast.init(context);
                                                                                // fToast.showToast(child: getToast(JelloIn(child: Icon(FontAwesomeIcons.cancel)), 'Cannot attempt twice'));
                                                                              }
                                                                            });
                                                                          } else {
                                                                            EasyLoading.dismiss();
                                                                            var fToast =
                                                                                FToast();
                                                                            fToast.init(context);
                                                                            fToast.showToast(child: getToast(JelloIn(child: Icon(FontAwesomeIcons.cancel)), 'Exam date has passed'));
                                                                          }
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
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
                                                                              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                                                              child: AutoSizeText(
                                                                                'Agreed. Attemp!',
                                                                                minFontSize: 20,
                                                                                style: GoogleFonts.poppins(color: textColor, fontWeight: FontWeight.w600),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        )),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              20,
                                                                              0,
                                                                              0),
                                                                      child: TextButton(
                                                                          style: TextButton.styleFrom(backgroundColor: buttonColor, elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), shadowColor: backGroundColor, padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                                                                          onPressed: () {
                                                                            Get.close(1);
                                                                          },
                                                                          child: Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                                                child: Icon(
                                                                                  Icons.cancel,
                                                                                  color: Colors.red,
                                                                                  size: 30,
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                                                                child: AutoSizeText(
                                                                                  'Reconsider',
                                                                                  minFontSize: 20,
                                                                                  style: GoogleFonts.poppins(color: textColor, fontWeight: FontWeight.w600),
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
                                            // Padding(
                                            //   padding: EdgeInsets.fromLTRB(
                                            //       10, 0, 0, 0),
                                            //   child: Icon(
                                            //     Icons.calendar_month_rounded,
                                            //     color: textColor,
                                            //   ),
                                            // )
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
