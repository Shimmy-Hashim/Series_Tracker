import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(
      title: "Series Tracker",
      home: TrackerApp(),
    ));

class TrackerApp extends StatefulWidget {
  const TrackerApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TrackerApp();
  }
}

class _TrackerApp extends State<TrackerApp> {
  late List<Map<dynamic,dynamic>> series = [];
  final _formKey = GlobalKey<FormState>();
  final seriesController = TextEditingController();
  final seasonController = TextEditingController();
  final episodeController = TextEditingController();


  Future setData(List<Map> data) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> dataString = [];
    data.forEach((element) {
      dataString.add(json.encode(element));
    });
    preferences.setStringList('data', dataString);
  }

  void getData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      List<String> dataString =
          preferences.getStringList('data') ?? [];
      List<Map> data = [];
      if (dataString.isNotEmpty) {
        dataString.forEach((element) {
          data.add(json.decode(element));
        });
      }
      series = data;
    });
  }

  @override
  void initState(){
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                await showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: Colors.cyanAccent,
                          content: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Positioned(
                                right: -40,
                                top: -40,
                                child: InkResponse(
                                  onTap: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    } else {
                                      SystemNavigator.pop();
                                    }
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close),
                                  ),
                                ),
                              ),
                              Text("How to use?\n\nClick on the '+' icon on the bottom right hand conner of your screen to add a Series/Manga you are watching/reading\n\n"
                                  "Add the Series Name, current Season and Episode which you are currently watching and click the Submit Button.\n\n"
                                  "Once doing so the form will close and your newly enter Series should show up!\n\n"
                                  "The '+' and '-' buttons will increase the Season/Episode you are on.\n\n"
                                  "CLick the Finish Series to remove the Series from your List.",
                                  style: GoogleFonts.openSans(
                                      textStyle:
                                          const TextStyle(fontSize: 15))),
                            ],
                          ),
                        ));
              },
              color: Colors.white,
              icon: const Icon(Icons.question_mark_outlined)),
        ],
        backgroundColor: Colors.teal,
        title: Text('Series Tracker', style: GoogleFonts.openSans()),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: series.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.circular(30.0)),
              height: 250,
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Series: ${series[index]["series"]}",
                        style: GoogleFonts.openSans(
                            textStyle: const TextStyle(fontSize: 20)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            series.removeAt(index);
                            setData(series);
                          });
                        },
                        child: Text("Finish Series",
                            style: GoogleFonts.openSans(
                                textStyle: const TextStyle(fontSize: 15))),
                      ),
                    ],
                  )),
                  Text('Season/Volume: ${series[index]["season"]}',
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(fontSize: 20))),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            series[index]["season"]++;
                            setData(series);
                          });
                        },
                        child: const Icon(Icons.add),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            if (series[index]["season"] <= 0) {
                              series[index]["season"] = 0;
                              setData(series);
                            } else {
                              series[index]["season"]--;
                              setData(series);
                            }
                          });
                        },
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  )),
                  Text('Episode/Chapter: ${series[index]["episodes"]}',
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(fontSize: 20))),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            series[index]["episodes"]++;
                            setData(series);
                          });
                        },
                        child: const Icon(Icons.add),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            if (series[index]["episodes"] <= 0) {
                              series[index]["episodes"] = 0;
                              setData(series);
                            } else {
                              series[index]["episodes"]--;
                              setData(series);
                            }
                          });
                        },
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.tealAccent,
          child: const Icon(Icons.add),
          onPressed: () async {
            await showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                      backgroundColor: Colors.cyanAccent,
                      content: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Positioned(
                            right: -40,
                            top: -40,
                            child: InkResponse(
                              onTap: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                } else {
                                  SystemNavigator.pop();
                                }
                              },
                              child: const CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close),
                              ),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: TextFormField(
                                    controller: seriesController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Series Name.',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: TextFormField(
                                    controller: seasonController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Starting Season.',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: TextFormField(
                                    controller: episodeController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Starting Episode.',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ElevatedButton(
                                    child: const Text('Submit'),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        setState(() {
                                          series.add({
                                            "series": seriesController.text,
                                            "season": int.parse(
                                                seasonController.text),
                                            "episodes": int.parse(
                                                episodeController.text)
                                          });
                                          seriesController.clear();
                                          seasonController.clear();
                                          episodeController.clear();
                                          setData(series);
                                        });
                                        if (Navigator.canPop(context)) {
                                          Navigator.pop(context);
                                        } else {
                                          SystemNavigator.pop();
                                        }
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ));
          }),
    );
  }
}

//How to use page and done!
