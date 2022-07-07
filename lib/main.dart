import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterTts flutterTts = FlutterTts();
  TextEditingController controller = TextEditingController();

  double volume = 1.0;
  double pitch = 1.0;
  double speechRate = 0.5;
  List<String>? languages;
  String langCode = "en-US";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    languages = List<String>.from(await flutterTts.getLanguages);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Text To Speech"),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Center(
            child: Column(children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 200,
                    height: 60,
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Text',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    child: const Text("Speak"),
                    onPressed: _speak,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    child: const Text("Stop"),
                    onPressed: _stop,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Volume",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Slider(
                      min: 0.0,
                      max: 1.0,
                      value: volume,
                      onChanged: (value) {
                        setState(() {
                          volume = value;
                        });
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                          double.parse((volume).toStringAsFixed(2)).toString(),
                          style: const TextStyle(fontSize: 17)),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Pitch",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Slider(
                      min: 0.5,
                      max: 2.0,
                      value: pitch,
                      onChanged: (value) {
                        setState(() {
                          pitch = value;
                        });
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                          double.parse((pitch).toStringAsFixed(2)).toString(),
                          style: const TextStyle(fontSize: 17)),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Speech Rate",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Slider(
                      min: 0.0,
                      max: 1.0,
                      value: speechRate,
                      onChanged: (value) {
                        setState(() {
                          speechRate = value;
                        });
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                          double.parse((speechRate).toStringAsFixed(2))
                              .toString(),
                          style: const TextStyle(fontSize: 17)),
                    )
                  ],
                ),
              ),
              if (languages != null)
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      const Text(
                        "Language :",
                        style: TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      DropdownButton<String>(
                        focusColor: Colors.white,
                        value: langCode,
                        style: const TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.black,
                        items: languages!
                            .map<DropdownMenuItem<String>>((String? value) {
                          return DropdownMenuItem<String>(
                            value: value!,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            langCode = value!;
                          });
                        },
                      ),
                    ],
                  ),
                )
            ]),
          ),
        ));
  }

  void initSetting() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.setLanguage(langCode);
  }

  void _speak() async {
    initSetting();
    await flutterTts.speak(controller.text);
  }

  void _stop() async {
    await flutterTts.stop();
  }
}
