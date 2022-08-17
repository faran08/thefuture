// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
import 'package:intl/intl.dart';
import 'package:super_tag_editor/tag_editor.dart';
import 'package:tab_container/tab_container.dart';
import 'package:thefuture/TeacherFiles/HomePageController.dart';

import '../globals.dart';

class EntryDefinition extends StatelessWidget {
  QueryDocumentSnapshot<Object?> originalDocument;
  Map defineDocument;
  DateTime currentDate;
  EntryDefinition(
      {Key? key,
      required this.originalDocument,
      required this.currentDate,
      required this.defineDocument})
      : super(key: key);

  final TeacherHomePageController teacherHomePageController =
      Get.put(TeacherHomePageController());

  CollectionReference designedCourses =
      FirebaseFirestore.instance.collection('designedCourses');
  CollectionReference entries =
      FirebaseFirestore.instance.collection('Entries');
  late var fToast;

  final TextEditingController _enterURL = TextEditingController();
  final TextEditingController _enterDescription = TextEditingController();
  final TextEditingController _enterType = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  List<String> tagValues = [];
  GlobalKey<FormState> globalKey = GlobalKey();

  TabContainerController containerController =
      TabContainerController(length: 3);
  List<Map> allDateEntries = [];

  bool _validateForm() {
    FormState form = globalKey.currentState!;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  void getAvailableEntries() {
    allDateEntries.clear();
    entries
        .where('dateForWhichURL',
            isGreaterThanOrEqualTo:
                DateTime(currentDate.year, currentDate.month, currentDate.day))
        .where('dateForWhichURL',
            isLessThanOrEqualTo: DateTime(
                currentDate.year, currentDate.month, currentDate.day, 24))
        .where('designURL', isEqualTo: originalDocument.id)
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
    teacherHomePageController
        .loadCourseTags((originalDocument.data() as Map)['courseName']);
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
                  _enterURL.text = '';
                  _enterType.text = '';
                  _enterDescription.text = '';
                  teacherHomePageController.update();
                },
                builder: ((context) {
                  return SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(color: backGroundColor),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Form(
                            key: globalKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add New Asset',
                                  style: GoogleFonts.poppins(
                                      color: textColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Text(
                                    'Asset URL',
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
                                  controller: _enterURL,
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.web,
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
                                    'Asset Type',
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
                                  controller: _enterType,
                                  enabled: true,
                                  readOnly: true,
                                  onTap: (() {
                                    DropDownState(
                                      DropDown(
                                        searchHintText: 'Asset Type',
                                        bottomSheetTitle:
                                            'Available Asset Types',
                                        searchBackgroundColor: backGroundColor,
                                        dataList: [
                                          SelectedListItem(false, 'Article'),
                                          SelectedListItem(false, 'Audio'),
                                          SelectedListItem(false, 'Video')
                                        ],
                                        selectedItem: (String selected) {
                                          _enterType.text = selected;
                                        },
                                        enableMultipleSelection: false,
                                        searchController: _enterType,
                                      ),
                                    ).showModal(context);
                                  }),
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.assessment_rounded,
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
                                    'Asset Description',
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextFormField(
                                  maxLines: 5,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _enterDescription,
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.details_rounded,
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
                                    '(Define the type of article, audio or video links these are. i.e., Programming, Basic, Advanced, C++, Java etc)',
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
                                          if (globalKey.currentState!
                                              .validate()) {
                                            EasyLoading.show();
                                            entries.add({
                                              'userName': globalUserName,
                                              'defineURL': defineDocument['ID'],
                                              'designURL': originalDocument.id,
                                              'URL': _enterURL.text,
                                              'entryType': _enterType.text,
                                              'entryDescription':
                                                  _enterDescription.text,
                                              'tags': tagValues,
                                              'dateForWhichURL': currentDate,
                                              'saveDate': DateTime.now()
                                            }).then((value) {
                                              fToast.showToast(
                                                  child: getToast(
                                                      JelloIn(
                                                          child: Icon(
                                                              FontAwesomeIcons
                                                                  .check)),
                                                      'Asset Added!'));
                                              EasyLoading.dismiss();
                                              Get.close(1);
                                            }).onError((error, stackTrace) {
                                              EasyLoading.dismiss();
                                              Fluttertoast.showToast(
                                                  msg: 'Error: $error',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
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
                                                'Add Link',
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
                  );
                }),
                enableDrag: false,
                animationController: null,
              ),
              isScrollControlled: true,
              enableDrag: false,
            ).whenComplete(() {
              _enterURL.text = '';
              _enterType.text = '';
              _enterDescription.text = '';
              tagValues.clear();
              getAvailableEntries();
              teacherHomePageController.update();
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
                  'Add New Asset',
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
                  'Available Assets',
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
                      allDateEntries[index]['entryType'],
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          allDateEntries[index]['URL'],
                          style: GoogleFonts.poppins(
                              color: textColor, fontWeight: FontWeight.normal),
                        ),
                        Text(
                          allDateEntries[index]['entryDescription'],
                          style: GoogleFonts.poppins(
                              color: textColor, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 30,
                          child: GridView.builder(
                              itemCount: (allDateEntries[index]['tags']).length,
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
                        )
                      ],
                    ),
                  );
                },
              )),

              // TextFormField(
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   controller: _articleLinkOne,
              //   decoration: InputDecoration(
              //       filled: true,
              //       fillColor: buttonColor,
              //       enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: buttonColor),
              //           borderRadius: BorderRadius.circular(10)),
              //       border: OutlineInputBorder(
              //           borderSide: BorderSide(color: buttonColor),
              //           borderRadius: BorderRadius.circular(10))),
              // ),

              // Padding(
              //   padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              //   child: Text(
              //     'Tags',
              //     style: GoogleFonts.poppins(
              //         color: textColor,
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              //   child: Text(
              //     '(Define the type of article, audio or video links these are. i.e., Programming, Basic, Advanced, C++, Java etc)',
              //     style: GoogleFonts.poppins(
              //         color: textColor,
              //         fontSize: 15,
              //         fontWeight: FontWeight.bold),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              // TagEditor(
              //   textStyle: GoogleFonts.poppins(
              //       color: textColor,
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold),
              //   length: tagValues.length,
              //   delimiters: [],
              //   hasAddButton: true,
              //   inputDecoration: InputDecoration(
              //       filled: true,
              //       fillColor: buttonColor,
              //       hintText: 'Type to add Tags',
              //       enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: buttonColor),
              //           borderRadius: BorderRadius.circular(10)),
              //       border: OutlineInputBorder(
              //           borderSide: BorderSide(color: buttonColor),
              //           borderRadius: BorderRadius.circular(10))),
              //   onTagChanged: (newValue) {
              //     tagValues.add(newValue);
              //     teacherHomePageController.update();
              //   },
              //   tagBuilder: (context, index) => _Chip(
              //     index: index,
              //     label: tagValues[index],
              //     onDeleted: (value) {
              //       tagValues.removeAt(value);
              //       teacherHomePageController.update();
              //     },
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              //   child: Center(
              //     child: TextButton(
              //         style: TextButton.styleFrom(
              //             backgroundColor: buttonColor,
              //             elevation: 2,
              //             shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(10)),
              //             shadowColor: backGroundColor,
              //             padding: EdgeInsets.fromLTRB(10, 20, 10, 20)),
              //         onPressed: () {
              //           EasyLoading.show();
              //           designedCourses
              //               .doc(originalDocument.id)
              //               .collection('Entries')
              //               .add({
              //             'firstLink': _articleLinkOne.text,
              //             'secondLink': _articleLinkTwo.text,
              //             'thirdLink': _articleLinkThree.text,
              //             'audioLink': _audioLink.text,
              //             'videoLink': _audioLink.text,
              //             'description': _descriptionLink.text,
              //             'tags': tagValues,
              //             'dateForWhichURL': Timestamp.fromDate(currentDate)
              //           }).then((value) {
              //             fToast.showToast(
              //                 child: getToast(
              //                     JelloIn(
              //                         child: Icon(FontAwesomeIcons.check)),
              //                     'Course Joined!'));
              //             EasyLoading.dismiss();
              //             Get.close(1);
              //           }).onError((error, stackTrace) {
              //             EasyLoading.dismiss();
              //             Fluttertoast.showToast(
              //                 msg: 'Error: $error',
              //                 toastLength: Toast.LENGTH_SHORT,
              //                 gravity: ToastGravity.BOTTOM,
              //                 timeInSecForIosWeb: 1,
              //                 backgroundColor: Colors.grey,
              //                 textColor: Colors.black,
              //                 fontSize: 16.0);
              //           });
              //         },
              //         child: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Padding(
              //               padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              //               child: Icon(
              //                 FontAwesomeIcons.save,
              //                 color: textColor,
              //                 size: 25,
              //               ),
              //             ),
              //             Padding(
              //               padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              //               child: AutoSizeText(
              //                 'Save',
              //                 minFontSize: 20,
              //                 style: GoogleFonts.poppins(
              //                     color: textColor,
              //                     fontWeight: FontWeight.w600),
              //               ),
              //             )
              //           ],
              //         )),
              //   ),
              // ),
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
