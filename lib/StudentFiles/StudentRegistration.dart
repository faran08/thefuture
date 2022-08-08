// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefuture/globals.dart';

import '../AdminFiles/StateControllers.dart';
import '../LoginFiles/StateControllers/StudentNameController.dart';

class StudentRegistration extends StatelessWidget {
  StudentRegistration({Key? key}) : super(key: key);

  GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _registrationID = TextEditingController();
  final TextEditingController _homeAddress = TextEditingController();
  final TextEditingController _passWord = TextEditingController();
  TextEditingController subjectName = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  AdminStateControllers adminStateControllers =
      Get.put(AdminStateControllers());

  StudentNameController studentNameController =
      Get.put(StudentNameController());

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
    var fToast = FToast();
    fToast.init(context);
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backGroundColor,
        title: Text(
          'Student Registration',
          style: GoogleFonts.poppins(
              fontSize: 20, color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: buttonColor,
                    ),
                    padding: EdgeInsets.all(20),
                    child: Icon(
                      Icons.app_registration_rounded,
                      color: Colors.green,
                      size: 40,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text(
                          'Name',
                          style: GoogleFonts.poppins(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.length < 3) {
                            return 'Minimum 3 Words Required';
                          } else {
                            return null;
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _name,
                        maxLength: 20,
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
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: Text(
                          'Student Registration Number\n(must be unique)',
                          style: GoogleFonts.poppins(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.length < 10) {
                            return 'Enter Complete Key';
                          } else {
                            return null;
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _registrationID,
                        maxLength: 10,
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
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: Text(
                          'Set New Password',
                          style: GoogleFonts.poppins(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter password';
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _passWord,
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
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: Text(
                          'Home Address',
                          style: GoogleFonts.poppins(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.length < 6) {
                            return 'Minimum 6 Words Required';
                          } else {
                            return null;
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _homeAddress,
                        maxLines: 3,
                        maxLength: 50,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: buttonColor,
                                    padding: EdgeInsets.all(10),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    shadowColor: backGroundColor),
                                onPressed: () {
                                  if (_validateForm()) {
                                    users
                                        .where('userName',
                                            isEqualTo: _registrationID.text)
                                        .get()
                                        .then((value) {
                                      if (value.docs.isEmpty) {
                                        EasyLoading.show(
                                          maskType: EasyLoadingMaskType.clear,
                                          status: 'Registring User',
                                        );
                                        users.add({
                                          'actor':
                                              studentNameController.studentName,
                                          'createdOn': DateTime.now(),
                                          'passWord': _passWord.text,
                                          'userName': _registrationID.text,
                                          'fullName': _name.text,
                                          'address': _homeAddress.text,
                                        }).then((value) {
                                          fToast.showToast(
                                              child: getToast(
                                                  JelloIn(
                                                      child: Icon(
                                                          FontAwesomeIcons
                                                              .check)),
                                                  'User Successfully Registered'));
                                          EasyLoading.dismiss();
                                          Get.back();
                                        }).onError((error, stackTrace) {
                                          EasyLoading.dismiss();
                                          Fluttertoast.showToast(
                                              msg: 'Error: $error',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.grey,
                                              textColor: Colors.black,
                                              fontSize: 16.0);
                                        });
                                      } else {
                                        fToast.showToast(
                                            child: getToast(
                                                JelloIn(
                                                    child: Icon(FontAwesomeIcons
                                                        .warning)),
                                                'User Already Registered'));
                                      }
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 10, 0),
                                      child: AutoSizeText(
                                        'Complete Registration',
                                        minFontSize: 20,
                                        style: GoogleFonts.poppins(
                                            color: textColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                )),
                          )
                        ],
                      )
                    ],
                  )),
            )
          ],
        )),
      )),
    );
  }
}
