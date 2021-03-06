import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts_improved/flutter_tts_improved.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/constants/theme_data.dart';

class GetsJson extends StatelessWidget {
  final String category;
  const GetsJson({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String jsonLoad = "assets/vocab/$category.json";
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString(jsonLoad, cache: false),
      builder: (context, snapshot) {
        List myData = json.decode(snapshot.data.toString());
        if (myData == null) {
          return Scaffold(
            body: Center(
              child: Text(
                "Loading",
              ),
            ),
          );
        } else {
          return CertainVocabPage(category: category, myData: myData);
        }
      },
    );
  }
}

class CertainVocabPage extends StatefulWidget {
  final List myData;
  final String category;
  CertainVocabPage({this.category, this.myData});
  @override
  _CertainVocabPageState createState() => _CertainVocabPageState();
}

class _CertainVocabPageState extends State<CertainVocabPage> {
  FlutterTtsImproved flutterTtsImproved = FlutterTtsImproved();
  int index = 0;
  bool isActive;
  String next = 'Next';
  String previous = 'Previous';

  @override
  void initState() {
    super.initState();
    flutterTtsImproved.setLanguage("en-US");
    isActive = false;
  }

  previousVocab() {
    if (index > 0) {
      index = index - 1;
      isActive = false;
      setState(() {});
    }
    if (index == -1) {
      Navigator.pop(context);
    }
  }

  nextVocab() {
    if (index < widget.myData.length - 1) {
      index = index + 1;
      isActive = false;

      setState(() {});
    }
    if (index == widget.myData.length) {
      //index = 0;
      Navigator.pop(context);
    }
  }

  speakText() {
    flutterTtsImproved.speak(widget.myData[index]['word']);
    setState(() {
      isActive = !isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColor.backgroundTest,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 60, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(widget.category.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                  height: size.height / 1.5,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black,
                  ),
                ),
                Container(
                  height: size.height / 1.7,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.myData[index]['word'],
                            style: GoogleFonts.openSans(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                        Text(widget.myData[index]['phonetics']),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            speakText();
                          },
                          child: Icon(
                            Icons.headset_rounded,
                            color: isActive ? Colors.blue : Colors.black,
                          ),
                        ),
                        Text(widget.myData[index]['meaning'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        SizedBox(
                          height: 50,
                        ),
                        Column(
                          children: [
                            Text(widget.myData[index]['example'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.openSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text(
                              widget.myData[index]['exampleMeaning'],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlatButton(
                  color: index == 0 ? Colors.red : Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onPressed: () {
                    if (index == 0) {
                      index = index - 1;
                    }
                    previousVocab();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      index == 0 ? 'Topic' : "Previous",
                      style: GoogleFonts.openSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: CustomColor.textQuestion),
                    ),
                  ),
                ),
                FlatButton(
                  color: index == widget.myData.length - 1
                      ? Colors.red
                      : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onPressed: () {
                    if (index == widget.myData.length - 1) {
                      index = index + 1;
                    }
                    nextVocab();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      index == widget.myData.length - 1 ? "Topic" : "Next",
                      style: GoogleFonts.openSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: CustomColor.textQuestion),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
