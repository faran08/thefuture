// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../globals.dart';

class AdminStateControllers extends GetxController {
  CollectionReference definedCourses =
      FirebaseFirestore.instance.collection('definedCourses');
  ListView definedCoursesNames = ListView();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CollectionReference subjects =
      FirebaseFirestore.instance.collection('Subjects');
  Widget adminName = SpinKitThreeBounce(
    color: buttonColor,
  );
  ListView subjectNames = ListView();
  List<String> allSubjectNames = [];
  List<SelectedListItem> selectedListItems = [];

  void getSubjectNames() async {
    var allSubjectsListTile = [];
    allSubjectNames.clear();
    selectedListItems.clear();
    subjects.get().then((value) {
      for (var element in value.docs) {
        allSubjectNames.add((element.data() as Map)['subjectName'].toString());
        selectedListItems.add(SelectedListItem(
            false, (element.data() as Map)['subjectName'].toString()));
        allSubjectsListTile.add(ListTile(
          title: Text(
            (element.data() as Map)['subjectName'],
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Added by ' + (element.data() as Map)['addedBy']),
              (element.data() as Map).containsKey('subTags')
                  ? Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      height: 50,
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: 25, crossAxisCount: 3),
                          itemCount:
                              ((element.data() as Map)['subTags'] as List)
                                  .length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(3, 3, 0, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade300,
                              ),
                              padding: EdgeInsets.all(3),
                              child: Center(
                                child: AutoSizeText(
                                  (element.data() as Map)['subTags'][index],
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                            );
                          }),
                    )
                  : Container()
            ],
          ),
          trailing: TextButton(
            onPressed: () {
              Get.bottomSheet(BottomSheet(
                  onClosing: () {},
                  builder: ((context) {
                    TextEditingController _tagController =
                        TextEditingController();
                    return Container(
                      color: backGroundColor,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          children: [
                            Text(
                              'Enter Tag',
                              style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                              child: TextFormField(
                                expands: false,
                                controller: _tagController,
                                maxLength: 50,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: buttonColor,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: buttonColor),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: buttonColor),
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ),
                            TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {
                                  EasyLoading.show();
                                  subjects.doc(element.id).update({
                                    'subTags': FieldValue.arrayUnion(
                                        [_tagController.text])
                                  }).then((value) {
                                    EasyLoading.dismiss();
                                    Get.close(1);
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
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: textColor,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Add Tag',
                                        style: TextStyle(color: textColor),
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    );
                  })));
            },
            style: TextButton.styleFrom(backgroundColor: Colors.grey.shade300),
            child: Text(
              'Add Tags',
              style: TextStyle(color: textColor),
            ),
          ),
        ));
      }
      subjectNames = ListView.builder(
          itemCount: allSubjectsListTile.length,
          itemBuilder: ((context, index) {
            return allSubjectsListTile[index];
          }));
      update();
    });
  }

  void getDefinedCourses() async {
    var definedCoursesListTile = [];
    definedCourses
        .where('finalExamDate', isGreaterThan: DateTime.now())
        .get()
        .then((value) {
      for (var element in value.docs) {
        definedCoursesListTile.add(ListTile(
            onLongPress: () {
              Get.bottomSheet(BottomSheet(
                  onClosing: () {},
                  builder: (_) {
                    return SizedBox(
                      height: 200,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Center(
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  shadowColor: backGroundColor,
                                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20)),
                              onPressed: () {
                                Get.defaultDialog(
                                    contentPadding: EdgeInsets.all(30),
                                    title: 'Warning',
                                    middleText:
                                        'Are you sure? You can only delete if no courses are designed using this course.',
                                    backgroundColor: backGroundColor,
                                    onConfirm: () {
                                      definedCourses
                                          .doc(element.id)
                                          .delete()
                                          .then((value) {
                                        Get.back(closeOverlays: true);
                                        Get.snackbar(
                                            "Message", 'Course Deleted',
                                            backgroundColor: Colors.white);
                                        update();
                                      });
                                    },
                                    onCancel: (() => Get.back()));
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Icon(
                                      FontAwesomeIcons.remove,
                                      color: textColor,
                                      size: 25,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: AutoSizeText(
                                      'Delete',
                                      minFontSize: 20,
                                      style: GoogleFonts.poppins(
                                          color: textColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    );
                  }));
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
                Text('Created by ' + (element.data() as Map)['createdBy']),
                Text('Created on ' +
                    DateFormat('dd MMM yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            ((element.data() as Map)['createdOn'] as Timestamp)
                                .millisecondsSinceEpoch))),
              ],
            )));
      }
      definedCoursesNames = ListView.builder(
          itemCount: definedCoursesListTile.length,
          itemBuilder: ((context, index) {
            return definedCoursesListTile[index];
          }));
      update();
    });
  }

  void updateAdminName(String documentID) async {
    users.doc(documentID).get().then((value) {
      adminName = Text(
        'Welcome, ${(value.data() as Map)['userName']} !',
        style: GoogleFonts.poppins(
            fontSize: 20, color: textColor, fontWeight: FontWeight.bold),
      );
      update();
    });
  }
}
