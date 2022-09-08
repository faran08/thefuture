// ignore_for_file: prefer_const_constructors

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
import 'package:select_card/select_card.dart';
import 'package:super_tag_editor/tag_editor.dart';
import 'package:thefuture/TeacherFiles/HomePageController.dart';
import 'package:thefuture/globals.dart';

class ExamEntries extends StatelessWidget {
  QueryDocumentSnapshot<Object?> originalDocument;
  DateTime currentDate;
  Map defineDocument;
  ExamEntries(
      {Key? key,
      required this.originalDocument,
      required this.currentDate,
      required this.defineDocument})
      : super(key: key);

  final TeacherHomePageController teacherHomePageController =
      Get.put(TeacherHomePageController());
  double sliderValue = 10.0;
  CollectionReference designedCourses =
      FirebaseFirestore.instance.collection('designedCourses');
  CollectionReference entries =
      FirebaseFirestore.instance.collection('Entries');
  late var fToast;
  List<Map> allDateEntries = [];
  final TextEditingController _questionStatement = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _optionOne = TextEditingController();
  final TextEditingController _optionTwo = TextEditingController();
  final TextEditingController _optionThree = TextEditingController();
  final TextEditingController _optionFour = TextEditingController();
  final TextEditingController _correctAnswer = TextEditingController();
  final TextEditingController _difficultyLevel = TextEditingController();
  final TextEditingController _linkType = TextEditingController();
  List<String> tagValues = [];
  GlobalKey<FormState> formKey = GlobalKey();

  bool _validateForm() {
    FormState form = formKey.currentState!;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  String getCorrectAnswerString(String input, String questionOne,
      String questionTwo, String questionThree, String questionFour) {
    switch (input) {
      case 'ONE':
        return questionOne;
        break;
      case 'TWO':
        return questionTwo;
        break;
      case 'THREE':
        return questionThree;
        break;
      case 'FOUR':
        return questionFour;
        break;
      default:
        return '';
    }
  }

  void getAvailableEntries() {
    allDateEntries.clear();
    entries
        .where('designURL', isEqualTo: originalDocument.id)
        .where('dateForWhichURL',
            isGreaterThanOrEqualTo:
                DateTime(currentDate.year, currentDate.month, currentDate.day))
        .where('dateForWhichURL',
            isLessThanOrEqualTo: DateTime(
                currentDate.year, currentDate.month, currentDate.day, 24))
        .snapshots()
        .forEach((element) {
      for (var item in element.docs) {
        allDateEntries.add(item.data() as Map);
      }
      teacherHomePageController.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    fToast = FToast();
    fToast.init(context);
    getAvailableEntries();
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.white,
          foregroundColor: textColor,
          onPressed: () {
            Get.bottomSheet(
              BottomSheet(
                onClosing: () {
                  _questionStatement.text = '';
                  _correctAnswer.text = '';
                  _optionFour.text = '';
                  _optionOne.text = '';
                  _optionThree.text = '';
                  _optionTwo.text = '';
                  tagValues.clear();
                },
                builder: ((context) {
                  return SafeArea(
                      child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(color: backGroundColor),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add New Question',
                                  style: GoogleFonts.poppins(
                                      color: textColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Text(
                                    'Time For Question (secs)',
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                GetBuilder<TeacherHomePageController>(
                                    builder: (_) {
                                  return Slider(
                                      min: 10.0,
                                      max: 120,
                                      activeColor: textColor,
                                      value: sliderValue,
                                      onChanged: ((value) {
                                        sliderValue = (value).ceil().toDouble();
                                        teacherHomePageController.update();
                                      }));
                                }),
                                GetBuilder<TeacherHomePageController>(
                                    builder: (_) {
                                  return Padding(
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      child: Center(
                                        child: Text(sliderValue.toString(),
                                            style: GoogleFonts.poppins(
                                                color: textColor,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold)),
                                      ));
                                }),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Text(
                                    'Difficulty Level',
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SelectGroupCard(context, titles: const [
                                  'Hard',
                                  'Semi Hard',
                                  'Normal',
                                  'Average',
                                  'Low Average',
                                  'Below Average'
                                ], onTap: (title) {
                                  debugPrint(title);
                                  _difficultyLevel.text = title;
                                }),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Text(
                                    'Question was taken from',
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SelectGroupCard(context, titles: const [
                                  'Article Link',
                                  'Audio Link',
                                  'Video Link',
                                ], onTap: (title) {
                                  debugPrint(title);
                                  _linkType.text = title;
                                }),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Text(
                                    'Statement',
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field cannot be left empty.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  maxLines: 5,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _questionStatement,
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.question_mark_rounded,
                                        color: textColor,
                                      ),
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
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Text(
                                    'Option One',
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field cannot be left empty.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _optionOne,
                                  enabled: true,
                                  readOnly: false,
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.question_answer_rounded,
                                        color: textColor,
                                      ),
                                      filled: true,
                                      fillColor: buttonColor,
                                      disabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: buttonColor),
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Text(
                                    'Option Two',
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field cannot be left empty.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _optionTwo,
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.question_answer_rounded,
                                        color: textColor,
                                      ),
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
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Text(
                                    'Option Three',
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field cannot be left empty.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _optionThree,
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.question_answer_rounded,
                                        color: textColor,
                                      ),
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
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Text(
                                    'Option Four',
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field cannot be left empty.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _optionFour,
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.question_answer_rounded,
                                        color: textColor,
                                      ),
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
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Text(
                                    'Correct Answer',
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SelectGroupCard(context, titles: const [
                                  'ONE',
                                  'TWO',
                                  'THREE',
                                  'FOUR'
                                ], onTap: (title) {
                                  debugPrint(title);
                                  _correctAnswer.text = title;
                                }),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Text(
                                    'Tags',
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Text(
                                    '(Enter sub-topic the question pertains to i.e., Programming, Digital Logic Design, etc)',
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.italic),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                                GetBuilder<TeacherHomePageController>(
                                    builder: (_) {
                                  return TagEditor(
                                    controller: _tagController,
                                    readOnly: false,
                                    textStyle: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    length: tagValues.length,
                                    delimiters: [],
                                    hasAddButton: true,
                                    inputDecoration: InputDecoration(
                                        filled: true,
                                        fillColor: buttonColor,
                                        hintText: 'Type to add Tags',
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
                                    onTagChanged: (newValue) {
                                      tagValues.add(newValue);
                                      teacherHomePageController.update();
                                    },
                                    tagBuilder: (context, index) => _Chip(
                                      index: index,
                                      label: tagValues[index],
                                      onDeleted: (value) {
                                        tagValues.removeAt(value);
                                        teacherHomePageController.update();
                                      },
                                    ),
                                    findSuggestions: (String query) {
                                      List<String> searchResult = [];
                                      for (var element
                                          in teacherHomePageController
                                              .tagsList) {
                                        if (element
                                            .toLowerCase()
                                            .contains(query.toLowerCase())) {
                                          searchResult.add(element);
                                        }
                                      }
                                      return searchResult;
                                    },
                                    suggestionBuilder: (context, state, data) =>
                                        ListTile(
                                      key: ObjectKey(data),
                                      title: Text(data.toString()),
                                      onTap: () {
                                        state.selectSuggestion(data);
                                        tagValues.add(data.toString());
                                        teacherHomePageController.update();
                                      },
                                    ),
                                  );
                                }),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                                          if (formKey.currentState!
                                              .validate()) {
                                            if (_correctAnswer
                                                .text.isNotEmpty) {
                                              EasyLoading.show();
                                              entries.add({
                                                'userID': globalUserName,
                                                'defineURL':
                                                    defineDocument['ID'],
                                                'designURL':
                                                    originalDocument.id,
                                                'difficultyLevel':
                                                    _difficultyLevel.text,
                                                'asset_Type': _linkType.text,
                                                'questionStatement':
                                                    _questionStatement.text,
                                                'optionOne': _optionOne.text,
                                                'optionTwo': _optionTwo.text,
                                                'optionThree':
                                                    _optionThree.text,
                                                'optionFour': _optionFour.text,
                                                'correctAnswer':
                                                    getCorrectAnswerString(
                                                        _correctAnswer.text,
                                                        _optionOne.text,
                                                        _optionTwo.text,
                                                        _optionThree.text,
                                                        _optionFour.text),
                                                'tags': tagValues,
                                                'dateForWhichURL': currentDate,
                                                'saveDate': DateTime.now(),
                                                'entryType': 'Exam',
                                                'timeForQuestion': sliderValue
                                              }).then((value) {
                                                getAvailableEntries();
                                                fToast.showToast(
                                                    child: getToast(
                                                        JelloIn(
                                                            child: Icon(
                                                                FontAwesomeIcons
                                                                    .check)),
                                                        'Question Added!'));
                                                EasyLoading.dismiss();
                                                Get.close(1);
                                              }).onError((error, stackTrace) {
                                                EasyLoading.dismiss();
                                                Fluttertoast.showToast(
                                                    msg: 'Error: $error',
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    textColor: Colors.black,
                                                    fontSize: 16.0);
                                              });
                                            } else {
                                              fToast.showToast(
                                                  child: getToast(
                                                      JelloIn(
                                                          child: Icon(
                                                              FontAwesomeIcons
                                                                  .warning)),
                                                      'Correct Option Not Selected'));
                                            }
                                          }
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.add_link,
                                              color: textColor,
                                              size: 25,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 0, 10, 0),
                                              child: AutoSizeText(
                                                'Add Question',
                                                minFontSize: 15,
                                                style: GoogleFonts.poppins(
                                                    color: textColor,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                }),
                enableDrag: false,
                animationController: null,
              ),
              ignoreSafeArea: false,
              isScrollControlled: true,
              enableDrag: false,
            ).whenComplete(() {
              _questionStatement.text = '';
              _correctAnswer.text = '';
              _optionFour.text = '';
              _optionOne.text = '';
              _optionThree.text = '';
              _optionTwo.text = '';
              tagValues.clear();
            });
          },
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.add,
                color: textColor,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  'Add New Question',
                  style: TextStyle(color: textColor),
                ),
              )
            ],
          )),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backGroundColor,
        title: Text(
          DateFormat('dd MMM').format(currentDate),
          style: GoogleFonts.poppins(
              color: textColor, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: backGroundColor,
      body: GetBuilder<TeacherHomePageController>(builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Submitted Questions',
                  style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                  child: ListView.builder(
                itemCount: allDateEntries.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    isThreeLine: true,
                    title: Text(
                      allDateEntries[index]['correctAnswer'],
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          allDateEntries[index]['questionStatement'],
                          style: GoogleFonts.poppins(
                              color: textColor, fontWeight: FontWeight.normal),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: SizedBox(
                            height: 30,
                            child: GridView.builder(
                                itemCount:
                                    (allDateEntries[index]['tags']).length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, mainAxisExtent: 25),
                                itemBuilder: ((context, index2) {
                                  return Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey.shade300),
                                    child: Center(
                                      child: Text(
                                        allDateEntries[index]['tags'][index2],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                })),
                          ),
                        )
                      ],
                    ),
                  );
                },
              )),
            ],
          ),
        );
      }),
    ));
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
