import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quizapp/model.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // For Quiz List
  List<Quiz> quizes = [];
  int score = 0;
  int currentQuestion = 0;

// Reset
  void reset() {
    setState(() {
      score = 0;
      currentQuestion = 0;
    });
  }

  // Check Answer
  void checkAnswer(int userChocie) {
    setState(() {
      if (quizes[currentQuestion].correctoption == userChocie) {
        score++;
      }
      if (currentQuestion == quizes.length - 1) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Final Result"),
                  content:
                      Text("Your score is ${score} out of ${quizes.length}"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          reset();
                        },
                        child: Text("Play Again"))
                  ],
                ));
        return;
      }
      currentQuestion++;
    });
  }

  // Get Data From API

  Future getData() async {
    String url =
        "http://192.168.2.104/v1/databases/63fc7fd8d3ba22aa069f/collections/63fc800a81afa1ff990a/documents";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'X-Appwrite-Project': '63fc7fbca856b6f22fc3',
    });
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        for (var item in jsonDecode(response.body)["documents"]) {
          quizes.add(Quiz(item['title'], item['option1'], item['option2'],
              item['option3'], item['option4'], item['correctoption']));
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          reset();
        }),
        child: const Icon(Icons.refresh),
      ),
      body: quizes.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // For Question
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    height: 100,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Q.N. ${currentQuestion + 1}) ${quizes[currentQuestion].title}",
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {
                        checkAnswer(1);
                      },
                      child: Text(
                        "A. ${quizes[currentQuestion].option1}",
                        style: TextStyle(fontSize: 18),
                      ),
                      color: Colors.green,
                      minWidth: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {
                        checkAnswer(2);
                      },
                      child: Text(
                        "B. ${quizes[currentQuestion].option2}",
                        style: TextStyle(fontSize: 18),
                      ),
                      color: Colors.green,
                      minWidth: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {
                        checkAnswer(3);
                      },
                      child: Text(
                        "C. ${quizes[currentQuestion].option3}",
                        style: TextStyle(fontSize: 18),
                      ),
                      color: Colors.green,
                      minWidth: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {
                        checkAnswer(4);
                      },
                      child: Text(
                        "D. ${quizes[currentQuestion].option4}",
                        style: TextStyle(fontSize: 18),
                      ),
                      color: Colors.green,
                      minWidth: double.infinity,
                    ),
                  ),
                ],
              ),
            )
          : CircularProgressIndicator(),
    );
  }
}
