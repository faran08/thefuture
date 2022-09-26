// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ml_custom/firebase_ml_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:select_card/select_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:thefuture/globals.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

import '../LoginFiles/StateControllers/StudentNameController.dart';

class TakeExam extends StatelessWidget {
  String defineID = '';
  String designID = '';
  DateTime examDate;
  TakeExam({
    Key? key,
    required this.defineID,
    required this.designID,
    required this.examDate,
  }) : super(key: key);

  CollectionReference examEntries =
      FirebaseFirestore.instance.collection('Exams');
  CollectionReference examResults =
      FirebaseFirestore.instance.collection('ExamResults');
  StudentNameController studentNameController =
      Get.put(StudentNameController());
  String examResultID = '';
  bool dataLoaded = false;
  int _start = 0;
  Timer _timer = Timer.periodic(
    Duration(seconds: 1),
    (Timer timer) {},
  );
  late QuerySnapshot<Object?> allQuestions;
  List<String> answersToQuestions = [];

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          saveResults();
        } else {
          _start--;
          studentNameController.update();
        }
      },
    );
  }

  List<ChartData> getChartDataForStudent(
      List<Map<dynamic, dynamic>> inputData) {
    Map dataList = {};
    List<ChartData> chartData = [];
    double totalQuestions = inputData.length.toDouble();
    for (var element in inputData) {
      if (element['correctAnswer'] == element['userAnswer']) {
        for (var element in element['tags'] as List) {
          if (!dataList.containsKey(element)) {
            dataList[element] = 1;
          } else {
            dataList[element]++;
          }
        }
      }
    }
    int i = 0;
    for (var element in dataList.entries) {
      chartData.add(ChartData(
          element.key,
          (double.parse(element.value.toString()) / totalQuestions) * 100,
          getNumberedColor(i)));
      i++;
    }
    return chartData;
  }

  void savePreExamResults() {
    examResults.add({
      'studentID': globalUserName,
      'defineID': defineID,
      'designID': designID,
      'examDate': examDate,
      'correctAnswers': 'xxxNotAttemptedxxx'
    }).then((value) => examResultID = value.id);
  }

  static Future<File> loadModelFromFirebase() async {
    try {
      // Create model with a name that is specified in the Firebase console
      final model = FirebaseCustomRemoteModel('LearningStyle');

      // Specify conditions when the model can be downloaded.
      // If there is no wifi access when the app is started,
      // this app will continue loading until the conditions are satisfied.
      final conditions = FirebaseModelDownloadConditions();

      // Create model manager associated with default Firebase App instance.
      final modelManager = FirebaseModelManager.instance;

      // Begin downloading and wait until the model is downloaded successfully.
      await modelManager.download(model, conditions);
      Fluttertoast.showToast(
          msg: 'Model Downloaded',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0);
      assert(await modelManager.isModelDownloaded(model) == true);
      Fluttertoast.showToast(
          msg: 'Model Applied',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0);
      // Get latest model file to use it for inference by the interpreter.
      var modelFile = await modelManager.getLatestModelFile(model);
      assert(modelFile != null);
      return modelFile;
    } catch (exception) {
      Fluttertoast.showToast(
          msg: 'Failed on loading your model from Firebase: $exception',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0);
      Fluttertoast.showToast(
          msg: 'The program will not be resumed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0);
      print('Failed on loading your model from Firebase: $exception');
      print('The program will not be resumed');
      rethrow;
    }
  }

  Future<List<dynamic>> getOutput(var data, File value) async {
    final interpreter = tfl.Interpreter.fromFile(value);
    var input = data;

    // if output tensor shape [1,2] and type is float32
    var output = List.filled(1, 1).reshape([1, 1]);
    // double output = 0;
    // var output;

    // inference
    interpreter.run(input, output);

    // print the output

    return output;
  }

  String decodeLearningStyle(double input) {
    if (input < 1) {
      return 'Reading & Writing';
    } else if (input >= 1 && input < 2) {
      return 'Auditory';
    } else if (input >= 2 && input < 3) {
      return 'Visual';
    } else {
      return 'Kinesthetic';
    }
  }

  void saveResults() {
    List<Map> saveQuestionsMap = [];
    int totalMarks = 0;
    int article_obtained = 0;
    int audio_obtained = 0;
    int video_obtained = 0;

    int article_total = 1;
    int audio_total = 1;
    int video_total = 1;

    for (var element in allQuestions.docs) {
      if ((element.data() as Map)['asset_Type'].toString() == 'Article Link') {
        article_total++;
      } else if ((element.data() as Map)['asset_Type'].toString() ==
          'Audio Link') {
        audio_total++;
      } else if ((element.data() as Map)['asset_Type'].toString() ==
          'Video Link') {
        video_total++;
      }
    }

    for (var i = 0; i < allQuestions.docs.length; i++) {
      saveQuestionsMap.add({
        'questionID': allQuestions.docs[i].id,
        'correctAnswer': allQuestions.docs[i]['correctAnswer'],
        'userAnswer': answersToQuestions[i],
        'tags': allQuestions.docs[i]['tags'],
        'assetType': allQuestions.docs[i]['asset_Type']
      });
      //Calculate individual type marks and total marks
      if (allQuestions.docs[i]['correctAnswer'] == answersToQuestions[i]) {
        totalMarks++;
        if (allQuestions.docs[i]['asset_Type'] == 'Article Link') {
          article_obtained++;
        } else if (allQuestions.docs[i]['asset_Type'] == 'Audio Link') {
          audio_obtained++;
        } else if (allQuestions.docs[i]['asset_Type'] == 'Video Link') {
          video_obtained++;
        }
      }
    }
    EasyLoading.show();
    examResults.doc(examResultID).update({
      'resultData': saveQuestionsMap,
      'correctAnswers': totalMarks.toString()
    }).then((value) {
      loadModelFromFirebase().then((value) => {
            getOutput([
              [
                article_total.toDouble(),
                audio_total.toDouble(),
                video_total.toDouble(),
                ((totalMarks / allQuestions.docs.length) * 100).toDouble(),
                ((article_obtained / article_total) * 100).toDouble(),
                ((audio_obtained / audio_total) * 100).toDouble(),
                ((video_obtained / video_total) * 100).toDouble(),
              ]
            ], value)
                .then((learningStyle) {
              Fluttertoast.showToast(
                  msg: decodeLearningStyle(learningStyle[0][0]).toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.black,
                  fontSize: 16.0);
              examResults.doc(examResultID).update({
                'learningStyle':
                    decodeLearningStyle(learningStyle[0][0]).toString(),
              });
              EasyLoading.dismiss();
              Get.close(2);
              List<ChartData> chartData =
                  getChartDataForStudent(saveQuestionsMap);
              Get.bottomSheet(
                  BottomSheet(
                      onClosing: () {},
                      builder: ((context) {
                        return SizedBox(
                          height: Get.height * 0.95,
                          child: Scaffold(
                            backgroundColor: backGroundColor,
                            appBar: AppBar(
                              leading: Container(),
                              backgroundColor: backGroundColor,
                              elevation: 0,
                              centerTitle: true,
                              title: Text(
                                'Exam Result',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            body: SingleChildScrollView(
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.done_all_rounded,
                                      color: Colors.green,
                                      size: 75,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 20, 0, 20),
                                      child: Text(
                                        'Your learning style identified',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 20, 0, 20),
                                      child: Text(
                                        decodeLearningStyle(learningStyle[0][0])
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      'You have scored',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Text(
                                          totalMarks.toString() +
                                              ' / ' +
                                              allQuestions.docs.length
                                                  .toString(),
                                          style: GoogleFonts.openSans(
                                              color: textColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.justify,
                                        )),
                                    Text(
                                      'Subject Wise Distribution',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: SfCircularChart(
                                          legend: Legend(
                                              alignment: ChartAlignment.center,
                                              position: LegendPosition.bottom,
                                              orientation: LegendItemOrientation
                                                  .horizontal,
                                              isVisible: true),
                                          series: <CircularSeries>[
                                            PieSeries<ChartData, String>(
                                                radius: (MediaQuery.of(context).size.width * 0.25)
                                                    .toString(),
                                                strokeColor: textColor,
                                                strokeWidth: 0,
                                                dataLabelSettings: DataLabelSettings(
                                                    isVisible: true,
                                                    textStyle: TextStyle(
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12),
                                                    labelIntersectAction:
                                                        LabelIntersectAction
                                                            .shift,
                                                    labelPosition:
                                                        ChartDataLabelPosition
                                                            .outside,
                                                    connectorLineSettings:
                                                        ConnectorLineSettings(
                                                            type: ConnectorType
                                                                .curve,
                                                            length: '10%')),
                                                dataSource: chartData,
                                                pointColorMapper:
                                                    (ChartData data, _) =>
                                                        data.color,
                                                xValueMapper: (ChartData data, _) =>
                                                    data.x,
                                                yValueMapper: (ChartData data, _) =>
                                                    data.y,
                                                dataLabelMapper: (ChartData data, _) =>
                                                    '${data.y}%'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                                      child: TextButton(
                                          onPressed: () {
                                            Get.close(3);
                                          },
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      enableDrag: false),
                  enableDrag: false,
                  isScrollControlled: true);
            })
          });

      // Get.bottomSheet(
      //     BottomSheet(
      //         enableDrag: false,
      //         onClosing: () {},
      //         builder: (context) {
      //           return SizedBox(
      //             height: MediaQuery.of(context).size.height * 0.95,
      //             child: Scaffold(
      //               backgroundColor: backGroundColor,
      //               appBar: AppBar(
      //                 backgroundColor: backGroundColor,
      //                 leading: Container(),
      //                 leadingWidth: 0,
      //                 elevation: 0,
      //                 centerTitle: true,
      //                 title: Text(
      //                   'Result',
      //                   style: TextStyle(color: Colors.red, fontSize: 25),
      //                 ),
      //               ),
      //               body: Padding(
      //                 padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      //                 child: Column(
      //                   children: [
      //                     Column(
      //                       children: [
      //                         Text(
      //                           'You have scored',
      //                           style: GoogleFonts.openSans(
      //                             color: textColor,
      //                             fontSize: 18,
      //                           ),
      //                           textAlign: TextAlign.justify,
      //                         ),
      //                         Padding(
      //                           padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      //                           child: Text(
      //                             totalMarks.toString() +
      //                                 ' / ' +
      //                                 allQuestions.docs.length.toString(),
      //                             style: GoogleFonts.openSans(
      //                                 color: textColor,
      //                                 fontSize: 18,
      //                                 fontWeight: FontWeight.bold),
      //                             textAlign: TextAlign.justify,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                     Padding(
      //                       padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      //                       child: TextButton(
      //                           style: TextButton.styleFrom(
      //                               backgroundColor: buttonColor,
      //                               elevation: 2,
      //                               shape: RoundedRectangleBorder(
      //                                   borderRadius:
      //                                       BorderRadius.circular(10)),
      //                               shadowColor: backGroundColor,
      //                               padding:
      //                                   EdgeInsets.fromLTRB(10, 10, 10, 10)),
      //                           onPressed: () {
      //                             Get.close(1);
      //                           },
      //                           child: Row(
      //                             mainAxisSize: MainAxisSize.min,
      //                             children: [
      //                               Padding(
      //                                 padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      //                                 child: Icon(
      //                                   Icons.done_outline_rounded,
      //                                   color: Colors.green,
      //                                   size: 30,
      //                                 ),
      //                               ),
      //                               Padding(
      //                                 padding:
      //                                     EdgeInsets.fromLTRB(20, 0, 20, 0),
      //                                 child: AutoSizeText(
      //                                   'OK',
      //                                   minFontSize: 20,
      //                                   style: GoogleFonts.poppins(
      //                                       color: textColor,
      //                                       fontWeight: FontWeight.w600),
      //                                 ),
      //                               )
      //                             ],
      //                           )),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           );
      //         }),
      //     isScrollControlled: true);
    });
  }

  void getExamQuestions() {
    examEntries
        .where('defineURL', isEqualTo: defineID)
        .where('dateForWhichURL',
            isGreaterThanOrEqualTo:
                DateTime(examDate.year, examDate.month, examDate.day, 0))
        .where('dateForWhichURL',
            isLessThanOrEqualTo:
                DateTime(examDate.year, examDate.month, examDate.day, 24))
        .get()
        .then((value) {
      allQuestions = value;
      dataLoaded = true;
      savePreExamResults();
      print('No of questions ${value.docs.length}');
      _start = 0;
      _timer.cancel();

      for (var element in value.docs) {
        try {
          print(((element.data() as Map)['timeForQuestion']).toString());
          _start = _start +
              ((element.data() as Map)['timeForQuestion'] as double).toInt();
          answersToQuestions.add('notSelected');
        } catch (e) {}
      }
      if (!_timer.isActive) {
        startTimer();
      }

      studentNameController.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    getExamQuestions();
    // startTimer();
    return WillPopScope(
        child: Scaffold(
          backgroundColor: backGroundColor,
          appBar: AppBar(
            leading: Container(),
            elevation: 0,
            leadingWidth: 0,
            backgroundColor: backGroundColor,
            actions: [
              IconButton(
                  onPressed: () {
                    Get.bottomSheet(
                        BottomSheet(
                            enableDrag: false,
                            onClosing: () {},
                            builder: (context) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.95,
                                child: Scaffold(
                                  backgroundColor: backGroundColor,
                                  appBar: AppBar(
                                    backgroundColor: backGroundColor,
                                    leading: Container(),
                                    leadingWidth: 0,
                                    elevation: 0,
                                    centerTitle: true,
                                    title: Text(
                                      'Warning',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 25),
                                    ),
                                  ),
                                  body: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Are you sure?',
                                              style: GoogleFonts.openSans(
                                                color: textColor,
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 10, 0, 0),
                                              child: Text(
                                                'Be sure about all your answers. You cannot re-attempt the test.',
                                                style: GoogleFonts.openSans(
                                                    color: textColor,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 20, 0, 0),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor: buttonColor,
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  shadowColor: backGroundColor,
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 10)),
                                              onPressed: () {
                                                Get.close(1);
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 0, 0),
                                                    child: Icon(
                                                      Icons
                                                          .done_outline_rounded,
                                                      color: Colors.green,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 0, 20, 0),
                                                    child: AutoSizeText(
                                                      'Continue with Exam',
                                                      minFontSize: 20,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: textColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 20, 0, 0),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor: buttonColor,
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  shadowColor: backGroundColor,
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 10)),
                                              onPressed: () {
                                                saveResults();
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 0, 0),
                                                    child: Icon(
                                                      Icons.cancel,
                                                      color: Colors.red,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 0, 20, 0),
                                                    child: AutoSizeText(
                                                      'Submit',
                                                      minFontSize: 20,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: textColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
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
                  },
                  icon: Icon(
                    Icons.done_outline_rounded,
                    color: Colors.black,
                    size: 30,
                  ))
            ],
            title: GetBuilder<StudentNameController>(builder: (_) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timelapse_rounded,
                        color: textColor,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          _start.toString() + ' Secs Remaining',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          body: GetBuilder<StudentNameController>(builder: (_) {
            return dataLoaded
                ? ListView.builder(
                    itemCount: allQuestions.docs.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              allQuestions.docs[index]['questionStatement'],
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: SelectGroupCard(context, titles: [
                                allQuestions.docs[index]['optionOne'],
                                allQuestions.docs[index]['optionTwo'],
                                allQuestions.docs[index]['optionThree'],
                                allQuestions.docs[index]['optionFour']
                              ], onTap: (title) {
                                debugPrint(title);
                                answersToQuestions[index] = title;
                              }),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Divider(
                                thickness: 2,
                              ),
                            )
                          ],
                        ),
                      );
                    }))
                : Text('Loading');
          }),
        ),
        onWillPop: () async {
          Get.bottomSheet(
              BottomSheet(
                  enableDrag: false,
                  onClosing: () {},
                  builder: (context) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.95,
                      child: Scaffold(
                        backgroundColor: backGroundColor,
                        appBar: AppBar(
                          backgroundColor: backGroundColor,
                          leading: Container(),
                          leadingWidth: 0,
                          elevation: 0,
                          centerTitle: true,
                          title: Text(
                            'Warning',
                            style: TextStyle(color: Colors.red, fontSize: 25),
                          ),
                        ),
                        body: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Please carefully read below before exiting',
                                    style: GoogleFonts.openSans(
                                      color: textColor,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Text(
                                      'You have not completed you exam yet. If you exit right now you will be marked ZERO.',
                                      style: GoogleFonts.openSans(
                                          color: textColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: buttonColor,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        shadowColor: backGroundColor,
                                        padding: EdgeInsets.fromLTRB(
                                            10, 10, 10, 10)),
                                    onPressed: () {
                                      Get.close(1);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Icon(
                                            Icons.done_outline_rounded,
                                            color: Colors.green,
                                            size: 30,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 20, 0),
                                          child: AutoSizeText(
                                            'Continue with Exam',
                                            minFontSize: 20,
                                            style: GoogleFonts.poppins(
                                                color: textColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: buttonColor,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        shadowColor: backGroundColor,
                                        padding: EdgeInsets.fromLTRB(
                                            10, 10, 10, 10)),
                                    onPressed: () {
                                      Get.close(2);
                                      Fluttertoast.showToast(
                                          msg: 'You have been marked zero.',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.black,
                                          fontSize: 16.0);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 20, 0),
                                          child: AutoSizeText(
                                            'Exit & Fail',
                                            minFontSize: 20,
                                            style: GoogleFonts.poppins(
                                                color: textColor,
                                                fontWeight: FontWeight.w600),
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
          return false;
        });
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
