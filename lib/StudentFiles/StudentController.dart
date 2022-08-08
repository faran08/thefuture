import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thefuture/globals.dart';

class StudentController extends GetxController {
  ListView definedCoursesNames = ListView();
  CollectionReference definedCourses =
      FirebaseFirestore.instance.collection('definedCourses');

  void getDefinedCourses() async {
    var definedCoursesListTile = [];

    definedCourses
        .where('startDate', isGreaterThan: DateTime.now())
        .get()
        .then((value) {
      for (var element in value.docs) {
        definedCoursesListTile.add(ListTile(
            onTap: () {
              Get.bottomSheet(
                  BottomSheet(
                      enableDrag: false,
                      clipBehavior: Clip.antiAlias,
                      onClosing: () {},
                      builder: ((BuildContext context) {
                        return Container(
                            decoration: BoxDecoration(color: backGroundColor),
                            height: MediaQuery.of(context).size.height * 0.9,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.book_outlined,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Course Details',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 10, 0, 10),
                                        child: Text(
                                          (element.data() as Map)['courseName'],
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.person,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Created By',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 0, 0, 10),
                                        child: Text(
                                          (element.data() as Map)['createdBy'],
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.start_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Course Start Date',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 0, 0, 10),
                                        child: Text(
                                          DateFormat('dd MMM yyyy').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  ((element.data() as Map)[
                                                              'startDate']
                                                          as Timestamp)
                                                      .millisecondsSinceEpoch)),
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.article_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'First Sessional Date',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 0, 0, 10),
                                        child: Text(
                                          DateFormat('dd MMM yyyy').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  ((element.data() as Map)[
                                                              'firstSessionalDate']
                                                          as Timestamp)
                                                      .millisecondsSinceEpoch)),
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.hourglass_bottom_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Mid Term Date',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 0, 0, 10),
                                        child: Text(
                                          DateFormat('dd MMM yyyy').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  ((element.data() as Map)[
                                                              'midTermDate']
                                                          as Timestamp)
                                                      .millisecondsSinceEpoch)),
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.article_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Second Sessional Date',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 0, 0, 10),
                                        child: Text(
                                          DateFormat('dd MMM yyyy').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  ((element.data() as Map)[
                                                              'secondSessionalDate']
                                                          as Timestamp)
                                                      .millisecondsSinceEpoch)),
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.done_all_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Final Exam',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 0, 0, 10),
                                        child: Text(
                                          DateFormat('dd MMM yyyy').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  ((element.data() as Map)[
                                                              'finalExamDate']
                                                          as Timestamp)
                                                      .millisecondsSinceEpoch)),
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.info,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Instructions',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 0, 0, 10),
                                        child: Text(
                                          (element.data()
                                              as Map)['instructions'],
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 20),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor: buttonColor,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  shadowColor: backGroundColor),
                                              onPressed: () {},
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.done_rounded,
                                                    color: textColor,
                                                    size: 15,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(20, 0, 10, 0),
                                                    child: AutoSizeText(
                                                      'Join Course',
                                                      minFontSize: 15,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: textColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ),
                                      )
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
            },
            title: Text(
              (element.data() as Map)['courseName'],
              style: GoogleFonts.poppins(
                  color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Created on ${DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(((element.data() as Map)['createdOn'] as Timestamp).millisecondsSinceEpoch))}'),
              ],
            )));
      }
      EasyLoading.dismiss();
      definedCoursesNames = ListView.builder(
          itemCount: definedCoursesListTile.length,
          itemBuilder: ((context, index) {
            return definedCoursesListTile[index];
          }));
      update();
    });
  }
}
