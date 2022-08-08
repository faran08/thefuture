// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefuture/AdminFiles/StateControllers.dart';
import 'package:thefuture/globals.dart';

class AddNewSubject extends StatelessWidget {
  AddNewSubject({Key? key}) : super(key: key);
  AdminStateControllers adminStateControllers =
      Get.put(AdminStateControllers());
  final TextEditingController _subjectController = TextEditingController();
  CollectionReference subjects =
      FirebaseFirestore.instance.collection('Subjects');

  GlobalKey<FormState> formState = GlobalKey();
  bool _validateForm() {
    FormState form = formState.currentState!;
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
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: Text(
          'Add New Subject',
          style: GoogleFonts.poppins(
              color: textColor, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: backGroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                'Enter Subject Name',
                style: GoogleFonts.poppins(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            Form(
                key: formState,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        expands: false,
                        validator: (value) {
                          // print(Get.find<AdminStateControllers>()
                          //     .allSubjectNames);
                          if (value!.length < 5) {
                            return 'Invalid Entry';
                          } else if (Get.find<AdminStateControllers>()
                              .allSubjectNames
                              .map((e) => e.toLowerCase())
                              .contains(value.toLowerCase())) {
                            return 'Entry Already Exist';
                          } else {
                            return null;
                          }
                        },
                        controller: _subjectController,
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
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: IconButton(
                        onPressed: () {
                          if (_validateForm()) {
                            EasyLoading.show(
                              maskType: EasyLoadingMaskType.clear,
                              status: 'Loading',
                            );
                            subjects.add({
                              'subjectName': _subjectController.text,
                              'addedBy': globalUserName,
                              'addedOn': DateTime.now(),
                            }).then((value) {
                              EasyLoading.dismiss();
                              _subjectController.clear();
                              Get.find<AdminStateControllers>()
                                  .getSubjectNames();
                              fToast.showToast(
                                  child: getToast(
                                      JelloIn(
                                          child: Icon(FontAwesomeIcons.check)),
                                      'New Subject Added'));
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
                          }
                          ;
                        },
                        icon: Icon(FontAwesomeIcons.circlePlus),
                        iconSize: 30,
                        color: iconButtonColor,
                      ),
                    )
                  ],
                )),
            Divider(),
            Flexible(
              child: GetBuilder<AdminStateControllers>(builder: (_) {
                // _.getSubjectNames();
                return _.subjectNames;
              }),
            )
          ],
        ),
      ),
    );
  }
}
