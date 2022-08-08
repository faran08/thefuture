// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thefuture/AdminFiles/StateControllers.dart';
import 'package:thefuture/globals.dart';

class AddNewCourse extends StatelessWidget {
  AddNewCourse({Key? key}) : super(key: key);

  TextEditingController selectSubjectController = TextEditingController();
  TextEditingController courseInstructions = TextEditingController();
  TextEditingController courseStartDate = TextEditingController();
  TextEditingController firstSessionalDate = TextEditingController();
  TextEditingController midTermDate = TextEditingController();
  TextEditingController secondSessionalDate = TextEditingController();
  TextEditingController finalExamDate = TextEditingController();
  late DateTime _courseStartDate;
  late DateTime _firstSessionalDate;
  late DateTime _midTermDate;
  late DateTime _secondSessionalDate;
  late DateTime _finalExamDate;
  AdminStateControllers adminStateControllers =
      Get.put(AdminStateControllers());
  GlobalKey<FormState> formKey = GlobalKey();

  CollectionReference definedCourses =
      FirebaseFirestore.instance.collection('definedCourses');

  bool _validateForm() {
    FormState form = formKey.currentState!;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    adminStateControllers.getSubjectNames();
    var fToast = FToast();
    fToast.init(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Define New Course',
          style: GoogleFonts.poppins(
              color: textColor, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: backGroundColor,
      ),
      backgroundColor: backGroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 2),
          child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      'Select Subject For Course',
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please select some subject';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: selectSubjectController,
                    readOnly: true,
                    maxLines: 1,
                    onTap: (() {
                      DropDownState(
                        DropDown(
                          searchHintText: 'Find Subjects',
                          bottomSheetTitle: 'Available Subjects',
                          searchBackgroundColor: backGroundColor,
                          dataList: adminStateControllers.selectedListItems,
                          selectedItem: (String selected) {
                            selectSubjectController.text = selected;
                          },
                          enableMultipleSelection: false,
                          searchController: selectSubjectController,
                        ),
                      ).showModal(context);
                    }),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.book_outlined,
                          color: textColor,
                        ),
                        filled: true,
                        fillColor: buttonColor,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: buttonColor),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: buttonColor),
                            borderRadius: BorderRadius.circular(10))),
                  ),

                  /////FIELD/////
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      'Course Start Date',
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cannot be Empty';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: courseStartDate,
                    readOnly: true,
                    maxLines: 1,
                    onTap: (() async {
                      showCalendarDatePicker2Dialog(
                        context: context,
                        config: CalendarDatePicker2WithActionButtonsConfig(
                            firstDate: DateTime.now(),
                            shouldCloseDialogAfterCancelTapped: true),
                        dialogSize: const Size(325, 400),
                        initialValue: [DateTime.now()],
                        borderRadius: 15,
                      ).then((value) {
                        if (value != null) {
                          _courseStartDate = value.first!;
                          courseStartDate.text =
                              DateFormat('dd MMM yyyy').format(value.first!);
                        }
                      });
                    }),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.start_rounded,
                          color: textColor,
                        ),
                        filled: true,
                        fillColor: buttonColor,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: buttonColor),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: buttonColor),
                            borderRadius: BorderRadius.circular(10))),
                  )
                  /////FIELD/////
                  ,
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      'First Sessional Date',
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cannot be Empty';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: firstSessionalDate,
                    readOnly: true,
                    maxLines: 1,
                    onTap: (() async {
                      showCalendarDatePicker2Dialog(
                        context: context,
                        config: CalendarDatePicker2WithActionButtonsConfig(
                            firstDate: DateTime.now(),
                            shouldCloseDialogAfterCancelTapped: true),
                        dialogSize: const Size(325, 400),
                        initialValue: [DateTime.now()],
                        borderRadius: 15,
                      ).then((value) {
                        if (value != null) {
                          _firstSessionalDate = value.first!;
                          firstSessionalDate.text =
                              DateFormat('dd MMM yyyy').format(value.first!);
                        }
                      });
                    }),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.article_rounded,
                          color: textColor,
                        ),
                        filled: true,
                        fillColor: buttonColor,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: buttonColor),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: buttonColor),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      'Mid Terms Date',
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cannot be Empty';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: midTermDate,
                    readOnly: true,
                    maxLines: 1,
                    onTap: (() async {
                      showCalendarDatePicker2Dialog(
                        context: context,
                        config: CalendarDatePicker2WithActionButtonsConfig(
                            firstDate: DateTime.now(),
                            shouldCloseDialogAfterCancelTapped: true),
                        dialogSize: const Size(325, 400),
                        initialValue: [DateTime.now()],
                        borderRadius: 15,
                      ).then((value) {
                        if (value != null) {
                          _midTermDate = value.first!;
                          midTermDate.text =
                              DateFormat('dd MMM yyyy').format(value.first!);
                        }
                      });
                    }),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.hourglass_bottom_rounded,
                          color: textColor,
                        ),
                        filled: true,
                        fillColor: buttonColor,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: buttonColor),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: buttonColor),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      'Second Sessional Date',
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cannot be Empty';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: secondSessionalDate,
                    readOnly: true,
                    maxLines: 1,
                    onTap: (() async {
                      showCalendarDatePicker2Dialog(
                        context: context,
                        config: CalendarDatePicker2WithActionButtonsConfig(
                            firstDate: DateTime.now(),
                            shouldCloseDialogAfterCancelTapped: true),
                        dialogSize: const Size(325, 400),
                        initialValue: [DateTime.now()],
                        borderRadius: 15,
                      ).then((value) {
                        if (value != null) {
                          _secondSessionalDate = value.first!;
                          secondSessionalDate.text =
                              DateFormat('dd MMM yyyy').format(value.first!);
                        }
                      });
                    }),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.article_rounded,
                          color: textColor,
                        ),
                        filled: true,
                        fillColor: buttonColor,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: buttonColor),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: buttonColor),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      'Final Exam Date',
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cannot be Empty';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: finalExamDate,
                    readOnly: true,
                    maxLines: 1,
                    onTap: (() async {
                      showCalendarDatePicker2Dialog(
                        context: context,
                        config: CalendarDatePicker2WithActionButtonsConfig(
                            firstDate: DateTime.now(),
                            shouldCloseDialogAfterCancelTapped: true),
                        dialogSize: const Size(325, 400),
                        initialValue: [DateTime.now()],
                        borderRadius: 15,
                      ).then((value) {
                        if (value != null) {
                          _finalExamDate = value.first!;
                          finalExamDate.text =
                              DateFormat('dd MMM yyyy').format(value.first!);
                        }
                      });
                    }),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.done_all_rounded,
                          color: textColor,
                        ),
                        filled: true,
                        fillColor: buttonColor,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: buttonColor),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: buttonColor),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      'Course Instructions (if any)',
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: courseInstructions,
                    maxLines: 5,
                    maxLength: 500,
                    onTap: (() async {}),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: buttonColor,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: buttonColor),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: buttonColor),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                            if (_validateForm()) {
                              EasyLoading.show();
                              definedCourses.add({
                                'createdOn': DateTime.now(),
                                'createdBy': globalUserName,
                                'courseName': selectSubjectController.text,
                                'startDate': _courseStartDate,
                                'firstSessionalDate': _firstSessionalDate,
                                'midTermDate': _midTermDate,
                                'secondSessionalDate': _secondSessionalDate,
                                'finalExamDate': _finalExamDate,
                                'instructions': courseInstructions.text
                              }).then((value) {
                                fToast.showToast(
                                    child: getToast(
                                        JelloIn(
                                            child:
                                                Icon(FontAwesomeIcons.check)),
                                        'Course Defined Successfully'));
                                EasyLoading.dismiss();
                                Get.back();
                              }).onError((error, stackTrace) {
                                Fluttertoast.showToast(
                                    msg: 'Error: $error',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                              });
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Icon(
                                  FontAwesomeIcons.save,
                                  color: textColor,
                                  size: 25,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: AutoSizeText(
                                  'Save',
                                  minFontSize: 20,
                                  style: GoogleFonts.poppins(
                                      color: textColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          )),
                    ),
                  )
                ],
              )),
        ),
      ),
    ));
  }
}
