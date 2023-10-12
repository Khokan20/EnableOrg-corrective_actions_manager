// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/dto/questionList_and_qnid_DTO.dart';
import 'package:enableorg/models/question_answer.dart';
import 'package:enableorg/models/user.dart';
import 'package:enableorg/ui/custom_slider.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../../controller/user/foundation_builder_controller.dart';
import '../../models/question.dart';

class FoundationBuilderPage extends StatefulWidget {
  final User user;

  FoundationBuilderPage({required this.user});

  @override
  _FoundationBuilderPageState createState() => _FoundationBuilderPageState();
}

class _FoundationBuilderPageState extends State<FoundationBuilderPage> {
  late FoundationBuilderController controller;
  late Future<QuestionListAndQnidDTO> questionsFuture;
  int currentPageIndex = 0;
  int currentQuestionIndex = 0;
  List<int> questionResponses = List.filled(1000, 3);
  List<bool> questionsMoved = List<bool>.filled(13, false);
  @override
  void initState() {
    super.initState();
    controller = FoundationBuilderController(currentUser: widget.user);
    questionsFuture = controller.getQuestions(widget.user);
  }

  void onNextPressed() async {
    QuestionListAndQnidDTO questionsAndQnid = await questionsFuture;
    List<Question> questions = questionsAndQnid.qList;
    String? qnid = questionsAndQnid.qnid;
    if (currentPageIndex < questions.length ~/ 12 + 1) {
      List<Question> currentPageQuestions = questions.sublist(
        currentPageIndex * 12,
        min((currentPageIndex + 1) * 12, questions.length),
      );

      List<int> currentPageResponses = questionResponses.sublist(
        currentPageIndex * 12,
        min((currentPageIndex + 1) * 12, questions.length),
      );

      List<QuestionAnswer> questionAnswers = [];

      for (var i = 0; i < currentPageQuestions.length; i++) {
        var question = currentPageQuestions[i];
        var answer = currentPageResponses[i];

        QuestionAnswer questionAnswer = QuestionAnswer(
          qnid: qnid!,
          qaid: randomAlpha(30),
          creationTimestamp: Timestamp.now(),
          answer: answer,
          qid: question.qid,
          uid: widget.user.uid,
        );

        questionAnswers.add(questionAnswer);
      }

      await controller.saveAndNext(questionAnswers);
    }
    setState(() {
      currentPageIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foundation Builder'),
      ),
      body: Column(
        children: [
          Container(
            // color: Colors.blue,
            height: 500,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 500,
                    width: 65,
                    child: Center(
                      child: Transform(
                        transform: Matrix4.identity()
                          ..translate(0.0, 0.0)
                          ..rotateZ(-1.57),
                        child: Container(
                          width: 71,
                          height: 29,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 287,
                                top: 20,
                                child: Text(
                                  'Strongly disagree',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 15, 7, 7),
                                    fontSize: 20,
                                    fontFamily: 'Cormorant Garamond',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    //color: Colors.blue,
                    width: 500,
                    child: Container(
                      width: 671,
                      child: FutureBuilder<QuestionListAndQnidDTO>(
                        future: questionsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData) {
                            return Center(
                              child: Text('No questions available.'),
                            );
                          } else {
                            QuestionListAndQnidDTO questionsAndQnid =
                                snapshot.data!;
                            List<Question> questions = questionsAndQnid.qList;
                            // questionResponses = List<int>.filled(questions.length, 4);
                            List<Question> currentPageQuestions;
                            if (currentPageIndex * 12 <= questions.length) {
                              currentPageQuestions = questions.sublist(
                                currentPageIndex * 12,
                                min((currentPageIndex + 1) * 12,
                                    questions.length),
                              );
                            } else {
                              currentPageQuestions = [];
                            }

                            Widget pageContent;

                            if (currentPageQuestions.isEmpty) {
                              pageContent = Center(
                                child: Text(
                                  'No questions available. You have completed all your questions :)',
                                ),
                              );
                            } else {
                              pageContent = ListView.builder(
                                itemCount: currentPageQuestions.length,
                                itemBuilder: (context, index) {
                                  Question question =
                                      currentPageQuestions[index];
                                  int questionIndex =
                                      currentPageIndex * 12 + index;

                                  return Column(
                                    children: [
                                      Text(
                                          textAlign: TextAlign.left,
                                          question.question),
                                      CustomSlider(
                                        sliderValue:
                                            questionResponses[questionIndex]
                                                .toDouble(),
                                        onChanged: (double value) {
                                          setState(() {
                                            questionResponses[questionIndex] =
                                                value.toInt();
                                            setState(() {});
                                          });
                                        },
                                        label: questionResponses[questionIndex]
                                            .toString(),
                                        onSliderMoved: (sliderMoved) {
                                          setState(() {
                                            questionsMoved[questionIndex] =
                                                sliderMoved; // Update saveEnable based on slider movement
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }

                            return Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 16.0),
                                    child: pageContent,
                                  ),
                                ),
                                if (currentPageQuestions.isNotEmpty)
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (questionsMoved
                                            .sublist(
                                                0, currentPageQuestions.length)
                                            .every((element) =>
                                                element)) // All of them are true
                                          SizedBox(
                                            width: 150,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                onNextPressed(); // Call the original onChanged callback
                                                questionsMoved = List<
                                                        bool>.filled(13,
                                                    false); // Initialize questionsMoved
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 12, 67, 111),
                                                shape:
                                                    ContinuousRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              child: Text(
                                                'Next',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(1.57),
                  child: Container(
                    width: 165,
                    height: 29,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 259,
                          top: 3,
                          child: SizedBox(
                            width: 180,
                            child: Text(
                              'Strongly agree',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF6E6E6E),
                                fontSize: 20,
                                fontFamily: 'Cormorant Garamond',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
