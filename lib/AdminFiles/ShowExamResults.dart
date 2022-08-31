// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:thefuture/AdminFiles/StateControllers.dart';
import 'package:thefuture/globals.dart';

class ShowExamResults extends StatelessWidget {
  String defineID = '';
  ShowExamResults({Key? key, required this.defineID}) : super(key: key);
  CollectionReference examResults =
      FirebaseFirestore.instance.collection('ExamResults');
  AdminStateControllers adminStateControllers =
      Get.put(AdminStateControllers());

  Set<DateTime> examDates = {};
  List<QueryDocumentSnapshot<Object?>> examResultsList = [];

  void getExamResultData() {
    EasyLoading.show();
    examResults.where('defineID', isEqualTo: defineID).get().then((value) {
      examResultsList = value.docs;
      for (var element in value.docs) {
        examDates
            .add(((element.data() as Map)['examDate'] as Timestamp).toDate());
      }
      EasyLoading.dismiss();
      adminStateControllers.update();
    });
  }

  DateTime getLastHourOfDate(DateTime input) {
    return DateTime(input.year, input.month, input.day, 24);
  }

  DateTime getFirstHourOfDate(DateTime input) {
    return DateTime(input.year, input.month, input.day, 0);
  }

  List<QueryDocumentSnapshot<Object?>> getStudentSortedResultSpecificDate(
      DateTime inputDate) {
    List<QueryDocumentSnapshot<Object?>> returnList = [];
    for (var element in examResultsList) {
      if (((element.data() as Map)['examDate'] as Timestamp)
              .toDate()
              .isAfter(getFirstHourOfDate(inputDate)) &&
          ((element.data() as Map)['examDate'] as Timestamp)
              .toDate()
              .isBefore(getLastHourOfDate(inputDate))) {
        returnList.add(element);
      }
    }
    return returnList;
  }

  List<ChartData> getChartDataForStudent(
      QueryDocumentSnapshot<Object?> inputData) {
    Map dataList = {};
    List<ChartData> chartData = [];
    double totalQuestions =
        ((inputData.data() as Map)['resultData'] as List).length.toDouble();
    for (var element in ((inputData.data() as Map)['resultData'] as List)) {
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

  @override
  Widget build(BuildContext context) {
    getExamResultData();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: backGroundColor,
          title: Text(
            'Results',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          elevation: 0,
        ),
        backgroundColor: backGroundColor,
        body: GetBuilder<AdminStateControllers>(builder: (_) {
          return examDates.isNotEmpty
              ? ListView.builder(
                  itemCount: examDates.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: Text(
                        DateFormat('dd MMM yyyy')
                            .format(examDates.elementAt(index)),
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      subtitle: Row(
                        children: [
                          TextButton(
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Colors.grey.shade300),
                              onPressed: () {
                                List<QueryDocumentSnapshot<Object?>>
                                    specificDateList =
                                    getStudentSortedResultSpecificDate(
                                        examDates.elementAt(index));
                                Get.bottomSheet(
                                    BottomSheet(
                                        enableDrag: false,
                                        onClosing: () {},
                                        builder: (context) {
                                          return SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.95,
                                            child: Scaffold(
                                              backgroundColor: backGroundColor,
                                              appBar: AppBar(
                                                backgroundColor:
                                                    backGroundColor,
                                                leading: Container(),
                                                leadingWidth: 0,
                                                elevation: 0,
                                                centerTitle: true,
                                                title: Text(
                                                  'Students',
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              body: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                child: ListView.builder(
                                                    itemCount:
                                                        specificDateList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return ListTile(
                                                        title: Text(
                                                          (specificDateList[
                                                                          index]
                                                                      .data()
                                                                  as Map)[
                                                              'studentID'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        subtitle: Text((specificDateList[
                                                                            index]
                                                                        .data()
                                                                    as Map)[
                                                                'correctAnswers'] +
                                                            ' / ' +
                                                            ((specificDateList[index]
                                                                            .data()
                                                                        as Map)[
                                                                    'resultData'] as List)
                                                                .length
                                                                .toString()),
                                                      );
                                                    }),
                                              ),
                                            ),
                                          );
                                        }),
                                    isScrollControlled: true);
                              },
                              child: Text(
                                'Complete List',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: textColor.withOpacity(0.8)),
                              )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor: Colors.grey.shade300),
                                onPressed: () {
                                  List<QueryDocumentSnapshot<Object?>>
                                      specificDateList =
                                      getStudentSortedResultSpecificDate(
                                          examDates.elementAt(index));
                                  Get.bottomSheet(
                                      BottomSheet(
                                          enableDrag: false,
                                          onClosing: () {},
                                          builder: (context) {
                                            return SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.95,
                                              child: Scaffold(
                                                backgroundColor:
                                                    backGroundColor,
                                                appBar: AppBar(
                                                  backgroundColor:
                                                      backGroundColor,
                                                  leading: Container(),
                                                  leadingWidth: 0,
                                                  elevation: 0,
                                                  centerTitle: true,
                                                  title: Center(
                                                    child: Text(
                                                      'Subject Chart',
                                                      style: TextStyle(
                                                          color: textColor,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                body: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 10),
                                                  child: ListView.builder(
                                                      itemCount:
                                                          specificDateList
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        List<ChartData>
                                                            chartData =
                                                            getChartDataForStudent(
                                                                specificDateList[
                                                                    index]);
                                                        return Container(
                                                            width: MediaQuery
                                                                    .of(context)
                                                                .size
                                                                .width,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.5,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      spreadRadius:
                                                                          0.5,
                                                                      blurRadius:
                                                                          2,
                                                                      color: textColor
                                                                          .withOpacity(
                                                                        0.5,
                                                                      ))
                                                                ]),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          10,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    (specificDateList[index]
                                                                            .data()
                                                                        as Map)['studentID'],
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child:
                                                                      SfCircularChart(
                                                                    legend: Legend(
                                                                        alignment:
                                                                            ChartAlignment
                                                                                .center,
                                                                        position:
                                                                            LegendPosition
                                                                                .bottom,
                                                                        orientation:
                                                                            LegendItemOrientation
                                                                                .horizontal,
                                                                        isVisible:
                                                                            true),
                                                                    series: <
                                                                        CircularSeries>[
                                                                      PieSeries<ChartData,
                                                                              String>(
                                                                          radius: (MediaQuery.of(context).size.width * 0.25)
                                                                              .toString(),
                                                                          strokeColor:
                                                                              textColor,
                                                                          strokeWidth:
                                                                              0,
                                                                          dataLabelSettings: DataLabelSettings(
                                                                              isVisible: true,
                                                                              textStyle: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 12),
                                                                              labelIntersectAction: LabelIntersectAction.shift,
                                                                              labelPosition: ChartDataLabelPosition.outside,
                                                                              connectorLineSettings: ConnectorLineSettings(type: ConnectorType.curve, length: '10%')),
                                                                          dataSource: chartData,
                                                                          pointColorMapper: (ChartData data, _) => data.color,
                                                                          xValueMapper: (ChartData data, _) => data.x,
                                                                          yValueMapper: (ChartData data, _) => data.y,
                                                                          dataLabelMapper: (ChartData data, _) => '${data.y}%'),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                            // ListTile(
                                                            //   title: Text(
                                                            //     (specificDateList[
                                                            //                     index]
                                                            //                 .data()
                                                            //             as Map)[
                                                            //         'studentID'],
                                                            //     style: TextStyle(
                                                            //         fontWeight:
                                                            //             FontWeight
                                                            //                 .bold,
                                                            //         fontSize: 18),
                                                            //   ),
                                                            //   subtitle: ,
                                                            // ),
                                                            );
                                                      }),
                                                ),
                                              ),
                                            );
                                          }),
                                      isScrollControlled: true);
                                },
                                child: Text('Subject Chart',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: textColor.withOpacity(0.8)))),
                          ),
                        ],
                      ),
                    );
                  }))
              : Text('Not Available');
        }));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
