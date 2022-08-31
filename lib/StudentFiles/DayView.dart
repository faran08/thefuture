// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thefuture/StudentFiles/ArticleView.dart';
import 'package:thefuture/StudentFiles/VideoView.dart';
import 'package:thefuture/globals.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DayView extends StatelessWidget {
  DateTime heading;
  QuerySnapshot<Object?> inputDocument;
  DayView({Key? key, required this.heading, required this.inputDocument})
      : super(
          key: key,
        );

  List<Map> currentDayDocuments = [];
  void getMyDocument() {
    currentDayDocuments.clear();
    for (var element in inputDocument.docs) {
      DateTime dateOfEntry = DateTime.fromMillisecondsSinceEpoch(
          ((element.data() as Map)['dateForWhichURL'] as Timestamp)
              .millisecondsSinceEpoch);
      if (dateOfEntry.day == heading.day) {
        currentDayDocuments.add(element.data() as Map);
      }
    }
  }

  Widget getDocumentView(Map inputData) {
    if (inputData['entryType'] == 'Article') {
      return ListTile(
        onTap: () {
          Get.to(ArticleView(articleURL: inputData['URL']));
        },
        trailing: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: AutoSizeText(
              'Article',
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
        ),
        title: AutoSizeText(
          inputData['entryDescription'],
          style: GoogleFonts.poppins(
              color: textColor, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: AutoSizeText(
          inputData['URL'],
          style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.5),
              fontWeight: FontWeight.normal,
              fontSize: 12),
        ),
      );
    } else if (inputData['entryType'] == 'Video') {
      return ListTile(
        onTap: () {
          Get.to(VideoView(inputURL: inputData['URL']))!.whenComplete(() {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeRight,
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
          });
        },
        trailing: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: AutoSizeText('Video',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: textColor)),
          ),
        ),
        title: AutoSizeText(
          inputData['entryDescription'],
          style: GoogleFonts.poppins(
              color: textColor, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: AutoSizeText(
          inputData['URL'],
          style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.5),
              fontWeight: FontWeight.normal,
              fontSize: 12),
        ),
      );
    } else {
      return ListTile(
        onTap: () {
          Get.to(ArticleView(articleURL: inputData['URL']));
        },
        trailing: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: AutoSizeText(
              'Audio',
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
        ),
        title: AutoSizeText(
          inputData['entryDescription'],
          style: GoogleFonts.poppins(
              color: textColor, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: AutoSizeText(
          inputData['URL'],
          style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.5),
              fontWeight: FontWeight.normal,
              fontSize: 12),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    getMyDocument();
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
          leadingWidth: 0,
          leading: Container(),
          centerTitle: true,
          elevation: 0,
          backgroundColor: backGroundColor,
          title: AutoSizeText(
            DateFormat('dd MMM yyyy').format(heading),
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 25, fontWeight: FontWeight.bold),
          )),
      body: currentDayDocuments.isNotEmpty
          ? ListView.builder(
              itemCount: currentDayDocuments.length,
              itemBuilder: ((context, index) {
                return getDocumentView(currentDayDocuments[index]);
              }))
          : Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.not_interested_rounded,
                    color: textColor,
                    size: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: AutoSizeText('No Data Available',
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
    );
  }
}
