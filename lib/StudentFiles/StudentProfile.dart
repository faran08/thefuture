// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefuture/AdminFiles/StateControllers.dart';
import 'package:thefuture/StudentFiles/StudentController.dart';

import '../globals.dart';

class StudentProfile extends StatelessWidget {
  String parentDocument = '';
  StudentProfile({Key? key, required this.parentDocument}) : super(key: key);
  final StudentController studentController = Get.put(StudentController());
  final AdminStateControllers adminStateControllers =
      Get.put(AdminStateControllers());
  CollectionReference joinedCourses =
      FirebaseFirestore.instance.collection('joinedCourses');
  CollectionReference studentProfiles =
      FirebaseFirestore.instance.collection('studentProfiles');
  PageController controller = PageController();
  GlobalKey<FormState> formKey = GlobalKey();
  ///////////////////////////////////////////////
  late String? selectedAge = 'Less then 20';
  final List<String> ageData = const [
    'Less then 20',
    '21 to 29',
    '30 to 39',
    '40 to 49'
  ];
  //
  late String? selectedGender = 'Male';
  final List<String> genderData = const ['Male', 'Female'];
  //
  late String? selectedEthncity = 'Asian American';
  final List<String> selectedEthncityData = const [
    'Asian American',
    'African American',
    'Caucasian/ White',
    'American Indian',
    'Hispanic/ Latino/ Chicano',
    'Multi-Racial',
    'Arab/ Arab American',
    'Asian',
    'Other'
  ];
  late String? selectedDegree = 'Associates';
  final List<String> selectedDegreeData = const [
    'Associates',
    'Bachelors',
    'Masters',
    'Doctorate',
    'Matric/ O-Level',
    'FSc/ A-Level',
    'Other'
  ];
  //
  late String? selectedEmployment = 'Employed';
  final List<String> selectedEmploymentData = const [
    'Employed',
    'Not Employed'
  ];
  //
  late String? selectedResidency = 'Residence';
  final List<String> selectedResidencyData = const ['Residence', 'Commuter'];
  //
  late String? selectedMajor = 'Yes';
  final List<String> selectedMajorData = const ['Yes', 'No'];
  //
  late String? selectedCountry = 'Albania';
  final TextEditingController countryTextEditingController =
      TextEditingController();
  //
  final TextEditingController addressTextEditingController =
      TextEditingController();
  //////
  final TextEditingController oLevelPercentage = TextEditingController();
  final TextEditingController aLevelPercentage = TextEditingController();
  final TextEditingController bachelorsCGPA = TextEditingController();
  final TextEditingController oLevelSubject = TextEditingController();
  final TextEditingController aLevelSubject = TextEditingController();
  final TextEditingController bacherlorsSubject1 = TextEditingController();
  final TextEditingController bacherlorsSubject2 = TextEditingController();
  final TextEditingController bacherlorsSubject3 = TextEditingController();
  ////////////////////////////////////////////////
  bool _validateForm() {
    FormState form = formKey.currentState!;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  Widget getPersonalInformation(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<StudentController>(builder: (_) {
        return Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Personal Infomation',
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    color: textColor.withOpacity(0.2),
                    height: 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Age',
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: CustomDropdownButton2(
                          dropdownWidth:
                              MediaQuery.of(context).size.width * 0.5,
                          buttonWidth: MediaQuery.of(context).size.width * 0.5,
                          buttonHeight: 50,
                          buttonDecoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hint: 'Select Age',
                          dropdownItems: ageData,
                          value: selectedAge,
                          onChanged: (value) {
                            selectedAge = value;
                            studentController.update();
                          },
                        ),
                      ),
                      Text(
                        'Gender',
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: CustomDropdownButton2(
                          dropdownWidth:
                              MediaQuery.of(context).size.width * 0.5,
                          buttonWidth: MediaQuery.of(context).size.width * 0.5,
                          buttonHeight: 50,
                          buttonDecoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hint: 'Select Gender',
                          dropdownItems: genderData,
                          value: selectedGender,
                          onChanged: (value) {
                            selectedGender = value;
                            studentController.update();
                          },
                        ),
                      ),
                      Text(
                        'Race/ Ethnicity',
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: CustomDropdownButton2(
                          dropdownWidth:
                              MediaQuery.of(context).size.width * 0.5,
                          buttonWidth: MediaQuery.of(context).size.width * 0.5,
                          buttonHeight: 50,
                          buttonDecoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hint: 'Select Ethencity',
                          dropdownItems: selectedEthncityData,
                          value: selectedEthncity,
                          onChanged: (value) {
                            selectedEthncity = value;
                            studentController.update();
                          },
                        ),
                      ),
                      Text(
                        'Degree',
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: CustomDropdownButton2(
                          dropdownWidth:
                              MediaQuery.of(context).size.width * 0.5,
                          buttonWidth: MediaQuery.of(context).size.width * 0.5,
                          buttonHeight: 50,
                          buttonDecoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hint: 'Education Level',
                          dropdownItems: selectedDegreeData,
                          value: selectedDegree,
                          onChanged: (value) {
                            selectedDegree = value;
                            studentController.update();
                          },
                        ),
                      ),
                      Text(
                        'Employment Status',
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: CustomDropdownButton2(
                          dropdownWidth:
                              MediaQuery.of(context).size.width * 0.5,
                          buttonWidth: MediaQuery.of(context).size.width * 0.5,
                          buttonHeight: 50,
                          buttonDecoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hint: 'Education Level',
                          dropdownItems: selectedEmploymentData,
                          value: selectedEmployment,
                          onChanged: (value) {
                            selectedEmployment = value;
                            studentController.update();
                          },
                        ),
                      ),
                      Text(
                        'Resident/ Commuter',
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: CustomDropdownButton2(
                          dropdownWidth:
                              MediaQuery.of(context).size.width * 0.5,
                          buttonWidth: MediaQuery.of(context).size.width * 0.5,
                          buttonHeight: 50,
                          buttonDecoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hint: 'Education Level',
                          dropdownItems: selectedResidencyData,
                          value: selectedResidency,
                          onChanged: (value) {
                            selectedResidency = value;
                            studentController.update();
                          },
                        ),
                      ),
                      Text(
                        'Science Major?',
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: CustomDropdownButton2(
                          dropdownWidth:
                              MediaQuery.of(context).size.width * 0.5,
                          buttonWidth: MediaQuery.of(context).size.width * 0.5,
                          buttonHeight: 50,
                          buttonDecoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hint: 'Education Level',
                          dropdownItems: selectedMajorData,
                          value: selectedMajor,
                          onChanged: (value) {
                            selectedMajor = value;
                            studentController.update();
                          },
                        ),
                      ),
                      Text(
                        'Country',
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            dropdownFullScreen: true,
                            itemPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            buttonPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            buttonDecoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            isExpanded: true,
                            hint: Text(
                              'Select Country',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: countryList
                                .map((item) => DropdownMenuItem<String>(
                                      value: item['Name'],
                                      child: Text(
                                        item['Name'],
                                        style: const TextStyle(),
                                      ),
                                    ))
                                .toList(),
                            value: selectedCountry,
                            onChanged: (value) {
                              selectedCountry = value as String;
                              studentController.update();
                            },
                            buttonHeight: 50,
                            buttonWidth:
                                MediaQuery.of(context).size.width * 0.5,
                            itemHeight: 50,
                            dropdownMaxHeight:
                                MediaQuery.of(context).size.height * 0.8,
                            dropdownWidth: MediaQuery.of(context).size.width,
                            searchController: countryTextEditingController,
                            searchInnerWidget: Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 4,
                                right: 8,
                                left: 8,
                              ),
                              child: TextFormField(
                                controller: countryTextEditingController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 15,
                                  ),
                                  hintText: 'Search for your country',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return (item.value
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchValue.toLowerCase()));
                            },
                            //This to clear the search value when you close the menu
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                countryTextEditingController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                      // Text(
                      //   'Address',
                      //   style: GoogleFonts.poppins(
                      //       color: textColor,
                      //       fontSize: 20,
                      //       fontWeight: FontWeight.normal),
                      // ),
                      // TextFormField(
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Cannot be left empty';
                      //     } else {
                      //       return null;
                      //     }
                      //   },
                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                      //   controller: addressTextEditingController,
                      //   readOnly: false,
                      //   maxLines: 3,
                      //   onTap: (() {}),
                      //   decoration: InputDecoration(
                      //       prefixIcon: Icon(
                      //         Icons.home_rounded,
                      //         color: textColor,
                      //       ),
                      //       filled: true,
                      //       fillColor: buttonColor,
                      //       enabledBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(color: buttonColor),
                      //           borderRadius: BorderRadius.circular(10)),
                      //       border: OutlineInputBorder(
                      //           borderSide: BorderSide(color: buttonColor),
                      //           borderRadius: BorderRadius.circular(10))),
                      // ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  shadowColor: backGroundColor,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5)),
                              onPressed: () {
                                if (_validateForm()) {
                                  adminStateControllers.getSubjectNames();
                                  controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: transitionCurves);
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: textColor,
                                    size: 25,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: AutoSizeText(
                                      'Next',
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
                    ),
                  )
                ],
              ),
            ));
      }),
    );
  }

  Widget getEducationDetails(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text(
              'Educational Background',
              style: GoogleFonts.poppins(
                  color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: textColor.withOpacity(
              0.2,
            ),
            height: 1,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              'O-Levels/ Matric Percentage',
              style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextFormField(
                expands: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Invalid Entry';
                  } else {
                    return null;
                  }
                },
                controller: oLevelPercentage,
                maxLength: 3,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.percent,
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
            ),
          ),
          Text(
            'Best Performing Subject',
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 20, fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select some subject';
                  } else {
                    return null;
                  }
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: oLevelSubject,
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
                        oLevelSubject.text = selected;
                      },
                      enableMultipleSelection: false,
                      searchController: oLevelSubject,
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
            ),
          ),
          Divider(
            color: textColor.withOpacity(
              0.2,
            ),
            height: 1,
          ),
          Text(
            'A-Levels/ FSc Percentage',
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 20, fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextFormField(
                expands: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Invalid Entry';
                  } else {
                    return null;
                  }
                },
                controller: aLevelPercentage,
                maxLength: 3,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.percent,
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
            ),
          ),
          Text(
            'Best Performing Subject',
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 20, fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select some subject';
                  } else {
                    return null;
                  }
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: aLevelSubject,
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
                        aLevelSubject.text = selected;
                      },
                      enableMultipleSelection: false,
                      searchController: aLevelSubject,
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
            ),
          ),
          Divider(
            color: textColor.withOpacity(
              0.2,
            ),
            height: 1,
          ),
          Text(
            'Bachelors/ 16 years education CGPA',
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 20, fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextFormField(
                expands: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Invalid Entry';
                  } else {
                    return null;
                  }
                },
                controller: bachelorsCGPA,
                maxLength: 3,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.percent,
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
            ),
          ),
          Text(
            'Best Performing Subject (1)',
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 20, fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select some subject';
                  } else {
                    return null;
                  }
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: bacherlorsSubject1,
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
                        bacherlorsSubject1.text = selected;
                      },
                      enableMultipleSelection: false,
                      searchController: bacherlorsSubject1,
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
            ),
          ),
          Text(
            'Best Performing Subject (2)',
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 20, fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select some subject';
                  } else {
                    return null;
                  }
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: bacherlorsSubject2,
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
                        bacherlorsSubject2.text = selected;
                      },
                      enableMultipleSelection: false,
                      searchController: bacherlorsSubject2,
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
            ),
          ),
          Text(
            'Best Performing Subject (3)',
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 20, fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select some subject';
                  } else {
                    return null;
                  }
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: bacherlorsSubject3,
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
                        bacherlorsSubject3.text = selected;
                      },
                      enableMultipleSelection: false,
                      searchController: bacherlorsSubject3,
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
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: buttonColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              shadowColor: backGroundColor,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5)),
                          onPressed: () {
                            controller.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: transitionCurves);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: textColor,
                                size: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: AutoSizeText(
                                  'Back',
                                  minFontSize: 20,
                                  style: GoogleFonts.poppins(
                                      color: textColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: buttonColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              shadowColor: backGroundColor,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5)),
                          onPressed: () {
                            EasyLoading.show();
                            studentProfiles.add({
                              'age': selectedAge,
                              'gender': selectedGender,
                              'ethnicity': selectedEthncity,
                              'degree': selectedDegree,
                              'employment': selectedEmployment,
                              'residency': selectedResidency,
                              'major': selectedMajor,
                              'country': selectedCountry,
                              'oLevelPercentage': oLevelPercentage.text,
                              'aLevelPercentage': aLevelPercentage.text,
                              'bachelorsCGPA': bachelorsCGPA.text,
                              'aLevelSubject': aLevelSubject.text,
                              'oLevelSubject': oLevelSubject.text,
                              'bachelorsSubject1': bacherlorsSubject1.text,
                              'bachelorsSubject2': bacherlorsSubject2.text,
                              'bachelorsSubject3': bacherlorsSubject3.text,
                              'createdOn': DateTime.now(),
                              'referenceDocument': parentDocument,
                              'studentName': globalUserName,
                            }).then((value) {
                              EasyLoading.dismiss();
                              var fToast = FToast();
                              fToast.init(context);
                              fToast.showToast(
                                  child: getToast(
                                      JelloIn(
                                          child: Icon(FontAwesomeIcons.check)),
                                      'Form Submitted Successfully'));
                              joinedCourses
                                  .doc(parentDocument)
                                  .update({'formFilled': true}).then((value) {
                                Get.close(1);
                                //Get.to(CourseOverView);
                              });
                            }).onError((error, stackTrace) {
                              Fluttertoast.showToast(
                                  msg: 'Error: ' + error.toString(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.black,
                                  fontSize: 16.0);
                              EasyLoading.dismiss();
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.thumb_up_alt_rounded,
                                color: textColor,
                                size: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: AutoSizeText(
                                  'Submit',
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
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: Container(),
        leadingWidth: 0,
        centerTitle: true,
        title: AutoSizeText(
          'Student Profiling System',
          style: GoogleFonts.poppins(
              color: textColor, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: backGroundColor,
      ),
      backgroundColor: backGroundColor,
      resizeToAvoidBottomInset: true,
      body: PageView(
        controller: controller,
        children: [
          getPersonalInformation(context),
          getEducationDetails(context)
        ],
      ),
    ));
  }
}
